//
//  EditProfileController.swift
//  TwitterClone
//
//  Created by benji on 04/01/2022.
//

import UIKit
import Firebase

private let reuseID = "EditProfileCell"



class EditProfileController: UITableViewController {
    
    // MARK: - Properties
    
    
    private let user: User
    private lazy var headerView = EditProfileHeader(user: user)
    private let footerView = EditProfileFooter()
    private let imagePicker = UIImagePickerController()
    
    private var selectedImage: UIImage? {
        didSet {
            headerView.profileImageView.image = selectedImage
        }
    }
    
    // MARK: - Lifecycle
    
    init(user: User) {
        self.user = user
        super.init(style: .plain)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureImagePicker()
        configureNavigationBar()
        configureTableView()
    }
    
        // MARK: - Selectors
    
    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func handleDone() {
        dismiss(animated: true, completion: nil)
    }
    
        // MARK: - API
    
        // MARK: - Helpers
    
    func configureNavigationBar() {
        navigationController?.navigationBar.barTintColor = .twitterBlue
        navigationController?.navigationBar.barStyle = .black
        navigationController?.navigationBar.isTranslucent = false
        navigationController?.navigationBar.tintColor = .white
        
        navigationItem.title = "Edit Profile"
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .cancel, target: self, action: #selector(handleCancel))
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(handleDone))
        navigationItem.rightBarButtonItem?.isEnabled = false
    }
    
    func configureTableView() {
        tableView.tableHeaderView = headerView
        headerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 180)
        headerView.delegate = self
        
        footerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 100)
        tableView.tableFooterView = footerView
        footerView.delegate = self
        
        tableView.register(EditProfileCell.self, forCellReuseIdentifier: reuseID)
    }
    
    func configureImagePicker() {
        imagePicker.delegate = self
        imagePicker.allowsEditing = true
    }
    
    func logUserOut() {
        do {
            try Auth.auth().signOut()
            let nav = UINavigationController(rootViewController: LoginController())
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch let error {
            print("DEBUG: Failed to sign out with error \(error.localizedDescription)")
        }
    }
    
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return EditProfileOptions.allCases.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseID, for: indexPath) as! EditProfileCell
        return cell
    }
}

extension EditProfileController {
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        guard let option = EditProfileOptions(rawValue: indexPath.row) else {return 0}
        return option == .bio ? 100 : 48
    }
}

extension EditProfileController: EditProfileHeaderDelegate {
    func didTapChangeProfilePhoto() {
        present(imagePicker, animated: true, completion: nil)
    }
    
}

extension EditProfileController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        guard let image = info[.editedImage] as? UIImage else {return}
        self.selectedImage = image
        
        dismiss(animated: true, completion: nil)
    }
}

extension EditProfileController: EditProfileFooterDelegate {
    func handleLogout() {
        
        let alert = UIAlertController(title: nil, message: "Are you sure you want to logout?", preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "Logout", style: .destructive, handler: { _ in
            self.logUserOut()
//            self.dismiss(animated: true) {
//                self.logUserOut()
//            }
        }))
        
        alert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        
        present(alert, animated: true, completion: nil)
    }
}


