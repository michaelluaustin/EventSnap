import UIKit
import Vision
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
    
    // MARK: - Hybrid AI Text Recognition
    func extractTextFromImage(_ image: UIImage, completion: @escaping (String?) -> Void) {
        guard let cgImage = image.cgImage else {
            completion(nil)
            return
        }
        
        let requestHandler = VNImageRequestHandler(cgImage: cgImage, options: [:])
        let request = VNRecognizeTextRequest { request, error in
            if let error = error {
                print("Text recognition error: \(error)")
                completion(nil)
                return
            }
            
            guard let observations = request.results as? [VNRecognizedTextObservation] else {
                completion(nil)
                return
            }
            
            // Sort observations by vertical position (top to bottom)
            let sortedObservations = observations.sorted { obs1, obs2 in
                obs1.boundingBox.minY > obs2.boundingBox.minY
            }
            
            let recognizedText = sortedObservations.compactMap { observation in
                observation.topCandidates(1).first?.string
            }.joined(separator: "\n")
            
            print("Vision extracted text: \(recognizedText)")
            completion(recognizedText)
        }
        
        request.recognitionLevel = .accurate
        request.usesLanguageCorrection = true
        
        do {
            try requestHandler.perform([request])
        } catch {
            print("Failed to perform text recognition: \(error)")
            completion(nil)
        }
    }
    
    // MARK: - OpenAI Event Details Extraction
    func extractEventDetailsWithAI(from text: String, completion: @escaping (EventDetails?) -> Void) {
        OpenAIService.shared.extractEventDetails(from: text) { eventDetails in
            completion(eventDetails)
        }
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
