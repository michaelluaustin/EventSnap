import UIKit

class PhotoInputViewController: UIViewController {
    
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
        label.text = "EventSnap"
        label.font = UIFont.systemFont(ofSize: 32, weight: .bold)
        label.textColor = UIColor.systemBlue
        label.textAlignment = .center
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let subtitleLabel: UILabel = {
        let label = UILabel()
        label.text = "Capture event flyers and automatically extract details to add to your calendar"
        label.font = UIFont.systemFont(ofSize: 16)
        label.textColor = UIColor.secondaryLabel
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let imageButtonsStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 20
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()
    
    private let takePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Take Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.systemBlue
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 12
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private let choosePhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Choose Photo", for: .normal)
        button.titleLabel?.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        button.backgroundColor = UIColor.systemGray5
        button.setTitleColor(.label, for: .normal)
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
        
        imageButtonsStackView.addArrangedSubview(takePhotoButton)
        imageButtonsStackView.addArrangedSubview(choosePhotoButton)
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
            
            titleLabel.centerXAnchor.constraint(equalTo: contentView.centerXAnchor),
            titleLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor, constant: -80),
            
            subtitleLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 16),
            subtitleLabel.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 20),
            subtitleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            imageButtonsStackView.topAnchor.constraint(equalTo: subtitleLabel.bottomAnchor, constant: 60),
            imageButtonsStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 40),
            imageButtonsStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -40),
            imageButtonsStackView.heightAnchor.constraint(equalToConstant: 60),
            imageButtonsStackView.bottomAnchor.constraint(lessThanOrEqualTo: contentView.bottomAnchor, constant: -40)
        ])
    }
    
    private func setupActions() {
        takePhotoButton.addTarget(self, action: #selector(takePhotoTapped), for: .touchUpInside)
        choosePhotoButton.addTarget(self, action: #selector(choosePhotoTapped), for: .touchUpInside)
    }
    
    @objc private func takePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .camera
        present(imagePicker, animated: true)
    }
    
    @objc private func choosePhotoTapped() {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = .photoLibrary
        present(imagePicker, animated: true)
    }
}

extension PhotoInputViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true)
        
        if let image = info[.originalImage] as? UIImage {
            // Navigate to processing view controller
            let processingVC = ProcessingViewController(image: image)
            navigationController?.pushViewController(processingVC, animated: true)
        }
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
} 