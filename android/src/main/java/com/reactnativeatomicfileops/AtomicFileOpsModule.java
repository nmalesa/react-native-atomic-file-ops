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

    @ReactMethod
    public void multiply(int a, int b, Promise promise) {
        // TODO: Implement some actually useful functionality
        promise.resolve(a * b);
    }

    //JavaScript doesn't have a Charset type, so we have to pass a String in
    @RequiresApi(api = Build.VERSION_CODES.KITKAT)
    @ReactMethod
    public void writeFile(String filePath, String contents, String characterSetName, Promise promise) {
      String caseNeutralCharacterSet = characterSetName.toLowerCase();

      byte[] encoded = null;

      switch (caseNeutralCharacterSet) {
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
          // TODO: Handle error
          System.out.println("Invalid character set");
      }

      try {
        writeFile(filePath, encoded, promise);
      } catch (Exception ex) {
        promise.reject(ex);
      }
    }

    private void writeFile(String filePath, byte[] encoded, Promise promise) {
        try {
          String fullFilePath = filePath;
          System.out.println("FullFilePathOne: " + fullFilePath);
          if (!filePath.contains("/")) {
            System.out.println("I am being called");
//            fullFilePath = reactContext.getApplicationContext().getCacheDir().getCanonicalPath() + filePath;
//            RNFS Document Directory Path:  getReactApplicationContext().getFilesDir().getAbsolutePath());
//            fullFilePath = getReactApplicationContext().getFilesDir().getAbsolutePath() + "/" + filePath;
            fullFilePath = reactContext.getApplicationContext().getFilesDir().getAbsolutePath() + "/" + filePath;
          }

          System.out.println("FullFilePathTwo: " + fullFilePath);
            File file = new File(fullFilePath);
            System.out.println("NewFile: " + file);
            AtomicFile af = new AtomicFile(file);
            System.out.println("NewAtomicFile: " + af);
            FileOutputStream fos = af.startWrite();
            System.out.println("NewOutputStream: " + fos);
            fos.write(encoded);
            af.finishWrite(fos);
            System.out.println("AtomicTwo: " + af);

            promise.resolve(null);
        } catch (Exception ex) {
            ex.printStackTrace();
            promise.reject(filePath, ex);
        }
    }
}
