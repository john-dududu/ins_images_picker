
import Flutter
import AVFoundation
import UIKit
import CTYPImagePicker

public class SwiftInsImagesPickerPlugin: NSObject, FlutterPlugin {
    
    private enum ScreenType: Int {
        case takePhoto = 0
        case takeVideo
        case photoLibrary
        case videoLibrary
    }

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
            guard let screenTypeRawValue = arguments["screenType"] as? Int,
                  let screenType = ScreenType(rawValue: screenTypeRawValue),
                  let maxNumberOfItems = arguments["maxImages"] as? Int,
                  let appName = arguments["appName"] as? String,
                  let navigationBarColorHexValue = arguments["navigationBarColor"] as? String,
                  let navigationBarItemColorHexValue = arguments["navigationBarItemColor"] as? String,
                  let backgroundColorHexValue = arguments["backgroundColor"] as? String,
                  let statusBarStyleValue = arguments["statusBarStyleValue"] as? Int,
                  let compressionQuality = arguments["compressionQuality"] as? Double else { return }
            
            images = []
            videos = []
            var config = YPImagePickerConfiguration()
            // Status bar config
            config.hidesStatusBar = false
            config.preferredStatusBarStyle = UIStatusBarStyle(statusBarStyleValue: statusBarStyleValue)
            // Colors config
            config.colors.barTintColor = UIColor(hexString: navigationBarColorHexValue)
            config.colors.tintColor = UIColor(hexString: navigationBarItemColorHexValue)
            config.colors.photoVideoScreenBackgroundColor = UIColor(hexString: backgroundColorHexValue)
            config.colors.libraryScreenBackgroundColor = UIColor(hexString: backgroundColorHexValue)
            config.colors.safeAreaBackgroundColor = UIColor(hexString: backgroundColorHexValue)
            config.colors.assetViewBackgroundColor = UIColor(hexString: backgroundColorHexValue)
            config.colors.filterBackgroundColor = UIColor(hexString: backgroundColorHexValue)
            config.colors.selectionsBackgroundColor = UIColor(hexString: backgroundColorHexValue)
            
            switch screenType {
            case .takePhoto, .photoLibrary:
                config.albumName = "\(appName) Images"
                if screenType == .photoLibrary {
                    config.screens = [.library]
                    config.library.mediaType = .photo
                    config.library.maxNumberOfItems = maxNumberOfItems
                    config.library.isSquareByDefault = false
                } else {
                    config.screens = [.photo]
                    config.onlySquareImagesFromCamera = false
                    config.maxCameraZoomFactor = 3.0
                }
                if let showCrop = arguments["showCrop"] as? Bool, showCrop,
                   let ratioValues = arguments["ratios"] as? [String],
                   let enableCropRotation = arguments["enableCropRotation"] as? Bool {
                    config.showsCrop = .rectangle(ratios: ratioValues.compactMap{MantisRatio(ratioStringValue: $0)})
                    config.enableCropRotation = enableCropRotation
                } else {
                    config.showsCrop = .none
                }
            case .takeVideo, .videoLibrary:
                guard let showTrim = arguments["showTrim"] as? Bool,
                      let videoQuality = arguments["videoQuality"] as? String,
                      let videoMaxDuration = arguments["maxVideoDurationSeconds"] as? Double else { return }
                if screenType == .videoLibrary {
                    config.screens = [.library]
                    config.library.mediaType = .video
                    config.library.maxNumberOfItems = maxNumberOfItems
                    config.video.libraryTimeLimit = videoMaxDuration
                    config.library.isSquareByDefault = false
                } else {
                    config.screens = [.video]
                    config.onlySquareImagesFromCamera = false
                    config.maxCameraZoomFactor = 3.0
                    config.video.recordingTimeLimit = videoMaxDuration
                }
                config.showsVideoTrimmer = showTrim
                config.video.compression = videoQuality
            }
            
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
                                "thumbnailPath": self.saveToFile(image: video.thumbnail, quality: CGFloat(compressionQuality))
                            ]);
                            break
                        }
                    }
                }

                for image in self.images {
                    results.append([
                        "path": self.saveToFile(image: image, quality: CGFloat(compressionQuality)),
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
