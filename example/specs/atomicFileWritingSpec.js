import { hasValue } from './fileWritingTestHelper';

export default function (spec) {
  spec.describe('Atomic File Writing', function () {
    spec.it('works', async function () {
      await spec.exists('AtomicFileWriterWrapper');
      await spec.fillIn('WrapperFuncComponent.TextInput', '[{"key": "value"}]');
      const element = await spec.findComponent('WrapperFuncComponent.TextInput');

      var seen = [];

      console.log("Element retVal is: "  + JSON.stringify(element.props, function(key, val) {
        if (val != null && typeof val == "object") {
          if (seen.indexOf(val) >= 0) {
            return;
          }
          seen.push(val);
        }
        return val;
      }));
      await hasValue(element,'[{"key": "value"}]');
    });
  });

}

