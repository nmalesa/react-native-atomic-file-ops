import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'
import _ from 'lodash'

export const readFile = async (path, encoding) => {
  try {
    if (!path || typeof path !== 'string') {
      throw new Error('readFile: Path must be a string.')
    }
    
    const fileExists = await RNFS.exists(path)
    if (!fileExists) {
      throw new Error('readFile: File does not exist.')
    }

    const data = await RNFS.readFile(path, encoding)
    return data
  } catch (error) {
    console.error('readFile: ', error)
  }
}

export const deleteFile = async path => {
  try {
    await RNFS.unlink(path);
    console.log('FILE DELETED!');
  } catch (error) {
    console.log('deleteFile: ', error);
  }
};

export const getPathOfFetchedHTTPFile = async url => {
  if (!url) {
    const error = new Error('pathOfFetchedHTTPFile: Missing URL');
    error.internal = true;
    throw error;
  }

  try {
    const fileName = url.split('/').pop();
    const directory = RNFS.DocumentDirectoryPath

    if (!directory) {
      await RNFS.mkdir(directory);
    }

    const filePath = `${directory}/${fileName}`;
    return filePath;
  } catch (error) {
    console.error(error);
  }
};

export const deleteFetchedHTTPFile = async url => {
  try {
    const fileName = url.split('/').pop();
    const filePath = RNFS.DocumentDirectoryPath + `/${fileName}`;
    return await RNFS.unlink(filePath);
  } catch (error) {
    console.log('deleteFetchedHTTPFile: ', error);
  }
};

export const getImageFileList = async () => {
  try {
    return await readImageDir();
  } catch (error) {
    console.log(error);
    return null;
  }
};

export const readImageDir = async () => {
  const directory = _.get(RNFS, 'DocumentDirectoryPath', null);
  const imageDir = `${directory}/image`

  let imageDirExists = null

  try {
    imageDirExists = await RNFS.exists(imageDir)
  } catch (error) {
    imageDirExists = false
  }

  const imageMetaPath = `${imageDir}/meta.json`

  let imageMetaExists = null
  try {
    imageMetaExists = await RNFS.exists(imageMetaPath)
  } catch (error) {
    imageMetaExists = false
  }
 
  if (!imageMetaExists) {
    await RNFS.mkdir(imageDir)
    await AtomicFileOps.writeFile(imageMetaPath, JSON.stringify([]), 'utf8')
  }

  const metaData = await parseMetaFile(imageMetaPath)

  console.log('Metadata: ', metaData)
  return metaData
};

export const parseMetaFile = async metaPath => {
  const metaJSON = await readFile(metaPath, 'utf8')
  let meta = null
  try {
    meta = JSON.parse(metaJSON)
  } catch {
    meta = []
  }
    /*
    check the meta file integrity by looking that all the files in this dir
    are present, if not remove them from meta.
  */
  const errors = 0
  const checkedMeta = []
  for (let i = 0; i < meta.length; i++) {
    const row = meta[i]
    const filePath = `${row.path}/${row.filename}`
    try {
      const fileExist = await RNFS.exists(filePath)
      if (fileExist) {
        checkedMeta.push(row)
      } else {
        errors += 1
      }
    } catch (e) {
      errors += 1
    }
  }

  if (errors) {
    // overwrite meta file
    await AtomicFileOps.writeFile(metaPath, JSON.stringify(checkedMeta), 'utf8')
  }

  return checkedMeta
}

export const hasFreeStorage = async () => {
  const minFreeStorageBytes = 500 * 10 ** 6;
  const diskInfo = await RNFS.getFSInfo();
  return _.get(diskInfo, 'freeSpace', 0) > minFreeStorageBytes;
};

export const downloadExternalFile = async config => {
  try {
    const fileName = _.get(config, 'fileName', null);
    const headers = _.get(config, 'headers', {});
    const url = _.get(config, 'url', null);

    if (!fileName || !url) {
      const error = new Error('downloadExternalFile: Missing parameters');
      error.internal = true;
      throw error;
    }

    let directory = _.get(RNFS, 'DocumentDirectoryPath', null);
    let filePath = `${directory}/${fileName}`;

    // THROWING ERROR:  HASFREESTORAGE IS NOT A FUNCTION
    // const hasFreeStorage = await hasFreeStorage();
    // if (!hasFreeStorage) {
    //   throw new Error('Error.  Phone storage is almost full.');
    // }

    const dlResults = await RNFS.downloadFile({
      headers,
      fromUrl: encodeURI(url), // URL to download file from
      toFile: `${filePath}`, // Local filesystem path to save the file to
      background: true, // Continue the download in the background after the app terminates (iOS only)
      discretionary: true, // Allow the OS to control the timing and speed of the download to improve perceived performance  (iOS only)
      cacheable: false, // Whether the download can be stored in the shared NSURLCache (iOS only, defaults to true)
    }).promise;

    if (Platform.OS === 'ios') {
      RNFS.completeHandlerIOS(dlResults.jobId);
    }

    const statusCode = _.get(dlResults, 'statusCode', 400);
    if (statusCode < 200 || statusCode >= 400) {
      throw new Error(
        'There was an error downloading this external file.  Please try again later.',
      );
    }
    console.log('Download external file.');
  } catch (error) {
    throw error;
  }
};




export const fetchHTTPFile = async url => {
  try {
    const fileName = url.split('/').pop();

    if (!fileName) {
      const error = new Error('getPathforContentFile: Missing file name');
      error.internal = true;
      throw error;
    }

    let directory = _.get(RNFS, 'DocumentDirectoryPath', null);
    // let filePath = `${directory}/${fileName}`;

    if (!directory) {
      await RNFS.mkdir(directory);
    }

    await downloadExternalFile({
      fileName,
      url,
    });
  } catch (error) {
    console.error('Error: ', error);
  }
};
