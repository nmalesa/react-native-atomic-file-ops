// import { hasValue } from './fileWritingTestHelper';

// export default function (spec) {
//   spec.describe('Atomic File Writing', function () {
//     spec.it('works', async function () {
//       await spec.exists('AtomicFileWriterWrapper');
//       await spec.fillIn('AtomicFileWriterWrapper', 'This is a Text String');
//       const element = await spec.findComponent('AtomicFileWriterWrapper');

//       await hasValue(element,'This is a Text String');
//     });
//   });

// }

import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'
import _ from 'lodash';
import {
  readFile,
  getPathOfFetchedHTTPFile,
  deleteFetchedHTTPFile,
  fetchHTTPFile,
  getImageFileList
} from '../datastructs/mediaManager';

const REMOTE_FILE_PATH =
  'https://live.staticflickr.com/7377/26722155994_5200abc340_b.jpg';

// Length = 147 characters
const IMAGE_1 = [
  {
    alt: 'Sasu the Guinea Pig',
    creator: 'andymiccone',
    url: 'https://live.staticflickr.com/7377/26722155994_5200abc340_b.jpg',
    license: 'CC0 1.0'
  }
]

// Length = 156 characters
const IMAGE_2 = [
  {
    alt: 'white and brown guinea pig on brown wood photo',
    creator: 'Amjith S',
    url: 'https://unsplash.com/photos/6p0Lym68MSI',
    license: 'Unsplash License'
  }
]

export default function (spec) {
  spec.describe('tests file system', function () {
    spec.it('fetches', async function () {
      const filePath = await getPathOfFetchedHTTPFile(REMOTE_FILE_PATH);

      if (await RNFS.exists(filePath)) {
        await deleteFetchedHTTPFile(REMOTE_FILE_PATH);
      }

      const fileExists = await RNFS.exists(filePath);
  
      if (fileExists) {
        throw new Error('File cannot exist before we fetch it.');
      }

      await fetchHTTPFile(REMOTE_FILE_PATH);

      await spec.pause(2000); // Needs to be long enough that the fetch completes

      const fileExistsNow = await RNFS.exists(filePath);

      console.log('File Exists Now: ', fileExistsNow)
      // NOTE:  In article, make a note about how the debugger is helpful to pause and see what's being logged
      if (!fileExistsNow) {
        throw new Error('File does not exist after we fetched it.');
      }
    });

    spec.it('overwrites metadata file', async function () {
      await AtomicFileOps.writeFile("cavy_test_image.json", JSON.stringify(IMAGE_2), 'utf8');

      await AtomicFileOps.writeFile("cavy_test_image.json", JSON.stringify(IMAGE_1), 'utf8');
    })
    
    // spec.it('fixes corrupted image metadata file', async function () {
    //   try {
    //     const emptyList = await getImageFileList()
    //     if (emptyList.length != 0) {
    //       throw 'List should be empty.'
    //     }
    //   } catch (error) {
    //     console.log('Error from getImageFileList: ', error);
    //   }

    //   // Now corrupt the metadata file by writing garbage in it
    //   let directory = _.get(RNFS, 'DocumentDirectoryPath', null);
    //   let imageDirPath = `${directory}/image`
    //   const imageMetaPath = `${imageDirPath}/meta.json`

    //   // await AtomicFileOps.writeFile(imageMetaPath, 'rkP7P3bu;.><5_/V?', 'utf8')

    //   const shouldStillBeEmptyList = await getImageFileList()

    //   if (shouldStillBeEmptyList.length != 0) {
    //     throw 'List should be empty.'
    //   }
    // })
  })
}

