//
//  ContactCell.swift
//  pokemon
//
//  Created by Neoself on 12/12/24.
//
import UIKit

class ContactCell: UITableViewCell {
    private let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.layer.cornerRadius = 32
        imageView.layer.masksToBounds = true
        imageView.backgroundColor = .white
        imageView.layer.borderColor = CGColor.fromHex("#4E5BFF")
        imageView.layer.borderWidth = 1
        return imageView
    }()
    
    private let nameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 16, weight: .medium)
        return label
    }()
    
    private let phoneLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 14)
        label.textColor = .secondaryLabel
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupUI() {
        [profileImageView, nameLabel, phoneLabel].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            profileImageView.widthAnchor.constraint(equalToConstant: 64),
            profileImageView.heightAnchor.constraint(equalToConstant: 64),
            
            nameLabel.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 12),
            nameLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 20),
            
            phoneLabel.leadingAnchor.constraint(equalTo: nameLabel.leadingAnchor),
            phoneLabel.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 4)
        ])
    }
    
    func configure(with contact: ContactEntity) {
        nameLabel.text = contact.name
        phoneLabel.text = contact.phoneNumber
        
        if let imageUrlString = contact.profileImageUrl {
            NetworkManager.shared.downloadImage(from: imageUrlString) { [weak self] image in
                DispatchQueue.main.async {
                    self?.profileImageView.image = image
                }
            }
        } else {
            profileImageView.image = UIImage(systemName: "person.circle.fill")
        }
    }
}
