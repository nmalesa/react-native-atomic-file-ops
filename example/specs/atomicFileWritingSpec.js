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
  getImageFileList,
  deleteFile
} from '../datastructs/mediaManager';

export default function (spec) {
  spec.describe('tests react-native-atomic-file-ops', function () {
    spec.it('writes to a text file', async function () {
      const fileName = 'Cats.txt'
      const directory = await RNFS.DocumentDirectoryPath

      if (!directory) {
        await RNFS.mkdir(directory);
      }

      const filePath = `${directory}/${fileName}`;

      await AtomicFileOps.writeFile(fileName, "😸😹😺😻", 'UTF8')

      const content = await readFile(filePath, 'utf8') 

      if (content !== "😸😹😺😻") {
        throw 'Text File Error:  Content does not match input.'
      } else {
        console.log('Text File Content: ', content)
      }
    })

    spec.it('overwrites JSON', async function () {
      const fileName = 'Cavy_Image_Test.json'
      const directory = await RNFS.DocumentDirectoryPath
      const filePath = `${directory}/${fileName}`;

      // Make sure file does not already exist
      if (await RNFS.exists(filePath)) {
        await deleteFile(filePath);
      }

      // Write out the file
      await AtomicFileOps.writeFile(fileName, "[{\"Guinea pig\": \"Cavia porcellus\"}]", 'UTF8')

      // Overwrite the same file with shorter JSON data
      await AtomicFileOps.writeFile(fileName, "[{\"Cat\": \"Felis catus\"}]", 'UTF8')

      const content = await readFile(filePath, 'utf8') 
      
      if (content !== "[{\"Cat\": \"Felis catus\"}]") {
        throw 'Overwrites JSON Error:  Content does not match input.'
      } else {
        console.log('Overwrites JSON Content: ', content)
      }

      // Clean up
      if (await RNFS.exists(filePath)) {
        await deleteFile(filePath);
      }
    })
    
    spec.it('fixes corrupted image metadata file', async function () {
      try {
        const emptyList = await getImageFileList()
        if (emptyList.length != 0) {
          throw 'List should be empty.'
        }
      } catch (error) {
        console.log('Error from getImageFileList: ', error);
      }

      // Now corrupt the metadata file by writing garbage in it
      let directory = _.get(RNFS, 'DocumentDirectoryPath', null);
      let imageDirPath = `${directory}/image`
      const imageMetaPath = `${imageDirPath}/meta.json`

      await AtomicFileOps.writeFile(imageMetaPath, 'rkP7P3bu;.><5_/V?', 'utf8')

      const shouldStillBeEmptyList = await getImageFileList()

      if (shouldStillBeEmptyList.length != 0) {
        throw 'List should be empty.'
      }
    })
  })
}

