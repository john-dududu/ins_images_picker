
import Flutter
import AVFoundation
import UIKit
import CTYPImagePicker

public class SwiftInsImagesPickerPlugin: NSObject, FlutterPlugin {

    var picker: YPImagePicker?
    private  var images: [UIImage] = []
    private  var videos: [String] = []
    var imagesResult: FlutterResult?

    public static func register(with registrar: FlutterPluginRegistrar) {
        let channel = FlutterMethodChannel(name: "ins_images_picker", binaryMessenger: registrar.messenger())
        let instance = SwiftInsImagesPickerPlugin()
        registrar.addMethodCallDelegate(instance, channel: channel)
    }

    public func handle(_ call: FlutterMethodCall, result: @escaping FlutterResult) {
        imagesResult = result
        if (call.method == "pickerImages"), let arguments = call.arguments as? Dictionary<String, AnyObject> {
            guard let mediaType = arguments["mediaType"] as? Int, let maxNumberOfItems = arguments["maxImages"] as? Int,
                  let ratioValues = arguments["ratios"] as? [String], let appName = arguments["appName"] as? String,
                  let navigationBarColorHexValue = arguments["navigationBarColor"] as? String,
                  let navigationBarItemColorHexValue = arguments["navigationBarItemColor"] as? String,
                  let statusBarStyleValue = arguments["statusBarStyleValue"] as? Int,
                  let showTrim = arguments["showTrim"] as? Bool,
                  let quality = arguments["quality"] as? Double,
                  let videoMaxDuration = arguments["maxVideoDurationSeconds"] as? Double else { return }
            images = []
            videos = []
            var config = YPImagePickerConfiguration()
            config.library.maxNumberOfItems = maxNumberOfItems
            config.showsPhotoFilters = false
            config.hidesStatusBar = false
            config.colors.barTintColor = UIColor(hexString: navigationBarColorHexValue)
            config.colors.tintColor = UIColor(hexString: navigationBarItemColorHexValue)
            config.preferredStatusBarStyle = UIStatusBarStyle(statusBarStyleValue: statusBarStyleValue)
            if(mediaType == 0) {
                config.screens = [.library]
                config.showsPhotoFilters = true
                config.showsCrop = .rectangle(ratios: ratioValues.compactMap{Ratio(rawValue: $0)})
                config.library.mediaType = .photo
            } else {
                config.screens = [.library]
                config.showsVideoTrimmer = showTrim
                config.library.mediaType = .video
                config.video.libraryTimeLimit = videoMaxDuration
                config.video.compression = AVAssetExportPresetLowQuality
            }
            config.startOnScreen = .library
            config.library.isSquareByDefault = false
            config.albumName = "\(appName) Images"
            picker = YPImagePicker(configuration: config)

            picker!.didFinishPicking { [weak self] items, cancelled in
                guard let self = self else { return }
                var results = [NSDictionary]();

                if !cancelled {
                    for item in items {
                        switch item {
                        case .photo(let photo):
                            if photo.modifiedImage != nil {
                                self.images.append(photo.modifiedImage ?? UIImage())
                            } else {
                                self.images.append(photo.originalImage)
                            }
                        case .video(let video):
                            self.videos.append(video.url.path)

                            results.append([
                                "path": video.url.path,
                            ]);
                            break
                        }
                    }
                }

                for image in self.images {
                    results.append([
                        "path": self.saveToFile(image: image, quality: CGFloat(quality)),
                    ]);
                }
                
                self.imagesResult?(results)
                self.picker?.dismiss(animated: true, completion: nil)
            }
            guard let picker = picker else { return }
            if let tabBarController = UIApplication.shared.keyWindow?.rootViewController as? UITabBarController {
                if let navigation = tabBarController.selectedViewController,
                   let flutterController = navigation.presentedViewController {
                    flutterController.present(picker, animated: true, completion: nil)
                } else if let flutterController = tabBarController.presentedViewController {
                    flutterController.present(picker, animated: true, completion: nil)
                }
            } else {
                UIApplication.shared.keyWindow?.rootViewController?.present(picker, animated: true, completion: nil)
            }
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

extension UIStatusBarStyle {
    
    public init(statusBarStyleValue: Int) {
        switch statusBarStyleValue {
        case 0:
            self = .lightContent
        case 1:
            if #available(iOS 13, *) {
                self = .darkContent
            } else {
                self = .default
            }
        default:
            self = .default
        }
    }
}
