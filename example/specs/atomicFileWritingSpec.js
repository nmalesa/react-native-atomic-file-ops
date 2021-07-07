import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'
import FileHandler from '../datastructs/FileHandler';

export default function (spec) {
  spec.describe('tests react-native-atomic-file-ops', function () {
    spec.it('writes to a text file', async function () {
      const fileName = 'Cats.txt'
      const directory = RNFS.DocumentDirectoryPath

      if (!directory) {
        await RNFS.mkdir(directory);
      }

      const filePath = `${directory}/${fileName}`;
      console.log('FilePath: ', filePath)
      debugger

      await AtomicFileOps.writeFile(fileName, '😸😹😺😻', 'UTF8')

      const content = await RNFS.readFile(filePath, 'utf8') 

      await spec.pause(2000)

      console.log('Content: ', content)
      debugger

      if (content !== "😸😹😺😻") {
        throw 'Text File Error:  Content does not match input.'
      } else {
        console.log('Text File Content: ', content)
      }
    })

    spec.it('overwrites JSON', async function () {
      const fileName = 'CavyImageTest.json'
      const directory = RNFS.DocumentDirectoryPath
      const filePath = `${directory}/${fileName}`;

      // Make sure file does not already exist
      if (await RNFS.exists(filePath)) {
        await RNFS.unlink(filePath);
      }

      // Write out the file
      await AtomicFileOps.writeFile(fileName, "[{\"Guinea pig\": \"Cavia porcellus\"}]", 'UTF8')

      // Overwrite the same file with shorter JSON data
      await AtomicFileOps.writeFile(fileName, "[{\"Cat\": \"Felis catus\"}]", 'UTF8')

      const content = await RNFS.readFile(filePath, 'utf8') 
      
      if (content !== "[{\"Cat\": \"Felis catus\"}]") {
        throw 'Overwrites JSON Error:  Content does not match input.'
      } else {
        console.log('Overwrites JSON Content: ', content)
      }

      // Clean up
      if (await RNFS.exists(filePath)) {
        await RNFS.unlink(filePath);
      }
    })
    
    spec.it('fixes corrupted image metadata file', async function () {
      try {
        const emptyList = await FileHandler.getImageFileList()
   
        if (emptyList.length != 0) {
          throw 'List should be empty.'
        }
      } catch (error) {
        console.log('Error from getImageFileList: ', error);
      }

      // Now corrupt the metadata file by writing garbage in it
      const directory = RNFS.DocumentDirectoryPath

      if (!directory) {
        await RNFS.mkdir(directory);
      }

      const imageDir = `${directory}/image`
      const imageMetaPath = `${imageDir}/meta.json`

      await AtomicFileOps.writeFile(imageMetaPath, 'rkP7P3bu;.><5I/V?', 'utf8')

      const shouldStillBeEmptyList = await FileHandler.getImageFileList()

      if (shouldStillBeEmptyList.length != 0) {
        throw 'List should be empty.'
      }
    })
  })
}

