import RNFS from 'react-native-fs';
import AtomicFileOps from 'react-native-atomic-file-ops'

const fileName = 'AtomicFileOps_Cavy.test'
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

    spec.it('handles Base64', async function () {
      // Write the file
      await AtomicFileOps.writeFile(filePath, "Guinea pig", 'BASE64')
      /*
      'Guinea pig' in Base64
      Android:  R3VpbmVhIHBpZw==
      iOS:  UjNWcGJtVmhJSEJwWnc9PQ==
      */

      const content = await RNFS.readFile(filePath, 'base64')
      console.log('First content: ', content)
    
      // Overwrite the same file with shorter data
      await AtomicFileOps.writeFile(filePath, "Cat", 'BASE64')

      const secondContent = await RNFS.readFile(filePath, 'base64')
       /*
      'Cat' in Base64
      Android:  Q2F0
      iOS:  UTJGMA==
      */

      console.log('Second content: ', secondContent)
      debugger

      if (secondContent !== 'Q2F0') {
        throw 'Overwrites Base64 error:  Content does not match truncated input.'
      }
    })
  })
}

