package com.example.ins_images_picker

import android.app.Activity
import android.util.Log
import androidx.annotation.NonNull
import com.luck.picture.lib.PictureSelector
import com.luck.picture.lib.config.PictureConfig
import com.luck.picture.lib.config.PictureMimeType
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.instagram.InsGallery
import com.luck.picture.lib.listener.OnResultCallbackListener
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.PluginRegistry.Registrar

/** InsImagesPickerPlugin */
public class InsImagesPickerPlugin : FlutterPlugin, MethodCallHandler, OnResultCallbackListener<LocalMedia>, ActivityAware {

    private lateinit var channel: MethodChannel
    private var activity: Activity? = null
    private var channelResult: MethodChannel.Result? = null

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "ins_images_picker")
        channel.setMethodCallHandler(this)
    }

    // This static function is optional and equivalent to onAttachedToEngine. It supports the old
    // pre-Flutter-1.12 Android projects. You are encouraged to continue supporting
    // plugin registration via this function while apps migrate to use the new Android APIs
    // post-flutter-1.12 via https://flutter.dev/go/android-project-migration.
    //
    // It is encouraged to share logic between onAttachedToEngine and registerWith to keep
    // them functionally equivalent. Only one of onAttachedToEngine or registerWith will be called
    // depending on the user's project. onAttachedToEngine or registerWith must both be defined
    // in the same class.
    companion object {
        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), "ins_images_picker")
            channel.setMethodCallHandler(InsImagesPickerPlugin())
        }
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: MethodChannel.Result) {
        channelResult = result
        when (call.method) {
            "getPlatformVersion" -> {
                result.success("Android ${android.os.Build.VERSION.RELEASE}")
            }
            "pickerImages" -> {
                InsGallery.applyInstagramOptions(activity!!.applicationContext, PictureSelector.create(activity)
                        .openGallery(getType(call.argument<Int>("type")!!)))
                        .imageEngine(GlideEngine.createGlideEngine()).hideBottomControls(false).rotateEnabled(true).maxVideoSelectNum(0)
                        .isCamera(false).isCameraAroundState(false)
                        .selectionMode(PictureConfig.SINGLE).isEnableCrop(call.argument<Boolean>("showCrop")!!)
                        .forResult(this)
            }
            else -> result.notImplemented()
        }
    }

    private fun getType(type: Int): Int {
        return when (type) {
            0 -> {
                PictureMimeType.ofAll();
            }
            1 -> {
                PictureMimeType.ofImage();
            }
            2 -> {
                PictureMimeType.ofVideo();

            }
            else -> PictureMimeType.ofAll()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
    }

    override fun onResult(result: MutableList<LocalMedia>?) {

        val mutableList = mutableListOf<MutableMap<String, Any>>()

        for (media in result!!) {
            Log.i("InsImagesPickerPlugin", "是否压缩:" + media.isCompressed)
            Log.i("InsImagesPickerPlugin", "压缩:" + media.compressPath)
            Log.i("InsImagesPickerPlugin", "原图:" + media.path)
            Log.i("InsImagesPickerPlugin", "是否裁剪:" + media.isCut)
            Log.i("InsImagesPickerPlugin", "裁剪:" + media.cutPath)
            Log.i("InsImagesPickerPlugin", "是否开启原图:" + media.isOriginal)
            Log.i("InsImagesPickerPlugin", "原图路径:" + media.originalPath)
            Log.i("InsImagesPickerPlugin", "Android Q 特有Path:" + media.androidQToPath)
            Log.i("InsImagesPickerPlugin", "Size: " + media.size)
            Log.i("Media Type", "Size: " + media.mimeType)

            mutableList.add(mutableMapOf(
                    Pair("path", media.path),
                    Pair("cutPath", media.cutPath),
                    Pair("qPath", media.androidQToPath),
                    Pair("mimeType", media.mimeType)
            ))
        }
        channelResult?.success(
                mutableList
        )
    }

    override fun onCancel() {
        TODO("Not yet implemented")
    }

    override fun onAttachedToActivity(binding: ActivityPluginBinding) {
        this.activity = binding.activity;
    }

    override fun onDetachedFromActivityForConfigChanges() {
        TODO("Not yet implemented")
    }

    override fun onReattachedToActivityForConfigChanges(binding: ActivityPluginBinding) {
        TODO("Not yet implemented")
    }

    override fun onDetachedFromActivity() {
        TODO("Not yet implemented")
    }
}
