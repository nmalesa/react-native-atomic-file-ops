import { AppRegistry } from 'react-native';
import App from './src/App';
import { name as appName } from './app.json';

// Used to be index.tsx

AppRegistry.registerComponent(appName, () => App);
