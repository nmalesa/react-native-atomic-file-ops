import { NativeModules } from 'react-native';

type AtomicFileOpsType = {
  multiply(a: number, b: number): Promise<number>;
  writeFile(filePath: string, data: string, options?: any): Promise<void>;
};

const { AtomicFileOps } = NativeModules;

export default AtomicFileOps as AtomicFileOpsType;
