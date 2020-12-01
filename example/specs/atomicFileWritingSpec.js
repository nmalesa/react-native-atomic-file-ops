import { hasValue } from './fileWritingTestHelper';

export default function (spec) {
  spec.describe('Atomic File Writing', function () {
    spec.it('works', async function () {
      await spec.exists('AtomicFileWriterWrapper');
      await spec.fillIn('AtomicFileWriterWrapper', 'This is a Text String');
      const element = await spec.findComponent('AtomicFileWriterWrapper');

      await hasValue(element,'This is a Text String');
    });
  });

}

