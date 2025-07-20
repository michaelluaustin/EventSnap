import UIKit

class EventFormViewController: UIViewController {
    
    internal var selectedImage: UIImage?
    internal var selectedStartDate: Date?
    internal var selectedEndDate: Date?
    
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
        label.text = "Review Event Details"
        label.font = UIFont.systemFont(ofSize: 24, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Make sure to double-check if all the details look correct!"
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

    internal let startDatePicker = UIDatePicker()
    internal let endDatePicker = UIDatePicker()
    

    
    private let showImageButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Show Image", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        button.backgroundColor = UIColor.systemGray5
        button.setTitleColor(UIColor.systemBlue, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.systemGray4.cgColor
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
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
    
    private let eventTitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Title"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let titleTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter event title"
        textField.borderStyle = .roundedRect
        textField.font = UIFont.systemFont(ofSize: 16)
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private let startDateLabel: UILabel = {
        let label = UILabel()
        label.text = "Start Time/Date"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let endDateLabel: UILabel = {
        let label = UILabel()
        label.text = "End Time/Date"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let locationLabel: UILabel = {
        let label = UILabel()
        label.text = "Event Location"
        label.font = UIFont.systemFont(ofSize: 14, weight: .medium)
        label.textColor = UIColor.label
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    internal let locationTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter event location"
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
        
        // Hide photo input buttons since this is the final review page
        imageButtonsStackView.isHidden = true
        loadingView.isHidden = true
        
        // Show image button for review
        showImageButton.isHidden = false
    }
    
    // Method to set extracted data from processing
    func setExtractedData(_ data: [String: Any]) {
        // This will be called from ProcessingViewController
        // For now, we'll use the existing image processing logic
        // In a real implementation, you'd pass the extracted data here
    }
    
    private func setupUI() {
        view.backgroundColor = UIColor.systemBackground
        
        view.addSubview(scrollView)
        scrollView.addSubview(contentView)
        
        contentView.addSubview(titleLabel)
        contentView.addSubview(subtitleLabel)
        contentView.addSubview(imageButtonsStackView)
        contentView.addSubview(showImageButton)
        contentView.addSubview(loadingView)
        contentView.addSubview(eventTitleLabel)
        contentView.addSubview(titleTextField)
        contentView.addSubview(startDateLabel)
        contentView.addSubview(startDateButton)
        contentView.addSubview(endDateLabel)
        contentView.addSubview(endDateButton)
        contentView.addSubview(locationLabel)
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

    internal func updateDateButtonTitles() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        
        if let startDate = selectedStartDate {
            startDateButton.setTitle(formatter.string(from: startDate), for: .normal)
        } else {
            startDateButton.setTitle("Select start date & time", for: .normal)
        }
        
        if let endDate = selectedEndDate {
            endDateButton.setTitle(formatter.string(from: endDate), for: .normal)
        } else {
            endDateButton.setTitle("Select end date & time", for: .normal)
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
            
            showImageButton.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 24),
            showImageButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            showImageButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            showImageButton.heightAnchor.constraint(equalToConstant: 44),
            
            loadingView.topAnchor.constraint(equalTo: imageButtonsStackView.bottomAnchor, constant: 16),
            loadingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            loadingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            loadingView.heightAnchor.constraint(equalToConstant: 200),
            
            loadingSpinner.centerXAnchor.constraint(equalTo: loadingView.centerXAnchor),
            loadingSpinner.centerYAnchor.constraint(equalTo: loadingView.centerYAnchor, constant: -20),
            
            loadingLabel.topAnchor.constraint(equalTo: loadingSpinner.bottomAnchor, constant: 16),
            loadingLabel.leadingAnchor.constraint(equalTo: loadingView.leadingAnchor, constant: 20),
            loadingLabel.trailingAnchor.constraint(equalTo: loadingView.trailingAnchor, constant: -20),
            
            eventTitleLabel.topAnchor.constraint(equalTo: showImageButton.bottomAnchor, constant: 24),
            eventTitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            eventTitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleTextField.topAnchor.constraint(equalTo: eventTitleLabel.bottomAnchor, constant: 8),
            titleTextField.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            titleTextField.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),
            
            startDateLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            startDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            startDateButton.topAnchor.constraint(equalTo: startDateLabel.bottomAnchor, constant: 8),
            startDateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            startDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            startDateButton.heightAnchor.constraint(equalToConstant: 44),

            endDateLabel.topAnchor.constraint(equalTo: startDateButton.bottomAnchor, constant: 16),
            endDateLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            endDateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            endDateButton.topAnchor.constraint(equalTo: endDateLabel.bottomAnchor, constant: 8),
            endDateButton.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            endDateButton.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            endDateButton.heightAnchor.constraint(equalToConstant: 44),
            
            locationLabel.topAnchor.constraint(equalTo: endDateButton.bottomAnchor, constant: 16),
            locationLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            locationLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            locationTextField.topAnchor.constraint(equalTo: locationLabel.bottomAnchor, constant: 8),
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
        showImageButton.addTarget(self, action: #selector(showImageButtonTapped), for: .touchUpInside)
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
    
    @objc private func showImageButtonTapped() {
        guard let image = selectedImage else { return }
        showFullScreenImage(image)
    }
    
    @objc private func addToCalendarButtonTapped() {
        guard let title = titleTextField.text, !title.isEmpty,
              let location = locationTextField.text, !location.isEmpty,
              let startDate = selectedStartDate else {
            let alert = UIAlertController(title: "Missing Information", message: "Please fill in title, location, and start date", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "OK", style: .default))
            present(alert, animated: true)
            return
        }
        
        // If no end date is provided, set it to one hour after the start date
        let endDate = selectedEndDate ?? Calendar.current.date(byAdding: .hour, value: 1, to: startDate) ?? startDate
        
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
        showImageButton.isHidden = true
        loadingSpinner.startAnimating()
    }
    
    private func hideLoadingState() {
        loadingView.isHidden = true
        showImageButton.isHidden = false
        loadingSpinner.stopAnimating()
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
    // MARK: - Date Parsing
    internal func parseDate(from dateString: String) -> Date? {
        // Try ISO 8601 format first
        let isoFormatter = ISO8601DateFormatter()
        if let date = isoFormatter.date(from: dateString) {
            return date
        }
        
        // Try custom date formatters for common formats
        let formatters = [
            // ISO formats (most common for API responses)
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm"),
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss"),
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ssZ"),
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSSZ"),
            createDateFormatter(format: "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"),
            
            // Other common formats
            createDateFormatter(format: "yyyy-MM-dd HH:mm:ss"),
            createDateFormatter(format: "yyyy-MM-dd HH:mm"),
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
            
            // Show loading state
            showLoadingState()
            
            // Extract event details directly from image using OpenAI Vision API
            ImageProcessor.shared.extractEventDetailsFromImage(image) { [weak self] eventDetails in
                DispatchQueue.main.async {
                    // Hide loading state
                    self?.hideLoadingState()
                    
                    if let details = eventDetails {
                        print("=== OPENAI API EXTRACTED DETAILS ===")
                        print("Title: \(details.eventTitle)")
                        print("Location: \(details.location)")
                        print("Start Time: \(details.startTime)")
                        print("End Time: \(details.endTime)")
                        print("Description: \(details.description ?? "Not found")")
                        print("RSVP Link: \(details.rsvpLink ?? "Not found")")
                        print("=======================================")
                        
                        self?.titleTextField.text = details.eventTitle
                        self?.locationTextField.text = details.location
                        
                        // Parse dates and update date pickers
                        print("Attempting to parse start time: '\(details.startTime)'")
                        if let parsedStartDate = self?.parseDate(from: details.startTime) {
                            print("Successfully parsed start date: \(parsedStartDate)")
                            self?.selectedStartDate = parsedStartDate
                            self?.startDatePicker.date = parsedStartDate
                        } else {
                            print("Failed to parse start date from: '\(details.startTime)'")
                        }
                        
                        print("Attempting to parse end time: '\(details.endTime)'")
                        if let parsedEndDate = self?.parseDate(from: details.endTime) {
                            print("Successfully parsed end date: \(parsedEndDate)")
                            self?.selectedEndDate = parsedEndDate
                            self?.endDatePicker.date = parsedEndDate
                        } else {
                            print("Failed to parse end date from: '\(details.endTime)'")
                        }
                        
                        // Update the button titles to reflect the new dates
                        self?.updateDateButtonTitles()
                    } else {
                        print("OpenAI Vision extraction failed")
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
