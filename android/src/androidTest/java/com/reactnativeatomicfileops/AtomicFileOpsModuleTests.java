package com.reactnativeatomicfileops;

import android.util.Base64;

import androidx.annotation.NonNull;
import androidx.core.util.AtomicFile;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.WritableMap;

import org.json.JSONException;
import org.json.JSONObject;
import org.junit.Assert;
import org.junit.Test;
import org.junit.runner.RunWith;

import androidx.test.filters.SmallTest;
import androidx.test.runner.AndroidJUnit4;
import androidx.test.InstrumentationRegistry;


import java.io.File;
import java.io.IOException;
import java.nio.charset.Charset;
import java.nio.charset.StandardCharsets;
import java.util.Calendar;

@RunWith(AndroidJUnit4.class)
@SmallTest
public class AtomicFileOpsModuleTests {

    @Test
    public void multiply() {
      SimplePromise p = new SimplePromise();
      new AtomicFileOpsModule(null).multiply(5, 11, p);
      Assert.assertTrue(p.wasResolved());
      Assert.assertFalse(p.wasRejected());
      Assert.assertEquals(55, p.getValue());
    }

    @Test
    public void writeJSON() throws JSONException, IOException {
      String jsonString = "[{\"key\": \"value\"}]";
      AtomicFileOpsModule fom = new AtomicFileOpsModule(null);
      String timeString = Calendar.getInstance().getTime().toString().replaceAll(" ","").replaceAll(":","");
      File outputDir = InstrumentationRegistry.getContext().getCacheDir();
      String filePath = outputDir + "/AtomicFileOpsModuleTest.test." + timeString + ".json";
      File f = new File(filePath);
      //Make sure file doesn't already exist
      if (f.exists()) {
        boolean deleted = f.delete();
        Assert.assertTrue(deleted);
      }

      SimplePromise p = new SimplePromise();

      fom.writeFile(filePath,jsonString, "UTF-8",p);

      //Read the file back in
      AtomicFile file = new AtomicFile(f);
      byte[] contents = file.readFully();
      Assert.assertTrue(p.wasResolved());
      Assert.assertFalse(p.wasRejected());

      //Clean up
      Assert.assertArrayEquals(contents, jsonString.getBytes());
      if (f.exists()) {
        @SuppressWarnings("unused")
        boolean doNotCare = f.delete();
      }
    }

  @Test
  public void overWriteJSON() throws JSONException, IOException {
    String jsonString = "[{\"key\": \"value\"}]";
    AtomicFileOpsModule fom = new AtomicFileOpsModule(null);
    String timeString = Calendar.getInstance().getTime().toString().replaceAll(" ","").replaceAll(":","");
    File outputDir = InstrumentationRegistry.getContext().getCacheDir();
    String filePath = outputDir + "/AtomicFileOpsModuleTest.test." + timeString + ".json";
    File f = new File(filePath);
    //Make sure file doesn't already exist
    if (f.exists()) {
      boolean deleted = f.delete();
      Assert.assertTrue(deleted);
    }

    SimplePromise p = new SimplePromise();

    //First write out the full file
    fom.writeFile(filePath,jsonString, "UTF-8",p);
    //Read the file back in
    AtomicFile file = new AtomicFile(f);
    byte[] contents = file.readFully();
    Assert.assertTrue(p.wasResolved());
    Assert.assertFalse(p.wasRejected());
    Assert.assertArrayEquals(contents, jsonString.getBytes());

    //Now, overwrite it with a shorter string
    SimplePromise p2 = new SimplePromise();
    fom.writeFile(filePath,"[]", "UTF-8",p2);

    //Read the file back in
    byte[] newContents = file.readFully();
    Assert.assertTrue(p2.wasResolved());
    Assert.assertFalse(p2.wasRejected());
    Assert.assertArrayEquals(newContents, "[]".getBytes());

    //Clean up
    if (f.exists()) {
      @SuppressWarnings("unused")
      boolean doNotCare = f.delete();
    }
  }

  @Test
  public void badCharacterSet() throws JSONException, IOException {
    String jsonString = "[{\"key\": \"value\"}]";
    AtomicFileOpsModule fom = new AtomicFileOpsModule(null);
    String timeString = Calendar.getInstance().getTime().toString().replaceAll(" ","").replaceAll(":","");
    File outputDir = InstrumentationRegistry.getContext().getCacheDir();
    String filePath = outputDir + "/AtomicFileOpsModuleTest.test." + timeString + ".json";
    File f = new File(filePath);
    //Make sure file doesn't already exist
    if (f.exists()) {
      boolean deleted = f.delete();
      Assert.assertTrue(deleted);
    }

    SimplePromise p = new SimplePromise();

    fom.writeFile(filePath,jsonString, "No Such Character Set",p);

    Assert.assertFalse(f.exists());
    Assert.assertFalse(p.wasResolved());
    Assert.assertTrue(p.wasRejected());
  }

  @Test
  public void badFilePath() throws JSONException, IOException {
    String jsonString = "[{\"key\": \"value\"}]";
    AtomicFileOpsModule fom = new AtomicFileOpsModule(null);
    String timeString = Calendar.getInstance().getTime().toString().replaceAll(" ","").replaceAll(":","");
    String filePath = "/No Such File /AtomicFileOpsModuleTest.test.json";
    File f = new File(filePath);

    SimplePromise p = new SimplePromise();

    fom.writeFile(filePath,jsonString, "UTF-8",p);

    Assert.assertFalse(f.exists());
    Assert.assertFalse(p.wasResolved());
    Assert.assertTrue(p.wasRejected());
  }

  @Test
  public void getNameForCodeCoverage() {
    AtomicFileOpsModule fom = new AtomicFileOpsModule(null);
    Assert.assertEquals("AtomicFileOps", fom.getName());
  }

  static final class SimplePromise implements Promise {
      //Pulled From Promise test example at:
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
