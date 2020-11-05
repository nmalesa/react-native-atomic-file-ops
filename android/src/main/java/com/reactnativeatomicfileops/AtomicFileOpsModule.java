package com.reactnativeatomicfileops;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.bridge.Callback;

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
}
