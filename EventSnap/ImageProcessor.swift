import UIKit
import VisionKit

class ImageProcessor: NSObject {
    
    static let shared = ImageProcessor()
    
    private override init() {
        super.init()
    }
    
    // MARK: - Image Capture
    func presentImagePicker(from viewController: UIViewController, completion: @escaping (UIImage?) -> Void) {
        let alertController = UIAlertController(title: "Select Image", message: nil, preferredStyle: .actionSheet)
        
        // Camera option
        if UIImagePickerController.isSourceTypeAvailable(.camera) {
            let cameraAction = UIAlertAction(title: "Take Photo", style: .default) { _ in
                self.presentImagePickerController(from: viewController, sourceType: .camera, completion: completion)
            }
            alertController.addAction(cameraAction)
        }
        
        // Photo library option
        let libraryAction = UIAlertAction(title: "Choose from Library", style: .default) { _ in
            self.presentImagePickerController(from: viewController, sourceType: .photoLibrary, completion: completion)
        }
        alertController.addAction(libraryAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alertController.addAction(cancelAction)
        
        viewController.present(alertController, animated: true)
    }
    
    private func presentImagePickerController(from viewController: UIViewController, sourceType: UIImagePickerController.SourceType, completion: @escaping (UIImage?) -> Void) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = ImagePickerDelegate(completion: completion)
        viewController.present(imagePicker, animated: true)
    }
    
    // MARK: - Image to Data URI Conversion
    func convertImageToDataURI(_ image: UIImage) -> String? {
        guard let imageData = image.jpegData(compressionQuality: 0.8) else {
            print("Failed to convert image to JPEG data")
            return nil
        }
        
        let base64String = imageData.base64EncodedString()
        return "data:image/jpeg;base64,\(base64String)"
    }
    
    // MARK: - OpenAI Event Details Extraction with Vision API
    func extractEventDetailsFromImage(_ image: UIImage, completion: @escaping (EventDetails?) -> Void) {
        guard let dataUri = convertImageToDataURI(image) else {
            print("Failed to convert image to data URI")
            completion(nil)
            return
        }
        
        OpenAIService.shared.extractEventDetailsFromImage(dataUri) { eventDetails in
            completion(eventDetails)
        }
    }
    
    // Legacy method for backward compatibility (can be removed later)
    func extractTextFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        // This method is now deprecated - use extractEventDetailsFromImage instead
        print("Warning: extractTextFromImage is deprecated. Use extractEventDetailsFromImage instead.")
        completion(nil)
    }
    
    func extractEventDetailsWithAI(from text: String, completion: @escaping (EventDetails?) -> Void) {
        // This method is now deprecated - use extractEventDetailsFromImage instead
        print("Warning: extractEventDetailsWithAI is deprecated. Use extractEventDetailsFromImage instead.")
        completion(nil)
    }
}

// MARK: - Image Picker Delegate
class ImagePickerDelegate: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    private let completion: (UIImage?) -> Void
    
    init(completion: @escaping (UIImage?) -> Void) {
        self.completion = completion
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            completion(image)
        } else {
            completion(nil)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
        completion(nil)
    }
}
