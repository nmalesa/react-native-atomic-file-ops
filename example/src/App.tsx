import React from 'react';
import {
  Image,
  StyleSheet,
  Text,
  View,
} from 'react-native';

const App = () => {
  // "Sasu the Guinea Pig" by andymiccone is marked under CC0 1.0. To view the terms, visit https://creativecommons.org/licenses/cc0/1.0/
  const REMOTE_FILE_PATH =
    'https://live.staticflickr.com/7377/26722155994_5200abc340_b.jpg';

  return (
    <View style={styles.container}>
      <Text style={styles.header}>Automated Testing with Cavy{'\n'}react-native-atomic-file-ops</Text>
      <Image
        style={styles.image}
        source={{uri: REMOTE_FILE_PATH}}
      />
      <Text style={styles.text}>Android:  cavy run-android</Text>
      <Text style={styles.text}>iOS:  cavy run-ios</Text>
    </View>
  );
};

export default App;

const styles = StyleSheet.create({
  container: {
    alignItems: 'center',
    flex: 1,
    justifyContent: 'center',
  },
  header: {
    color: 'green',
    fontSize: 25,
    fontWeight: '700',
    textAlign: 'center',
  },
  image: {
    height: 375,
    resizeMode: 'contain',
    width: 375,
    width: '90%',
  },
  text: {
    color: 'green',
    fontSize: 21,
    fontWeight: '700',
    paddingBottom: 10,
  },
});
