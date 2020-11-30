import React, { useState } from 'react';
import { useCavy, wrap, hook } from 'cavy';
import { View, TextInput } from 'react-native';

export default function FileWritingTestHelper(props) {
  const [value, setValue] = useState('');
  const generateTestHook = useCavy();
  const TestableTextInput = wrap(TextInput);

  const onChangeText = (value) => {
    console.log("FileWritingTestHelper: Changed value to: '" + value + "'");
    setValue(value);
  };

  return (
    <View>
      <TestableWrapperFuncComponent
        {...props}
        onChangeText={(value) => {this.setState({value}); }}
        ref={generateTestHook('AtomicFileWriterWrapper')}
      />
    </View>
  );
}

class WrapperFuncComponent extends React.Component {
  constructor(props) {
    super(props);
    this.state = { retVal: props.retVal, value: '' };
    this.onChangeText = this.onChangeText.bind(this);
    this.props.onChangeText = this.onChangeText;
  }

  onChangeText(value) {
    console.log("WrapperFuncComponent: Changed value to: '" + value + "'");
    this.setState({ value: value });
  }

  render() {
    const { generateTestHook } = this.props;
    const TestableTextInput = wrap(TextInput);

    return (
      <TestableTextInput
        ref={generateTestHook('WrapperFuncComponent.TextInput')}
        onChangeText={this.onChangeText}
        value={this.state.value}
      >
        {this.state.retVal}
      </TestableTextInput>
    );
  }
}

const TestableWrapperFuncComponent = hook(WrapperFuncComponent);

export async function hasValue(element, expected) {
  const actual = element.props.value;
  if (actual != expected) {
    throw new Error(`Element text is ${actual}, not ${expected}`);
  }
}
