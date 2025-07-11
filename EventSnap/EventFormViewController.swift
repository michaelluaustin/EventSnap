import UIKit

class EventFormViewController: UIViewController {
    
    private var selectedImage: UIImage?
    private var selectedStartDate: Date?
    private var selectedEndDate: Date?
    
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
        label.text = "Extract Event Details"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Upload or capture an image of an event flyer to automatically fill in the details."
        label.font = UIFont.systemFont(ofSize: 14)
        label.textColor = UIColor.secondaryLabel
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 12
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Take Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let choosePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemGray5
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let startDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Start Date & Time", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let endDateButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("End Date & Time", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16)
        button.backgroundColor = UIColor.systemGray6
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 8
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    private let startDatePicker = UIDatePicker()
    private let endDatePicker = UIDatePicker()
    
    private let imagePreviewView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.backgroundColor = UIColor.systemGray6
        imageView.layer.cornerRadius = 8
        imageView.clipsToBounds = true
        imageView.isHidden = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let loadingView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.systemGray6
        view.layer.cornerRadius = 8
        view.isHidden = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private let loadingSpinner: UIActivityIndicatorView = {
        let spinner = UIActivityIndicatorView(style: .large)
        spinner.color = UIColor.systemBlue
        spinner.translatesAutoresizingMaskIntoConstraints = false
        return spinner
    }()
    
    private let loadingLabel: UILabel = {
        let label = UILabel()
        label.text = "Processing image..."
        label.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Event Title"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Location"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let addToCalendarButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Add to Calendar", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupConstraints()
        setupActions()
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imageButtonsStackView)
        contentView.addSubview(imagePreviewView)
        contentView.addSubview(loadingView)
        contentView.addSubview(titleTextField)
        contentView.addSubview(startDateButton)
        contentView.addSubview(endDateButton)
        contentView.addSubview(locationTextField)
        contentView.addSubview(addToCalendarButton)
        
        imageButtonsStackView.addArrangedSubview(takePhotoButton)
        imageButtonsStackView.addArrangedSubview(choosePhotoButton)
        
        // Setup loading view
        loadingView.addSubview(loadingSpinner)
        loadingView.addSubview(loadingLabel)
        
        setupDatePickers()
        setupScrollViewForKeyboard()
    }
    
    private func setupDatePickers() {
        startDatePicker.datePickerMode = .dateAndTime
        startDatePicker.preferredDatePickerStyle = .wheels
        startDatePicker.date = Date()
        startDatePicker.addTarget(self, action: #selector(startDateChanged), for: .valueChanged)
        
        endDatePicker.datePickerMode = .dateAndTime
        endDatePicker.preferredDatePickerStyle = .wheels
        endDatePicker.date = Date().addingTimeInterval(3600) // 1 hour later as default picker date
        endDatePicker.addTarget(self, action: #selector(endDateChanged), for: .valueChanged)
        
        updateDateButtonTitles()
    }

    private func updateDateButtonTitles() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if let startDate = selectedStartDate {
            startDateButton.setTitle("Start: \(formatter.string(from: startDate))", for: .normal)
        } else {
            startDateButton.setTitle("Start Date & Time", for: .normal)
        }
        
        if let endDate = selectedEndDate {
            endDateButton.setTitle("End: \(formatter.string(from: endDate))", for: .normal)
        } else {
            endDateButton.setTitle("End Date & Time", for: .normal)
        }
    }

    @objc private func startDateChanged() {
        selectedStartDate = startDatePicker.date
        updateDateButtonTitles()
    }

    @objc private func endDateChanged() {
        selectedEndDate = endDatePicker.date
        updateDateButtonTitles()
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
            
            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            titleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 8),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            imageButtonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            imageButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imageButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imageButtonsStackView.heightAnchor.constraint(equalToConstant: 44),
            
            imagePreviewView.topAnchor.constraint(equalTo: imageButtonsStackView.bottomAnchor, constant: 16),
            imagePreviewView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            imagePreviewView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            imagePreviewView.heightAnchor.constraint(equalToConstant: 200),
            
            loadingView.topAnchor.constraint(equalTo: imageButtonsStackView.bottomAnchor, constant: 16),
            loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loadingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loadingView.heightAnchor.constraint(equalToConstant: 200),
            
            loadingSpinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 16),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: imagePreviewView.bottomAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            startDateButton.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            startDateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            startDateButton.heightAnchor.constraint(equalToConstant: 44),

            endDateButton.topAnchor.constraint(equalTo: startDateButton.bottomAnchor, constant: 16),
            endDateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            endDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            endDateButton.heightAnchor.constraint(equalToConstant: 44),
            
            locationTextField.topAnchor.constraint(equalTo: endDateButton.bottomAnchor, constant: 16),
            locationTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            locationTextField.heightAnchor.constraint(equalToConstant: 44),
            
            addToCalendarButton.topAnchor.constraint(equalTo: locationTextField.bottomAnchor, constant: 32),
            addToCalendarButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            addToCalendarButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            addToCalendarButton.heightAnchor.constraint(equalToConstant: 50),
            addToCalendarButton.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -20)
        ])
    }
    
private func setupActions() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoButtonTapped), for: .touchUpInside)
        choosePhotoButton.addTarget(self, action: #selector(choosePhotoButtonTapped), for: .touchUpInside)
        startDateButton.addTarget(self, action: #selector(startDateButtonTapped), for: .touchUpInside)
        endDateButton.addTarget(self, action: #selector(endDateButtonTapped), for: .touchUpInside)
        addToCalendarButton.addTarget(self, action: #selector(addToCalendarButtonTapped), for: .touchUpInside)
        titleTextField.delegate = self
        locationTextField.delegate = self
    }
    
    @objc private func takePhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .camera
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func choosePhotoButtonTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = .photoLibrary
        imagePicker.delegate = self
        present(imagePicker, animated: true)
    }
    
    @objc private func addToCalendarButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              let startDate = selectedStartDate,
              let endDate = selectedEndDate else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill in title, location, start date, and end date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        CalendarManager.shared.addEventToCalendar(title: title, location: location, startDate: startDate, endDate: endDate) { [weak self] success, error in
            DispatchQueue.main.async {
                if success {
                    let alert = UIAlertController(title: "Success!", message: "Event added to your calendar", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default) { _ in
                        self?.navigationController?.popViewController(animated: true)
                    })
                    self?.present(alert, animated: true)
                } else {
                    let alert = UIAlertController(title: "Error", message: error?.localizedDescription ?? "Failed to add event to calendar", preferredStyle: .alert)
                    alert.addAction(UIAlertAction(title: "OK", style: .default))
                    self?.present(alert, animated: true)
                }
            }
        }
    }
    
    @objc private func startDateButtonTapped() {
        let alert = UIAlertController(title: "Select Start Date & Time", message: nil, preferredStyle: .actionSheet)
        
        let datePickerVC = UIViewController()
        datePickerVC.view.addSubview(startDatePicker)
        startDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            startDatePicker.topAnchor.constraint(equalTo: datePickerVC.view.topAnchor, constant: 20),
            startDatePicker.leadingAnchor.constraint(equalTo: datePickerVC.view.leadingAnchor, constant: 20),
            startDatePicker.trailingAnchor.constraint(equalTo: datePickerVC.view.trailingAnchor, constant: -20),
            startDatePicker.bottomAnchor.constraint(equalTo: datePickerVC.view.bottomAnchor, constant: -20)
        ])
        
        alert.setValue(datePickerVC, forKey: "contentViewController")
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.startDateChanged()
        }
        alert.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }

    @objc private func endDateButtonTapped() {
        let alert = UIAlertController(title: "Select End Date & Time", message: nil, preferredStyle: .actionSheet)
        
        let datePickerVC = UIViewController()
        datePickerVC.view.addSubview(endDatePicker)
        endDatePicker.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            endDatePicker.topAnchor.constraint(equalTo: datePickerVC.view.topAnchor, constant: 20),
            endDatePicker.leadingAnchor.constraint(equalTo: datePickerVC.view.leadingAnchor, constant: 20),
            endDatePicker.trailingAnchor.constraint(equalTo: datePickerVC.view.trailingAnchor, constant: -20),
            endDatePicker.bottomAnchor.constraint(equalTo: datePickerVC.view.bottomAnchor, constant: -20)
        ])
        
        alert.setValue(datePickerVC, forKey: "contentViewController")
        
        let doneAction = UIAlertAction(title: "Done", style: .default) { _ in
            self.endDateChanged()
        }
        alert.addAction(doneAction)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(cancelAction)
        
        present(alert, animated: true)
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    private func setupScrollViewForKeyboard() {
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        scrollView.addGestureRecognizer(tapGesture)
    }

    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
    
    // MARK: - Loading State Management
    private func showLoadingState() {
        loadingView.isHidden = false
        imagePreviewView.isHidden = true
        loadingSpinner.startAnimating()
    }
    
    private func hideLoadingState() {
        loadingView.isHidden = true
        imagePreviewView.isHidden = false
        loadingSpinner.stopAnimating()
    }
    // MARK: - Date Parsing
    private func parseDate(from dateString: String) -> Date? {
        // Try ISO 8601 format first
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        
        // Try custom date formatters for common formats
        let formatters = [
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss"),
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssZ"),
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
            createDateFormatter(format: "yyyy-MM-dd HH:mm:ss"),
            createDateFormatter(format: "MM/dd/yyyy HH:mm"),
            createDateFormatter(format: "MM/dd/yyyy"),
            createDateFormatter(format: "MMM dd, yyyy HH:mm"),
            createDateFormatter(format: "MMM dd, yyyy"),
            createDateFormatter(format: "MMMM dd, yyyy HH:mm"),
            createDateFormatter(format: "MMMM dd, yyyy"),
            
            // Relative date formats
            createDateFormatter(format: "EEEE, MMM dd"),
            createDateFormatter(format: "EEEE, MMMM dd"),
        ]
        
        for formatter in formatters {
            if let date = formatter.date(from: dateString) {
                return date
            }
        }
        
        // Try parsing relative dates like "tomorrow at 2pm", "next Friday", etc.
        if let relativeDate = parseRelativeDate(from: dateString) {
            return relativeDate
        }
        
        print("Could not parse date: \(dateString)")
        return nil
    }
    
    private func createDateFormatter(format: String) -> DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = format
        formatter.locale = Locale(identifier: "en_US_POSIX")
        return formatter
    }
    
    private func parseRelativeDate(from dateString: String) -> Date? {
        let calendar = Calendar.current
        let now = Date()
        let lowercased = dateString.lowercased()
        
        // Handle "tomorrow"
        if lowercased.contains("tomorrow") {
            if let tomorrow = calendar.date(byAdding: .day, value: 1, to: now) {
                return extractTimeFromString(dateString, baseDate: tomorrow)
            }
        }
        
        // Handle "next [day]"
        let weekdays = ["monday", "tuesday", "wednesday", "thursday", "friday", "saturday", "sunday"]
        for (index, day) in weekdays.enumerated() {
            if lowercased.contains("next \(day)") {
                let weekday = index + 1
                if let nextWeekday = calendar.nextDate(after: now, matching: DateComponents(weekday: weekday), matchingPolicy: .nextTime) {
                    return extractTimeFromString(dateString, baseDate: nextWeekday)
                }
            }
        }
        
        // Handle "today"
        if lowercased.contains("today") {
            return extractTimeFromString(dateString, baseDate: now)
        }
        
        return nil
    }
    
    private func extractTimeFromString(_ dateString: String, baseDate: Date) -> Date? {
        let calendar = Calendar.current
        let lowercased = dateString.lowercased()
        
        // Extract time patterns
        let timePatterns = [
            (pattern: "(\\d{1,2}):(\\d{2})\\s*(am|pm)", format: "h:mm a"),
            (pattern: "(\\d{1,2}):(\\d{2})", format: "HH:mm"),
            (pattern: "(\\d{1,2})\\s*(am|pm)", format: "h a"),
        ]
        
        for (pattern, format) in timePatterns {
            if let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive),
               let match = regex.firstMatch(in: dateString, options: [], range: NSRange(location: 0, length: dateString.count)) {
                
                let timeString = (dateString as NSString).substring(with: match.range)
                let formatter = DateFormatter()
                formatter.dateFormat = format
                formatter.locale = Locale(identifier: "en_US_POSIX")
                
                if let timeDate = formatter.date(from: timeString) {
                    let timeComponents = calendar.dateComponents([.hour, .minute], from: timeDate)
                    return calendar.date(bySettingHour: timeComponents.hour ?? 0, minute: timeComponents.minute ?? 0, second: 0, of: baseDate)
                }
            }
        }
        
        // If no time found, use the base date as is
        return baseDate
    }
}

extension EventFormViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            selectedImage = image
            imagePreviewView.image = image
            
            // Show loading state
            showLoadingState()
            
            // Extract text from image using Vision, then analyze with OpenAI
            ImageProcessor.shared.extractTextFromImage(image) { [weak self] text in
                if let text = text {
                    print("=== VISION EXTRACTED TEXT ===")
                    print(text)
                    print("=============================")
                    
                    // Now send to OpenAI for intelligent analysis
                    ImageProcessor.shared.extractEventDetailsWithAI(from: text) { eventDetails in
                        DispatchQueue.main.async {
                            // Hide loading state
                            self?.hideLoadingState()
                            
                            if let details = eventDetails {
                                print("=== OPENAI EXTRACTED DETAILS ===")
                                print("Title: \(details.title)")
                                print("Location: \(details.location)")
                                print("Start Date: \(details.startDate ?? "Not found")")
                                print("End Date: \(details.endDate ?? "Not found")")
                                print("Description: \(details.description ?? "Not found")")
                                print("=================================")
                                
                                self?.titleTextField.text = details.title
                                self?.locationTextField.text = details.location
                                
                                // Parse dates and update date pickers
                                if let startDateString = details.startDate {
                                    if let parsedStartDate = self?.parseDate(from: startDateString) {
                                        self?.selectedStartDate = parsedStartDate
                                        self?.startDatePicker.date = parsedStartDate
                                    }
                                }
                                
                                if let endDateString = details.endDate {
                                    if let parsedEndDate = self?.parseDate(from: endDateString) {
                                        self?.selectedEndDate = parsedEndDate
                                        self?.endDatePicker.date = parsedEndDate
                                    }
                                }
                                
                                // Update the button titles to reflect the new dates
                                self?.updateDateButtonTitles()
                            } else {
                                print("OpenAI extraction failed")
                                self?.titleTextField.text = "Sample Event"
                                self?.locationTextField.text = "Sample Location"
                            }
                        }
                    }
                } else {
                    DispatchQueue.main.async {
                        // Hide loading state
                        self?.hideLoadingState()
                        self?.titleTextField.text = "Sample Event"
                        self?.locationTextField.text = "Sample Location"
                    }
                }
            }
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

extension EventFormViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
