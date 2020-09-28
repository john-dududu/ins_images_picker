
import Flutter
import UIKit
import YPImagePicker

public class SwiftInsImagesPickerPlugin: NSObject, FlutterPlugin {

    var picker: YPImagePicker?
    private  var images: [UIImage] = []
    var imagesResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ins_images_picker", binaryMessenger: registrar.messenger())
        let instance = SwiftInsImagesPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        self.imagesResult = result
        if (call.method == "pickerImages") {
            let arguments = call.arguments as! Dictionary<String, AnyObject>
            let maxImages = arguments["maxImages"] as! Int
            let mediaType = arguments["mediaType"] as! Int
            let quality = arguments["quality"] as! Double

            self.images = []
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = maxImages
            config.showsPhotoFilters = false
            if(mediaType == 0){
                config.screens = [.library, .photo]
                config.showsPhotoFilters = true

            } else{
                config.screens = [.library, .video]
                config.showsVideoTrimmer = true
                config.library.mediaType = .video
            }
            config.startOnScreen = .library
            config.library.isSquareByDefault = false
            config.albumName = "buyer"
            picker = YPImagePicker(configuration: config)
            
            picker!.didFinishPicking { [weak self] items, cancelled in
                
                if !cancelled {
                    for item in items {
                        switch item {
                        case .photo(let photo):
                            if photo.modifiedImage != nil {
                                self?.images.append(photo.modifiedImage ?? UIImage())
                            } else {
                                self?.images.append(photo.originalImage)
                            }
                        case .video(let _):
                            break
                        }
                    }
                } else { }
                
                var results = [NSDictionary]();
                for image in self!.images {
                    results.append([
                        "path": self!.saveToFile(image: image, quality: CGFloat(quality)),
                    ]);
                }
                
                self!.imagesResult!(results)
                self?.picker?.dismiss(animated: true, completion: nil)
            }
            UIApplication.shared.keyWindow?.rootViewController?.present(picker!, animated: true, completion: nil)
        }
        
    }
    
    private func saveToFile(image: UIImage, quality: CGFloat) -> Any {
        
        
        
        guard let data = image.jpegData(compressionQuality: quality) else {
            return FlutterError(code: "image_encoding_error", message: "Could not read image", details: nil)
        }
        let tempDir = NSTemporaryDirectory()
        let imageName = "image_picker_\(ProcessInfo().globallyUniqueString).jpg"
        let filePath = tempDir.appending(imageName)
        if FileManager.default.createFile(atPath: filePath, contents: data, attributes: nil) {
            return filePath
        } else {
            return FlutterError(code: "image_save_failed", message: "Could not save image to disk", details: nil)
        }
    }
}
