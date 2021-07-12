import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'
import { FileHandler } from '../datastructs/FileHandler';

const fileName = 'CavyTest.json'
const directory = RNFS.DocumentDirectoryPath
const filePath = `${directory}/${fileName}`;


export default function (spec) {
  spec.describe('tests react-native-atomic-file-ops', function () {
    spec.beforeEach(async () => {
      // Make sure file does not already exist
      if (await RNFS.exists(filePath)) {
        await RNFS.unlink(filePath);
      }
    })

    spec.it('overwrites JSON', async function () {
      // Write the file
      await AtomicFileOps.writeFile(filePath, "[{\"Guinea pig\": \"Cavia porcellus\"}]", 'UTF8')

      // Overwrite the same file with shorter JSON data
      await AtomicFileOps.writeFile(filePath, "[{\"Cat\": \"Felis catus\"}]", 'UTF8')

      const content = await RNFS.readFile(filePath, 'utf8') 
      
      if (content !== "[{\"Cat\": \"Felis catus\"}]") {
        throw 'Overwrites JSON Error:  Content does not match truncated input.'
      } 
    })
  })
}

