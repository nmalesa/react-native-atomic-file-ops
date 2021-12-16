# react-native-atomic-file-ops
Atomically writing to a file on mobile avoids potential file corruption.  When writing atomically, the data is first written to a separate auxiliary file.  Once writing is successful, the auxiliary file is renamed to the path specified by the application.  When writing is not done atomically, the data is written directly to the path.  Writing atomically guarantees that the path and its data will not be corrupted even if a crash occurs during writing.

In our React Native app, we encountered a bug with Android 10 in which writing to an existing file corrupted that file.  If the existing data was longer than the new data, rather than completely overwriting the existing file, the app wrote the new, truncated data while keeping any remaining original data, leading to data corruption.  For example, if the original file contained the string “bootstrapping” and the new data to be written is the string “byte”, the file would be written as “bytestrapping” rather than “byte”.  This behavior was caused by writing data directly to the path without an atomic “safety check.”

No open source file systems libraries available for React Native supported writing to files atomically.  We built `react-native-atomic-file-ops` in order to prevent corruption when writing to files.  By writing atomically to an auxiliary file first and making sure that file has been written successfully, `react-native-atomic-file-ops` protects the file path and its data.

## Table of Contents
* Installation
* How to Use
* API
* Example App
* Tests
* Contributing
* Credits
* License
 
## Installation
While this library was initially built to fix a bug occurring on a specific version of Android, it supports both Android and iOS.

```sh
npm install react-native-atomic-file-ops
```

If using yarn:

```sh
yarn add react-native-atomic-file-ops
```

For iOS:
```sh
cd ios
pod install
```

## How to Use
```javascript
import AtomicFileOps from "react-native-atomic-file-ops";

// ...

// EXAMPLE:  Writes to a JSON file
const fileName = 'CavyImageMetadata.json'

const imageMetadata = [
  {
    title: 'Sasu the Guinea Pig',
    alt: 'Guinea pig in green grass with dandelions',
    creator: 'andymiccone',
    url: 'https://live.staticflickr.com/7377/26722155994_5200abc340_b.jpg',
    license: 'CC0 1.0'
  }
]

const unicode = 'UTF8'

await AtomicFileOps.writeFile(fileName, JSON.stringify(imageMetadata), unicode)
```

## API
### ```writeFile(fileName: String, contents: String, encoding: String)```
Writes the `contents` atomically to the given file, `fileName`. `encoding` allows for the following encoded character sets:  `utf8`, `ascii`, or `base64`.

## Example App
This library includes an example app showing how `react-native-atomic-file-ops` can be used to overwrite files.  See the example app’s [documentation](example/README.md) for information on running the app and its tests.

## Tests
The `writeFile` API has been tested in both [Java](android/src/androidTest/java/com/reactnativeatomicfileops/AtomicFileOpsModuleTests.java) and [Swift](ios/AtomicFileOperations/AtomicFileOperationsTests/AtomicFileOperationsTests.swift).  Scenarios tested include:

* Writing JSON to a file
* Overwriting an existing file with truncated data
* Providing `writeFile` with a corrupted character set
* Providing `writeFile` with a corrupted file path

Additionally, the library has been tested on React Native in an example app using [Cavy](example/specs/atomicFileWritingSpec.js).  See the example app’s [documentation](example/README.md) for information on running Cavy tests.

## Contributing
`react-native-atomic-file-ops` is open-source.  If you find a bug or have an idea for improving this project, please open an issue.

## Credits
Natalia Malesa and Carl Brown

## License
[MIT](LICENSE)
