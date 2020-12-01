import React, { useState } from 'react';
import { useCavy, wrap, hook } from 'cavy';
import { Text } from 'react-native';

export default function FileWritingTestHelper(props) {
  const [value, setValue] = useState('');
  const generateTestHook = useCavy();

  const onChangeText = (value) => {
    console.log("FileWritingTestHelper: Changed value to: '" + value + "'");
    setValue(value);
  };

  return (
      <TestableWrapperFuncComponent
        {...props}
        onChangeText={(value) => { onChangeText({value}); }}
        value={value}
        ref={generateTestHook('AtomicFileWriterWrapper')}
      />
  );
}

class WrapperFuncComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = { retVal: props.retVal, value: props.value };
  }

  render() {
    return (
      <Text />
    );
  }
}

const TestableWrapperFuncComponent = hook(WrapperFuncComponent);

export async function hasValue(element, expected) {
  const actual = element.props.value['value'];
  var seen = [];

  console.log("Actual value is: "  + JSON.stringify(actual, function(key, val) {
    if (val != null && typeof val == "object") {
      if (seen.indexOf(val) >= 0) {
        return;
      }
      seen.push(val);
    }
    return val;
  }));

  if (actual != expected) {
    throw new Error(`Element text is ${actual}, not ${expected}`);
  }
}
