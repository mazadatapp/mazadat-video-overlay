package com.mazadatvideooverlay;

import android.content.BroadcastReceiver;
import android.content.Context;
import android.content.Intent;
import android.content.IntentFilter;
import android.util.Log;

import androidx.annotation.NonNull;

import com.facebook.react.bridge.Promise;
import com.facebook.react.bridge.ReactApplicationContext;
import com.facebook.react.bridge.ReactContextBaseJavaModule;
import com.facebook.react.bridge.ReactMethod;
import com.facebook.react.module.annotations.ReactModule;

@ReactModule(name = MazadatVideoOverlayModule.NAME)
public class MazadatVideoOverlayModule extends ReactContextBaseJavaModule {
  public static final String NAME = "MazadatVideoOverlay";
  Promise promise;
  BroadcastReceiver receiver=new BroadcastReceiver() {
    @Override
    public void onReceive(Context context, Intent intent) {
      Log.i("datadata_path2",intent.getExtras().getString("path"));
      promise.resolve(intent.getExtras().getString("path"));
    }
  };
  public MazadatVideoOverlayModule(ReactApplicationContext reactContext) {
    super(reactContext);
  }

  @Override
  @NonNull
  public String getName() {
    return NAME;
  }


  // Example method
  // See https://reactnative.dev/docs/native-modules-android
  @ReactMethod
  public void multiply(double a, double b, Promise promise) {
    promise.resolve(a * b);
  }

  @ReactMethod
  public void playVideo(String link, Promise promise) {
    Intent intent=new Intent(getCurrentActivity(),VideoActivity.class);
    intent.putExtra("link",link);
    //intent.putExtra("module",OpenCameraActivity.this);
    getCurrentActivity().startActivity(intent);
    this.promise=promise;
    IntentFilter filter=new IntentFilter();
    filter.addAction("data");
    getCurrentActivity().registerReceiver(receiver,filter);
  }
}
