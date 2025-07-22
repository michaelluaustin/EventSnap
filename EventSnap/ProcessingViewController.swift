import UIKit

class ProcessingViewController: UIViewController {
    
    private var selectedImage: UIImage?
    private var extractedData: [String: Any] = [:]
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        return scrollView
    }()
    
    private let contentView: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let titleLabel: UILabel = {
        let label = UILabel()
        label.text = "Processing Your Event"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor(red: 0.8, green: 0.4, blue: 1.0, alpha: 1.0) // Bright purple
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Extracting event details from your image..."
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let progressView: UIProgressView = {
        let progressView = UIProgressView(progressViewStyle: .default)
        progressView.progressTintColor = UIColor(red: 0.8, green: 0.4, blue: 1.0, alpha: 1.0) // Bright purple
        progressView.trackTintColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Dark gray
        progressView.translatesAutoresizingMaskIntoConstraints = false
        return progressView
    }()
    
    private let progressLabel: UILabel = {
        let label = UILabel()
        label.text = "0% Complete"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.lightGray
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imagePreviewView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor(red: 0.2, green: 0.2, blue: 0.2, alpha: 1.0) // Dark gray
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isUserInteractionEnabled = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let checklistStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 12
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let steps = [
        "Extracting title",
        "Extracting start time/date",
        "Extracting end time/date", 
        "Extracting event location"
    ]
    
    private var stepLabels: [UILabel] = []
    private var stepCheckmarks: [UIImageView] = []
    
    init(image: UIImage) {
        self.selectedImage = image
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        startProcessing()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor(red: 0.1, green: 0.1, blue: 0.1, alpha: 1.0) // Dark background
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imagePreviewView)
        contentView.addSubview(progressView)
        contentView.addSubview(progressLabel)
        contentView.addSubview(checklistStackView)
        
        setupChecklist()
        
        // Setup image preview tap gesture
        let imageTapGesture = UITapGestureRecognizer(target: self, action: #selector(imagePreviewTapped))
        imagePreviewView.addGestureRecognizer(imageTapGesture)
        
        // Set the image
        if let image = selectedImage {
            imagePreviewView.image = image
        }
    }
    
    private func setupChecklist() {
        for (index, step) in steps.enumerated() {
            let stepView = UIView()
            stepView.translatesAutoresizingMaskIntoConstraints = false
            
            let checkmarkImageView = UIImageView()
            checkmarkImageView.image = UIImage(systemName: "circle")
            checkmarkImageView.tintColor = UIColor.systemGray4
            checkmarkImageView.contentMode = .scaleAspectFit
            checkmarkImageView.translatesAutoresizingMaskIntoConstraints = false
            
            let stepLabel = UILabel()
            stepLabel.text = step
            stepLabel.font = UIFont.systemFont(ofSize: 16)
            stepLabel.textColor = UIColor.lightGray
            stepLabel.translatesAutoresizingMaskIntoConstraints = false
            
            stepView.addSubview(checkmarkImageView)
            stepView.addSubview(stepLabel)
            
            NSLayoutConstraint.activate([
                checkmarkImageView.leadingAnchor.constraint(equalTo: stepView.leadingAnchor),
                checkmarkImageView.centerYAnchor.constraint(equalTo: stepView.centerYAnchor),
                checkmarkImageView.widthAnchor.constraint(equalToConstant: 20),
                checkmarkImageView.heightAnchor.constraint(equalToConstant: 20),
                
                stepLabel.leadingAnchor.constraint(equalTo: checkmarkImageView.trailingAnchor, constant: 12),
                stepLabel.trailingAnchor.constraint(equalTo: stepView.trailingAnchor),
                stepLabel.centerYAnchor.constraint(equalTo: stepView.centerYAnchor),
                
                stepView.heightAnchor.constraint(equalToConstant: 30)
            ])
            
            checklistStackView.addArrangedSubview(stepView)
            stepCheckmarks.append(checkmarkImageView)
            stepLabels.append(stepLabel)
        }
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor),
            contentView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 40),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            imagePreviewView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            imagePreviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imagePreviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imagePreviewView.heightAnchor.constraint(equalToConstant: 200),
            
            progressView.topAnchor.constraint(equalTo: imagePreviewView.bottomAnchor, constant: 24),
            progressView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            progressView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            progressView.heightAnchor.constraint(equalToConstant: 8),
            
            progressLabel.topAnchor.constraint(equalTo: progressView.bottomAnchor, constant: 8),
            progressLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            
            checklistStackView.topAnchor.constraint(equalTo: progressLabel.bottomAnchor, constant: 40),
            checklistStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            checklistStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            checklistStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func startProcessing() {
        progressView.progress = 0.0
        progressLabel.text = "0% Complete"
        
        guard let image = selectedImage else {
            processingComplete()
            return
        }
        
        // Start actual image processing
        ImageProcessor.shared.extractEventDetailsFromImage(image) { [weak self] eventDetails in
            DispatchQueue.main.async {
                if let details = eventDetails {
                    // Store extracted data
                    self?.extractedData = [
                        "title": details.eventTitle,
                        "location": details.location,
                        "startTime": details.startTime,
                        "endTime": details.endTime,
                        "description": details.description ?? "",
                        "rsvpLink": details.rsvpLink ?? ""
                    ]
                    
                    // Check what was successfully extracted
                    let hasTitle = !details.eventTitle.isEmpty && details.eventTitle != "Not found"
                    let hasStartTime = !details.startTime.isEmpty && details.startTime != "Not found"
                    let hasEndTime = !details.endTime.isEmpty && details.endTime != "Not found"
                    let hasLocation = !details.location.isEmpty && details.location != "Not found"
                    
                    // Start smooth progress animation
                    self?.startSmoothProgressAnimation(successSteps: [hasTitle, hasStartTime, hasEndTime, hasLocation])
                } else {
                    // If extraction failed completely, show all steps as failed
                    self?.startSmoothProgressAnimation(successSteps: [false, false, false, false])
                }
            }
        }
    }
    
    private func startSmoothProgressAnimation(successSteps: [Bool]) {
        let totalDuration: TimeInterval = 4.0 // Total animation duration
        let stepDuration = totalDuration / Double(successSteps.count)
        
        // Create a custom progress animation
        var currentProgress: Float = 0.0
        let progressIncrement: Float = 0.01
        let updateInterval: TimeInterval = 0.04 // Update every 40ms for smooth animation
        
        let progressTimer = Timer.scheduledTimer(withTimeInterval: updateInterval, repeats: true) { timer in
            currentProgress += progressIncrement
            if currentProgress > 1.0 {
                currentProgress = 1.0
                timer.invalidate()
            }
            
            DispatchQueue.main.async {
                self.progressView.setProgress(currentProgress, animated: false)
                self.progressLabel.text = "\(Int(currentProgress * 100))% Complete"
            }
        }
        
        // Update checklist steps at appropriate intervals
        for (index, success) in successSteps.enumerated() {
            DispatchQueue.main.asyncAfter(deadline: .now() + stepDuration * Double(index + 1)) {
                self.updateStep(index, success: success)
            }
        }
        
        // Complete processing after animation
        DispatchQueue.main.asyncAfter(deadline: .now() + totalDuration + 0.5) {
            self.processingComplete()
        }
    }
    
    private func updateStep(_ stepIndex: Int, success: Bool) {
        DispatchQueue.main.async {
            // Update checklist based on success
            if success {
                self.stepCheckmarks[stepIndex].image = UIImage(systemName: "checkmark.circle.fill")
                self.stepCheckmarks[stepIndex].tintColor = UIColor.systemGreen
                self.stepLabels[stepIndex].textColor = UIColor.white
            } else {
                self.stepCheckmarks[stepIndex].image = UIImage(systemName: "xmark.circle.fill")
                self.stepCheckmarks[stepIndex].tintColor = UIColor.systemRed
                self.stepLabels[stepIndex].textColor = UIColor.systemRed
            }
        }
    }
    
    private func processingComplete() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            // Navigate to the final event form with extracted data
            let eventFormVC = EventFormViewController()
            eventFormVC.setExtractedData(self.extractedData)
            
            // Set the selected image for preview
            if let image = self.selectedImage {
                eventFormVC.selectedImage = image
            }
            
            // Pre-populate the form with extracted data
            if let title = self.extractedData["title"] as? String {
                eventFormVC.titleTextField.text = title
            }
            if let location = self.extractedData["location"] as? String {
                eventFormVC.locationTextField.text = location
            }
            if let startTime = self.extractedData["startTime"] as? String {
                if let parsedStartDate = eventFormVC.parseDate(from: startTime) {
                    eventFormVC.selectedStartDate = parsedStartDate
                    eventFormVC.startDatePicker.date = parsedStartDate
                }
            }
            if let endTime = self.extractedData["endTime"] as? String {
                if let parsedEndDate = eventFormVC.parseDate(from: endTime) {
                    eventFormVC.selectedEndDate = parsedEndDate
                    eventFormVC.endDatePicker.date = parsedEndDate
                }
            }
            
            eventFormVC.updateDateButtonTitles()
            self.navigationController?.pushViewController(eventFormVC, animated: true)
        }
    }
    
    // MARK: - Image Preview
    @objc private func imagePreviewTapped() {
        guard let image = selectedImage else { return }
        showFullScreenImage(image)
    }
    
    private func showFullScreenImage(_ image: UIImage) {
        let fullScreenVC = UIViewController()
        fullScreenVC.view.backgroundColor = UIColor.black
        
        let imageView = UIImageView(image: image)
        imageView.contentMode = .scaleAspectFit
        imageView.translatesAutoresizingMaskIntoConstraints = false
        fullScreenVC.view.addSubview(imageView)
        
        // Close button
        let closeButton = UIButton(type: .system)
        closeButton.setTitle("✕", for: .normal)
        closeButton.titleLabel?.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        closeButton.setTitleColor(.white, for: .normal)
        closeButton.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        closeButton.layer.cornerRadius = 20
        closeButton.translatesAutoresizingMaskIntoConstraints = false
        closeButton.addTarget(self, action: #selector(dismissFullScreenImage), for: .touchUpInside)
        fullScreenVC.view.addSubview(closeButton)
        
        NSLayoutConstraint.activate([
            imageView.topAnchor.constraint(equalTo: fullScreenVC.view.topAnchor),
            imageView.leadingAnchor.constraint(equalTo: fullScreenVC.view.leadingAnchor),
            imageView.trailingAnchor.constraint(equalTo: fullScreenVC.view.trailingAnchor),
            imageView.bottomAnchor.constraint(equalTo: fullScreenVC.view.bottomAnchor),
            
            closeButton.topAnchor.constraint(equalTo: fullScreenVC.view.safeAreaLayoutGuide.topAnchor, constant: 16),
            closeButton.trailingAnchor.constraint(equalTo: fullScreenVC.view.trailingAnchor, constant: -16),
            closeButton.widthAnchor.constraint(equalToConstant: 40),
            closeButton.heightAnchor.constraint(equalToConstant: 40)
        ])
        
        fullScreenVC.modalPresentationStyle = .fullScreen
        present(fullScreenVC, animated: true)
    }
    
    @objc private func dismissFullScreenImage() {
        dismiss(animated: true)
    }
} 