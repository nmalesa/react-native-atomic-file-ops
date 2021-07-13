import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'
import { FileHandler } from '../datastructs/FileHandler';

const fileName = 'CavyTest.json'
const directory = RNFS.DocumentDirectoryPath
const filePath = `${directory}/${fileName}`;
const remoteFilePath = 'https://live.staticflickr.com/7377/26722155994_5200abc340_b.jpg'


export default function (spec) {
  spec.describe('tests react-native-atomic-file-ops', function () {
    spec.beforeEach(async () => {
      // Make sure file does not already exist
      if (await RNFS.exists(filePath)) {
        await RNFS.unlink(filePath);
      }
    })

    // spec.it('overwrites JSON', async function () {
    //   // Write the file
    //   await AtomicFileOps.writeFile(filePath, "[{\"Guinea pig\": \"Cavia porcellus\"}]", 'UTF8')

    //   // Overwrite the same file with shorter JSON data
    //   await AtomicFileOps.writeFile(filePath, "[{\"Cat\": \"Felis catus\"}]", 'UTF8')

    //   const content = await RNFS.readFile(filePath, 'utf8') 
      
    //   if (content !== "[{\"Cat\": \"Felis catus\"}]") {
    //     throw 'Overwrites JSON Error:  Content does not match truncated input.'
    //   } 
    // })

    spec.it('handles Base64', async function () {
      const filePath = await FileHandler.getPathOfFetchedHTTPFile(remoteFilePath);

      console.log(filePath)

      if (await RNFS.exists(filePath)) {
        await FileHandler.deleteFetchedHTTPFile(remoteFilePath);
      }

      const fileExists = await RNFS.exists(filePath);
  
      if (fileExists) {
        throw new Error('File cannot exist before we fetch it.');
      }

      await FileHandler.fetchHTTPFile(remoteFilePath);

      await spec.pause(2000); // Needs to be long enough that the fetch completes

      const fileExistsNow = await RNFS.exists(filePath);

      console.log('File Exists Now: ', fileExistsNow)

      // debugger
      // NOTE:  In article, make a note about how the debugger is helpful to pause and see what's being logged
      if (!fileExistsNow) {
        throw new Error('File does not exist after we fetched it.');
      }

      const content = await RNFS.readFile(filePath, 'base64')

      console.log('Content: ', content)
    });

  })
}

