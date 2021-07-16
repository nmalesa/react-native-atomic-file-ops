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

    //JavaScript doesn't have a characterset type, so we have to pass a String in
    @ReactMethod
    public void writeFile(String filePath, String contents, String characterSetName, Promise promise) {
      Charset charset;

      String caseNeutralCharacterSet = characterSetName.toLowerCase();

      System.out.println("LOWERCASE: " + caseNeutralCharacterSet);

      switch (caseNeutralCharacterSet) {
        case "utf8":
          System.out.println("SWITCH STATEMENT IS WORKING FOR UTF8");
          break;
        case "ascii":
          System.out.println("SWITCH STATEMENT IS WORKING FOR ASCII");
          break;
        case "base64":
          System.out.println("SWITCH STATEMENT IS WORKING FOR BASE64");
          break;
        default:
          System.out.println("Invalid character set");
      }

      try {
        charset = Charset.forName(characterSetName);
        writeFile(filePath, contents, charset, promise);
      } catch (Exception ex) {
        promise.reject(ex);
      }
    }

    //Typesafe method that knows what a characterset is
    private void writeFile(String filePath, String contents, Charset characterSet, Promise promise) {
        try {
          byte[] data = contents.getBytes(characterSet);
          String fullFilePath = filePath;
          if (!filePath.contains("/")) {
            fullFilePath = reactContext.getApplicationContext().getCacheDir().getCanonicalPath() + filePath;
          }

            File file = new File(fullFilePath);
            AtomicFile af = new AtomicFile(file);
            FileOutputStream fos = af.startWrite();
            fos.write(data);
            af.finishWrite(fos);

            promise.resolve(null);
        } catch (Exception ex) {
            ex.printStackTrace();
            promise.reject(filePath, ex);
        }
    }
}
