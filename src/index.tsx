import { NativeModules } from 'react-native';

type AtomicFileOpsType = {
  multiply(a: number, b: number): Promise<number>;
};

const { AtomicFileOps } = NativeModules;

export default AtomicFileOps as AtomicFileOpsType;
