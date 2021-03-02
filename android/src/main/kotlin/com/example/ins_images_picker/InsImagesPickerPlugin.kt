import android.app.Activity
import android.content.Context
import android.widget.ImageView
import androidx.annotation.NonNull
import com.luck.picture.lib.engine.ImageEngine
import com.luck.picture.lib.entity.LocalMedia
import com.luck.picture.lib.instagram.InsGallery
import com.luck.picture.lib.listener.OnImageCompleteCallback
import com.luck.picture.lib.listener.OnResultCallbackListener
import com.luck.picture.lib.widget.longimage.SubsamplingScaleImageView
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.embedding.engine.plugins.activity.ActivityAware
import io.flutter.embedding.engine.plugins.activity.ActivityPluginBinding
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import io.flutter.plugin.common.PluginRegistry.Registrar


/** FlutterExtPlugin */
class FlutterExtPlugin() : FlutterPlugin, MethodCallHandler, ActivityAware, ImageEngine, OnResultCallbackListener<LocalMedia> {

    private var activity: Activity? = null

    companion object {
        const val CHANNEL_NAME = "ins_images_picker"

        @JvmStatic
        fun registerWith(registrar: Registrar) {
            val channel = MethodChannel(registrar.messenger(), CHANNEL_NAME)
            channel.setMethodCallHandler(FlutterExtPlugin())
        }
    }

    private lateinit var channel: MethodChannel

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, CHANNEL_NAME)
        channel.setMethodCallHandler(this)
    }


    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        when (call.method) {
          "getPlatformVersion" -> {
            result.success("Android ${android.os.Build.VERSION.RELEASE}")
          }
          "pickerImages" -> {
            InsGallery.openGallery(activity,
                    this, this)
          }
            else -> result.notImplemented()
        }
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
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

    override fun loadImage(context: Context, url: String, imageView: ImageView) {
        TODO("Not yet implemented")
    }

    override fun loadImage(context: Context, url: String, imageView: ImageView, longImageView: SubsamplingScaleImageView?, callback: OnImageCompleteCallback?) {
        TODO("Not yet implemented")
    }

    override fun loadImage(context: Context, url: String, imageView: ImageView, longImageView: SubsamplingScaleImageView?) {
        TODO("Not yet implemented")
    }

    override fun loadFolderImage(context: Context, url: String, imageView: ImageView) {
        TODO("Not yet implemented")
    }

    override fun loadAsGifImage(context: Context, url: String, imageView: ImageView) {
        TODO("Not yet implemented")
    }

    override fun loadGridImage(context: Context, url: String, imageView: ImageView) {
        TODO("Not yet implemented")
    }

    override fun onResult(result: MutableList<LocalMedia>?) {
        TODO("Not yet implemented")
    }

    override fun onCancel() {
        TODO("Not yet implemented")
    }

}
