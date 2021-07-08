import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'
import _ from 'lodash'

export class FileHandler {
  getImageFileList = async () => {
    try {
      return await readImageDir();
    } catch (error) {
      console.log(error);
      return null;
    }
  };

  static readImageDir = async () => {
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

  static parseMetaFile = async metaPath => {
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
}



// export const getPathOfFetchedHTTPFile = async url => {
//   if (!url) {
//     const error = new Error('pathOfFetchedHTTPFile: Missing URL');
//     error.internal = true;
//     throw error;
//   }

//   try {
//     const fileName = url.split('/').pop();
//     const directory = RNFS.DocumentDirectoryPath

//     if (!directory) {
//       await RNFS.mkdir(directory);
//     }

//     const filePath = `${directory}/${fileName}`;
//     return filePath;
//   } catch (error) {
//     console.error(error);
//   }
// };

// export const deleteFetchedHTTPFile = async url => {
//   try {
//     const fileName = url.split('/').pop();
//     const filePath = RNFS.DocumentDirectoryPath + `/${fileName}`;
//     return await RNFS.unlink(filePath);
//   } catch (error) {
//     console.log('deleteFetchedHTTPFile: ', error);
//   }
// };





