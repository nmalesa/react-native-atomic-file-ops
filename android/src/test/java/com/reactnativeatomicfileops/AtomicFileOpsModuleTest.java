package com.reactnativeatomicfileops;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;

import org.junit.Assert;
import org.junit.Test;

public class AtomicFileOpsModuleTest {

    @Test
    public void multiply() {
      SimplePromise p = new SimplePromise();
      new AtomicFileOpsModule(null).multiply(5, 11, p);
      Assert.assertTrue(p.wasResolved());
      Assert.assertFalse(p.wasRejected());
      Assert.assertEquals(55, p.getValue());
    }

  static final class SimplePromise implements Promise {
      //Pulled From Promise tesst example at:
      // https://github.com/facebook/react-native/blob/6a78b32878aea1b0dac98ff36378fb9392d4aeb1/ReactAndroid/src/test/java/com/facebook/react/modules/share/ShareModuleTest.java

    private static final String ERROR_DEFAULT_CODE = "EUNSPECIFIED";
    private static final String ERROR_DEFAULT_MESSAGE = "Error not specified.";

    private int mResolved;
    private int mRejected;
    private Object mValue;
    private String mErrorCode;
    private String mErrorMessage;

    public boolean wasRejected() {
      return (mRejected > 0);
    }

    public boolean wasResolved() {
      return (mResolved > 0);
    }

    public int getResolved() {
      return mResolved;
    }

    public int getRejected() {
      return mRejected;
    }

    public Object getValue() {
      return mValue;
    }

    public String getErrorCode() {
      return mErrorCode;
    }

    public String getErrorMessage() {
      return mErrorMessage;
    }

    @Override
    public void resolve(Object value) {
      mResolved++;
      mValue = value;
    }

    @Override
    public void reject(String code, String message) {
      mRejected++;
    }

    @Override
    public void reject(String code, Throwable throwable) {
      mRejected++;
    }

    @Override
    public void reject(String code, String message, Throwable throwable) {
      mRejected++;
    }

    @Override
    public void reject(Throwable throwable) {
      mRejected++;
    }

    @Override
    public void reject(Throwable throwable, WritableMap userInfo) {
      mRejected++;
    }

    @Override
    public void reject(String code, @NonNull WritableMap userInfo) {
      mRejected++;
    }

    @Override
    public void reject(String code, Throwable throwable, WritableMap userInfo) {
      mRejected++;
    }

    @Override
    public void reject(String code, String message, @NonNull WritableMap userInfo) {
      mRejected++;
    }

    @Override
    public void reject(String code, String message, Throwable throwable, WritableMap userInfo) {
      mRejected++;
    }

    @Override
    public void reject(String message) {
      mRejected++;
    }
  }

}
