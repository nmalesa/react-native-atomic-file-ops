import { Platform } from 'react-native';
import AtomicFileOps from 'react-native-atomic-file-ops';
import RNFS from 'react-native-fs';

// You will write your data to fileName
const fileName = 'AtomicFileOpsCavy.test';

// filePath provides the absolute path to the file
const filePath = `${RNFS.DocumentDirectoryPath}/${fileName}`;

export default function (spec) {
  spec.describe('tests react-native-atomic-file-ops', function () {
    spec.beforeEach(async function () {
      try {
        // Make sure Cavy connects to React Native helper component
        await spec.exists('AtomicFileWriterWrapper');

        // Make sure file does not already exist
        if (await RNFS.exists(filePath)) {
          await RNFS.unlink(filePath);
        }
      } catch (error) {
        throw error;
      }
    });

    spec.it('overwrites JSON', async function () {
      try {
        /*
         * Write data to the file
         * @param {string} fileName
         * @param {string} contents
         * @param {string} encoding Supports “utf8”, “ascii”, and “base64” character sets
         */
        await AtomicFileOps.writeFile(
          fileName,
          "[{'Guinea pig': 'Cavia porcellus'}]",
          'utf8',
        );

        // Overwrite the same file with a shorter data string
        await AtomicFileOps.writeFile(
          fileName,
          "[{'Cat': 'Felis catus'}]",
          'utf8',
        );

        // Read the data back from the file, and assign it to a variable
        const content = await RNFS.readFile(filePath, 'utf8');

        // Check that the contents of the file are uncorrupted and match the expected truncated data
        if (content !== "[{'Cat': 'Felis catus'}]") {
          throw 'Overwrites JSON Error:  Content does not match truncated input.';
        }
      } catch (error) {
        throw error;
      }
    });

    spec.it('handles Base64', async function () {
      try {
        // Write data to the file
        await AtomicFileOps.writeFile(fileName, 'Guinea pig', 'base64');
        /*
        'Guinea pig' in Base64
        Android:  R3VpbmVhIHBpZw==
        iOS:  UjNWcGJtVmhJSEJwWnc9PQ==
        */

        // Overwrite the same file with a shorter data string
        await AtomicFileOps.writeFile(fileName, 'Cat', 'base64');
        /*
        'Cat' in Base64
        Android:  Q2F0
        iOS:  UTJGMA==
        */

        const content = await RNFS.readFile(filePath, 'base64');

        if (Platform.OS === 'android') {
          if (content !== 'Q2F0') {
            throw 'Overwrites Base64 error:  Content does not match truncated input.';
          }
        } else {
          if (content !== 'UTJGMA==') {
            throw 'Overwrites Base64 error:  Content does not match truncated input.';
          }
        }
      } catch (error) {
        throw error;
      }
    });
  });
}
