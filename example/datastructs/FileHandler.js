import RNFS from 'react-native-fs';
import _ from 'lodash'

export class FileHandler { 
  static deleteFetchedHTTPFile = async url => {
    try {
      const fileName = url.split('/').pop();
      const filePath = RNFS.DocumentDirectoryPath + `/${fileName}`;
      return await RNFS.unlink(filePath);
    } catch (error) {
      console.log('deleteFetchedHTTPFile: ', error);
    }
  };

  static hasFreeStorage = async () => {
    const minFreeStorageBytes = 500 * 10 ** 6;
    const diskInfo = await RNFS.getFSInfo();
    return _.get(diskInfo, 'freeSpace', 0) > minFreeStorageBytes;
  };
  
  static downloadExternalFile = async config => {
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
  
      const hasFreeStorage = await this.hasFreeStorage();
      if (!hasFreeStorage) {
        throw new Error('Error.  Phone storage is almost full.');
      }
  
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

  static fetchHTTPFile = async url => {
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
  
      await this.downloadExternalFile({
        fileName,
        url,
      });
    } catch (error) {
      console.error('Error: ', error);
    }
  };

  static getPathOfFetchedHTTPFile = async url => {
    if (!url) {
      throw new Error('pathOfFetchedHTTPFile: Missing URL');
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
}



