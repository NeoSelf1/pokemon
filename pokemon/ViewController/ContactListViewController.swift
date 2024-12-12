//
//  ContactListViewController.swift
//  pokemon
//
//  Created by Neoself on 12/12/24.
//
import UIKit
import SwiftUI

class ContactListViewController: UIViewController {
    private let tableView = UITableView()
    private var contacts: [ContactEntity] = [] {didSet{sortContacts()}}
    private var sortedContacts: [ContactEntity] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadContacts()
        sortContacts()
    }
    
    private func setupUI() {
        title = "친구 목록"
        view.backgroundColor = .systemBackground
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(ContactCell.self, forCellReuseIdentifier: "ContactCell")
        
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }
    
    private func setupNavigationBar() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addButtonTapped)
        )
    }
    
    private func sortContacts() {
        sortedContacts = contacts.sorted { contact1, contact2 in
            let name1 = contact1.name ?? ""
            let name2 = contact2.name ?? ""
            return name1.localizedStandardCompare(name2) == .orderedAscending
        }
        tableView.reloadData()
    }
        
    private func loadContacts() {
        contacts = CoreDataManager.shared.fetchContacts()
        tableView.reloadData()
    }
    
    @objc private func addButtonTapped() {
        let phoneBookVC = PhoneBookViewController()
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
}

extension ContactListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sortedContacts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ContactCell", for: indexPath) as! ContactCell
        let contact = sortedContacts[indexPath.row]
        cell.configure(with: contact)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let contact = sortedContacts[indexPath.row]
        let phoneBookVC = PhoneBookViewController(contact: contact, mode: .edit)
        navigationController?.pushViewController(phoneBookVC, animated: true)
    }
}

struct ContactListViewController_Previews: PreviewProvider {
    static var previews: some View {
        // UIKit 뷰컨트롤러를 SwiftUI로 래핑
        let viewController = ContactListViewController()
        let navigationController = UINavigationController(rootViewController: viewController)
        return navigationController.toPreview()
    }
}

// UIViewController를 SwiftUI View로 변환하는 extension
extension UIViewController {
    private struct Preview: UIViewControllerRepresentable {
        let viewController: UIViewController
        
        func makeUIViewController(context: Context) -> UIViewController {
            return viewController
        }
        
        func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    }
    
    func toPreview() -> some View {
        Preview(viewController: self)
    }
}
