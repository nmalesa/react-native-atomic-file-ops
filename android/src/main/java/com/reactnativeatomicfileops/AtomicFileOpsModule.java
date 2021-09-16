package com.reactnativeatomicfileops;

import android.os.Build;
import android.util.Base64;

import androidx.annotation.RequiresApi;
import androidx.core.util.AtomicFile;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;

import java.io.File;
import java.io.FileOutputStream;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.nio.charset.UnsupportedCharsetException;


public class AtomicFileOpsModule extends ReactContextBaseJavaModule {

    private final ReactApplicationContext reactContext;

    public AtomicFileOpsModule(ReactApplicationContext reactContext) {
        super(reactContext);
        this.reactContext = reactContext;
    }

    @Override
    public String getName() {
        return "AtomicFileOps";
    }

    //JavaScript doesn't have a Charset type, so we have to pass a String in
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @ReactMethod
    public void writeFile(String fileName, String contents, String encoding, Promise promise) {
      byte[] encoded = null;

      switch (encoding.toLowerCase()) {
        case "utf8":
          encoded = contents.getBytes(StandardCharsets.UTF_8);
          break;
        case "ascii":
          encoded = contents.getBytes(StandardCharsets.US_ASCII);
          break;
        case "base64":
          String base64 = Base64.encodeToString(contents.getBytes(), Base64.DEFAULT);
          encoded = Base64.decode(base64, Base64.DEFAULT);
          break;
        default:
          System.out.println("Bad Encoding:  Please enter Unicode (.utf8), ASCII (.ascii), or Base64 (.base64).");
      }

      try {
        writeFile(fileName, encoded, promise);
      } catch (Exception ex) {
        promise.reject(ex);
      }
    }

    private void writeFile(String filePath, byte[] encoded, Promise promise) {
      try {
        String fullFilePath = filePath;
        if (!filePath.contains("/")) {
          fullFilePath = reactContext.getApplicationContext().getFilesDir().getAbsolutePath() + "/" + filePath;
        }

        File file = new File(fullFilePath);
        AtomicFile af = new AtomicFile(file);
        FileOutputStream fos = af.startWrite();
        fos.write(encoded);
        af.finishWrite(fos);

        promise.resolve(null);
      } catch (Exception ex) {
        ex.printStackTrace();
        promise.reject(filePath, ex);
      }
    }
}
