import { NativeModules } from 'react-native';

type AtomicFileOpsType = {
  writeFile(filePath: string, data: string, options?: any): Promise<void>;
};

const { AtomicFileOps } = NativeModules;

export default AtomicFileOps as AtomicFileOpsType;
