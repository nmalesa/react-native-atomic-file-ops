package com.reactnativeatomicfileops;

import android.util.Base64;

import androidx.core.util.AtomicFile;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;
import com.facebook.react.bridge.ReadableMap;

import java.io.File;
import java.io.FileOutputStream;


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

    @ReactMethod
    public void writeFile(String filePath, String base64Data, ReadableMap options, Promise promise) {
        try {
            byte[] data = Base64.decode(base64Data, Base64.DEFAULT);

            File file = new File(filePath);
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
