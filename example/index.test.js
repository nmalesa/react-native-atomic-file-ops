import React, { Component } from 'react';
import { AppRegistry } from 'react-native';
import { Tester, TestHookStore } from 'cavy';
import AtomicFileWritingSpec from './specs/atomicFileWritingSpec';
import FileWritingTestHelper from './specs/fileWritingTestHelper';
import { name as appName } from './app.json';

const testHookStore = new TestHookStore();

class AppWrapper extends Component {
  render() {
    return (
      <Tester specs={[AtomicFileWritingSpec]} store={testHookStore}>
        <FileWritingTestHelper />
      </Tester>
    );
  }
}

AppRegistry.registerComponent(appName, () => AppWrapper);
