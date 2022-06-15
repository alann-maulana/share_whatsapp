package id.my.alan.share_whatsapp

import android.content.Context
import android.content.Intent
import android.content.pm.PackageManager
import android.util.Log
import androidx.annotation.NonNull
import androidx.core.content.FileProvider
import io.flutter.embedding.engine.plugins.FlutterPlugin
import io.flutter.plugin.common.MethodCall
import io.flutter.plugin.common.MethodChannel
import io.flutter.plugin.common.MethodChannel.MethodCallHandler
import io.flutter.plugin.common.MethodChannel.Result
import java.io.File
import java.io.IOException
import java.lang.ref.WeakReference

/** ShareWhatsappPlugin */
class ShareWhatsappPlugin : FlutterPlugin, MethodCallHandler {
    @Suppress("PrivatePropertyName")
    private val TAG = "SHARE_WHATSAPP"

    /// The MethodChannel that will the communication between Flutter and native Android
    ///
    /// This local reference serves to register the plugin with the Flutter Engine and unregister it
    /// when the Flutter Engine is detached from the Activity
    private lateinit var channel: MethodChannel
    private lateinit var weakReference: WeakReference<Context>

    private val providerAuthority: String by lazy {
        "${getContext().packageName}.provider"
    }

    private val shareCacheFolder: File
        get() = File(getContext().cacheDir, "share_whatsapp")

    private fun getContext(): Context {
        return weakReference.get()!!
    }

    private fun fileIsInShareCache(file: File): Boolean {
        return try {
            val filePath = file.canonicalPath
            filePath.startsWith(shareCacheFolder.canonicalPath)
        } catch (e: IOException) {
            false
        }
    }

    private fun clearShareCacheFolder() {
        val folder = shareCacheFolder
        val files = folder.listFiles()
        if (folder.exists() && !files.isNullOrEmpty()) {
            files.forEach { it.delete() }
            folder.delete()
        }
    }

    @Throws(IOException::class)
    private fun copyToShareCacheFolder(file: File): File {
        val folder = shareCacheFolder
        if (!folder.exists()) {
            folder.mkdirs()
        }
        val newFile = File(folder, file.name)
        file.copyTo(newFile, true)
        return newFile
    }

    override fun onAttachedToEngine(@NonNull flutterPluginBinding: FlutterPlugin.FlutterPluginBinding) {
        channel = MethodChannel(flutterPluginBinding.binaryMessenger, "share_whatsapp")
        channel.setMethodCallHandler(this)

        weakReference = WeakReference(flutterPluginBinding.applicationContext)
    }

    override fun onDetachedFromEngine(@NonNull binding: FlutterPlugin.FlutterPluginBinding) {
        channel.setMethodCallHandler(null)
        weakReference.clear()
    }

    override fun onMethodCall(@NonNull call: MethodCall, @NonNull result: Result) {
        Log.d(TAG, "method=${call.method}, argument=${call.arguments}")

        when (call.method) {
            "installed" -> {
                installed(call, result)
            }
            "share" -> {
                clearShareCacheFolder()
                share(call, result)
            }
            else -> {
                result.notImplemented()
            }
        }
    }

    private fun installed(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            val packageName = call.arguments as String
            val context = weakReference.get()

            if (context != null) {
                val isInstalled: Boolean = isPackageInstalled(packageName, context.packageManager)
                result.success(if (isInstalled) 1 else 0)
                return
            }

            result.error("INVALID_CONTEXT", "No application context found", null)
        } catch (e: Exception) {
            result.error("ERROR_INSTALLED", e.message, e)
        }
    }

    private fun isPackageInstalled(packageName: String, packageManager: PackageManager): Boolean {
        return try {
            packageManager.getPackageInfo(packageName, 0)
            true
        } catch (e: PackageManager.NameNotFoundException) {
            false
        }
    }

    private fun share(@NonNull call: MethodCall, @NonNull result: Result) {
        try {
            val packageName = call.argument<String>("packageName")
            val phone = call.argument<String?>("phone")
            val text = call.argument<String?>("text")
            val contentType = call.argument<String?>("contentType")
            val file = call.argument<String?>("file")
            val context = weakReference.get()

            if (context != null) {
                val intent = Intent().apply {
                    action = Intent.ACTION_SEND

                    setPackage(packageName)
                    if (phone != null) {
                        putExtra("jid", "$phone@s.whatsapp.net")
                    }
                    if (text != null) {
                        putExtra(Intent.EXTRA_TEXT, text)
                    }

                    type = "*/*"
                    if (file != null) {
                        type = contentType ?: "*/*"

                        var uriFile = File(file)
                        if (fileIsInShareCache(uriFile)) {
                            // If file is saved in '.../caches/share_whatsapp' it will be erased by 'clearShareCacheFolder()'
                            throw IOException("Shared file can not be located in '${shareCacheFolder.canonicalPath}'")
                        }
                        uriFile = copyToShareCacheFolder(uriFile)
                        Log.d(TAG, "Cache file path : ${uriFile.canonicalPath}")

                        val fileUri =
                            FileProvider.getUriForFile(context, providerAuthority, uriFile)
                        putExtra(Intent.EXTRA_STREAM, fileUri)
                    } else if (text != null) {
                        type = "text/plain"
                    }
                }

                context.startActivity(Intent.createChooser(intent, null).apply {
                    addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP)
                    addFlags(Intent.FLAG_ACTIVITY_NEW_TASK)
                    if (file != null) addFlags(Intent.FLAG_GRANT_READ_URI_PERMISSION)
                })

                result.success(1)
                return
            }

            result.error("INVALID_CONTEXT", "No application context found", null)
        } catch (e: Exception) {
            result.error("ERROR_SHARE", e.message, e)
        }
    }
}
