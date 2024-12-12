//
//  PhoneBookViewController.swift
//  pokemon
//
//  Created by Neoself on 12/12/24.
//
import UIKit
import UIKit

class PhoneBookViewController: UIViewController {
    enum Mode {
        case add
        case edit
    }
    
    private let mode: Mode
    private var contact: ContactEntity?
    private var lastPokemonImageUrl: String?
    
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 60
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .systemGray5
        imageView.image = UIImage(systemName: "person.circle.fill")
        return imageView
    }()
    
    private let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "이름"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let phoneTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "전화번호"
        textField.borderStyle = .roundedRect
        return textField
    }()
    
    private let addButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("랜덤 이미지 생성", for: .normal)
        button.backgroundColor = UIColor(hex: "#4E5BFF")
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        return button
    }()
    
    init(contact: ContactEntity? = nil, mode: Mode = .add) {
        self.contact = contact
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
        setupRandomPokemonButton()
        
        if mode == .edit {
            configureForEditing()
        }
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(profileImageTapped))
        profileImageView.addGestureRecognizer(tapGesture)
        profileImageView.isUserInteractionEnabled = true
    }
    
    private func setupUI() {
        title = mode == .add ? "연락처 추가" : contact?.name ?? "연락처 수정"
        view.backgroundColor = .systemBackground
        
        [profileImageView, nameTextField, phoneTextField, addButton].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 20),
            profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 120),
            profileImageView.heightAnchor.constraint(equalToConstant: 120),
            
            addButton.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 16),
            addButton.leadingAnchor.constraint(equalTo: profileImageView.leadingAnchor),
            addButton.trailingAnchor.constraint(equalTo: profileImageView.trailingAnchor),
            addButton.heightAnchor.constraint(equalToConstant: 32),
            
            nameTextField.topAnchor.constraint(equalTo: addButton.bottomAnchor, constant: 20),
            nameTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            phoneTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: 12),
            phoneTextField.leadingAnchor.constraint(equalTo: nameTextField.leadingAnchor),
            phoneTextField.trailingAnchor.constraint(equalTo: nameTextField.trailingAnchor)
        ])
        
        addButton.addTarget(self, action: #selector(randomPokemonTapped), for: .touchUpInside)
    }
    
    private func setupNavigationBar() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .cancel,
            target: self,
            action: #selector(cancelButtonTapped)
        )
    }
    
    private func setupRandomPokemonButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            title: mode == .add ? "적용" : "수정",
            style: .plain,
            target: self,
            action: #selector(saveButtonTapped)
        )
    }
    
    private func configureForEditing() {
        if let contact = contact {
            nameTextField.text = contact.name
            phoneTextField.text = contact.phoneNumber
            lastPokemonImageUrl = contact.profileImageUrl
            
            if let imageUrlString = contact.profileImageUrl {
                loadPokemonImage(from: imageUrlString)
            }
        }
    }
    
    // MARK: - Actions
    @objc private func profileImageTapped() {
        print("Profile image tapped")
    }
    
    @objc private func saveButtonTapped() {
        guard let name = nameTextField.text,
              let phoneNumber = phoneTextField.text,
              !name.isEmpty, !phoneNumber.isEmpty else { return }
        
        switch mode {
        case .add:
            let newContact = ContactEntity(context: CoreDataManager.shared.context)
            updateContactDetails(newContact)
        case .edit:
            if let existingContact = contact {
                updateContactDetails(existingContact)
            }
        }
        
        CoreDataManager.shared.saveContext()
        navigationController?.popViewController(animated: true)
    }
    
    private func updateContactDetails(_ contact: ContactEntity) {
        contact.name = nameTextField.text ?? ""
        contact.phoneNumber = phoneTextField.text ?? ""
        
        if let image = profileImageView.image,
           image != UIImage(systemName: "person.circle.fill") {
            contact.profileImageUrl = lastPokemonImageUrl
        }
    }
    
    @objc private func randomPokemonTapped() {
        NetworkManager.shared.fetchRandomPokemon { [weak self] result in
            switch result {
            case .success(let pokemon):
                DispatchQueue.main.async {
                    self?.nameTextField.text = pokemon.name.capitalized
                    self?.lastPokemonImageUrl = pokemon.sprites.frontDefault
                    self?.loadPokemonImage(from: pokemon.sprites.frontDefault)
                }
            case .failure(let error):
                print("Error fetching Pokemon: \(error)")
            }
        }
    }
    
    private func loadPokemonImage(from urlString: String) {
        NetworkManager.shared.downloadImage(from: urlString) { [weak self] image in
            DispatchQueue.main.async {
                self?.profileImageView.image = image
            }
        }
    }
    
    @objc private func cancelButtonTapped() {
        navigationController?.popViewController(animated: true)
    }
}
