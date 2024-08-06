package com.cropshot

import android.app.Activity
import android.graphics.Bitmap
import android.graphics.Canvas
import android.util.Base64
import android.util.TypedValue
import android.view.View

import com.facebook.react.bridge.Promise
import com.facebook.react.bridge.ReactApplicationContext
import com.facebook.react.bridge.ReactContextBaseJavaModule
import com.facebook.react.bridge.ReactMethod
import com.facebook.react.uimanager.UIManagerModule

import java.io.ByteArrayOutputStream
class CropShotModule(reactContext: ReactApplicationContext) :
    ReactContextBaseJavaModule(reactContext) {

  override fun getName(): String {
    return NAME
  }

  @ReactMethod
  fun captureScreenshot(x: Float, y: Float, width: Float, height: Float, promise: Promise) {
    val currentActivity: Activity? = currentActivity
    if (currentActivity == null) {
      promise.reject("capture_error", "Could not get current activity")
      return
    }
    currentActivity.runOnUiThread {
      try {
        val rootView: View = currentActivity.window.decorView.findViewById(android.R.id.content)
        val displayMetrics = currentActivity.resources.displayMetrics

        val xPx = TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, x, displayMetrics).toInt()
        val yPx =
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, y, displayMetrics).toInt()
        val widthPx =
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, width, displayMetrics).toInt()
        val heightPx =
            TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, height, displayMetrics).toInt()
        val screenshot =
            Bitmap.createBitmap(rootView.width, rootView.height, Bitmap.Config.ARGB_8888)
        val canvas = Canvas(screenshot)
        rootView.draw(canvas)
        // println("Root View::: Width: ${rootView.width}, Height: ${rootView.height}")
        // println("View::: Width: $widthPx, Height: $heightPx")
        val croppedScreenshot = Bitmap.createBitmap(screenshot, xPx, yPx, widthPx, heightPx)

        val byteArrayOutputStream = ByteArrayOutputStream()
        croppedScreenshot.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
        val byteArray = byteArrayOutputStream.toByteArray()

        val base64String = Base64.encodeToString(byteArray, Base64.DEFAULT)
        promise.resolve(base64String)
      } catch (e: Exception) {
        promise.reject("capture_error", "Could not capture screenshot", e)
      }
    }
  }

  @ReactMethod
  fun captureScreenshotWithRef(viewId: Int, promise: Promise) {
    val currentActivity: Activity? = currentActivity
    if (currentActivity == null) {
      promise.reject("capture_error", "Could not get current activity")
      return
    }
    currentActivity.runOnUiThread {
      try {
        val rootView: View = currentActivity.window.decorView.findViewById(android.R.id.content)
        val uiManager = reactApplicationContext.getNativeModule(UIManagerModule::class.java)
        val view = uiManager?.resolveView(viewId)
        if (view != null) {
          val screenshot =
              Bitmap.createBitmap(rootView.width, rootView.height, Bitmap.Config.ARGB_8888)
          val canvas = Canvas(screenshot)
          rootView.draw(canvas)

          val croppedScreenshot =
              Bitmap.createBitmap(
                  screenshot,
                  view.x.toInt(),
                  view.y.toInt(),
                  view.width,
                  view.height
              )

          val byteArrayOutputStream = ByteArrayOutputStream()
          croppedScreenshot.compress(Bitmap.CompressFormat.PNG, 100, byteArrayOutputStream)
          val byteArray = byteArrayOutputStream.toByteArray()

          val base64String = Base64.encodeToString(byteArray, Base64.DEFAULT)
          promise.resolve(base64String)
        } else {
          promise.reject("E_VIEW_NOT_FOUND", "View not found")
        }
      } catch (e: Exception) {
        promise.reject("capture_error", "Could not capture screenshot", e)
      }
    }
  }

  companion object {
    const val NAME = "CropShot"
  }
}
