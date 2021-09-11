import React from 'react';
import { Image, StyleSheet, Text, View } from 'react-native';

const App = () => {
  return (
    <View style={styles.container}>
      <Text style={styles.header}>
        Automated Testing with Cavy{'\n'}react-native-atomic-file-ops
      </Text>
      {/* "Sasu the Guinea Pig" (https://live.staticflickr.com/7377/26722155994_5200abc340_b.jpg) by andymiccone is marked under CC0 1.0.
      To view the terms, visit https://creativecommons.org/licenses/cc0/1.0/ */}
      <Image style={styles.image} source={require('../assets/guineaPig.jpg')} />
      <Text style={styles.text}>Android: cavy run-android</Text>
      <Text style={styles.text}>iOS: cavy run-ios</Text>
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
    lineHeight: 40,
    textAlign: 'center',
  },
  image: {
    height: 300,
    resizeMode: 'contain',
    width: '90%',
  },
  text: {
    color: 'green',
    fontSize: 21,
    fontWeight: '700',
    paddingBottom: 10,
  },
});
