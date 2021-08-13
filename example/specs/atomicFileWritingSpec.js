import { Platform } from 'react-native'
import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'

const fileName = 'AtomicFileOpsCavy.test'
const directory = RNFS.DocumentDirectoryPath
const filePath = `${directory}/${fileName}`
const testDir = '/data/user/0/com.example.reactnativeatomicfileops/files/AtomicFileOpsCavy.test'


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
      await AtomicFileOps.writeFile(fileName, "[{\"Guinea pig\": \"Cavia porcellus\"}]", 'UTF8')

      // Overwrite the same file with shorter JSON data
      await AtomicFileOps.writeFile(fileName, "[{\"Cat\": \"Felis catus\"}]", 'UTF8')

      const content = await RNFS.readFile(fileName, 'utf8') 
      
      if (content !== "[{\"Cat\": \"Felis catus\"}]") {
        throw 'Overwrites JSON Error:  Content does not match truncated input.'
      } 
    })

    spec.it('handles Base64', async function () {
      // Write the file
      await AtomicFileOps.writeFile(testDir, "Guinea pig", 'BASE64')
      /*
      'Guinea pig' in Base64
      Android:  R3VpbmVhIHBpZw==
      iOS:  UjNWcGJtVmhJSEJwWnc9PQ==
      */
    
      // Overwrite the same file with shorter data
      await AtomicFileOps.writeFile(testDir, "Cat", 'BASE64')
      /*
      'Cat' in Base64
      Android:  Q2F0
      iOS:  UTJGMA==
      */

      const content = await RNFS.readFile(testDir, 'base64')

      if (Platform.OS === 'android') {
        if (content !== 'Q2F0') {
          throw 'Overwrites Base64 error:  Content does not match truncated input.'
        }
      } else {
        if (content !== 'UTJGMA==') {
          throw 'Overwrites Base64 error:  Content does not match truncated input.'
        }
      }
    })
  })
}

