import React from 'react';
import { View } from 'react-native';
import { useCavy } from 'cavy';

export default () => {
  const generateTestHook = useCavy();

  return <View ref={generateTestHook('AtomicFileWriterWrapper')} />;
};
