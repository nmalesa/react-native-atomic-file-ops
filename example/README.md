# AtomicFileOps Example App

This React Native app provides an example of how the `react-native-atomic-file-ops` library can be imported and used.  It also demonstrates how the library is able to successfully overwrite existing content in a file with truncated data.

## Getting Started

### Install Dependencies
```sh
yarn install
```

For iOS:
```sh
cd ios
pod install
```
### Running the App

Start Metro.

```sh
yarn start
```

Start the app.

Android:
```sh
yarn android
```

iOS:
```sh
yarn ios
```

When the app is running successfully and ready to start testing, you should see the following screen:

![AtomicFileOps Landing Screen](./assets/appLandingScreen.png)

**Note:**  The above image is of an iPhone 12 Simulator display.  The appearance of your screen may vary slightly depending on which emulator, simulator, or physical device you are using.

## Running the Tests

The AtomicFileOps example app uses [Cavy](https://cavy.app/) to provide integration testing of the `react-native-atomic-file-ops` library.  Scenarios tested include:
* Overwriting an existing file with truncated JSON data
* Overwriting an existing file with truncated Base64 data

To run the tests:

Android:
```sh
cavy run-android
```

iOS:
```sh
cavy run-ios
```

Test results and output should appear in either the terminal or the console (if you are connected to the React Native debugger).

## Credits

Natalia Malesa