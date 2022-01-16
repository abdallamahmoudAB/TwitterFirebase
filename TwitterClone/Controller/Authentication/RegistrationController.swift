//
//  RegistrationController.swift
//  TwitterClone
//
//  Created by benji on 17/12/2021.
//

import UIKit
import Firebase

class RegistrationController: UIViewController {
    
    // MARK: - Properties
    
    private let imagepicker = UIImagePickerController()
    private var profileImage: UIImage?
    
    private let plusPhotoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "plus_photo"), for: .normal)
        button.tintColor = .white
        button.addTarget(self, action: #selector(handleAddProfilePhoto), for: .touchUpInside)
        return button
    }()
    
    private lazy var emailContainerView: UIView = {
        let view = Uitilites().inputContainerView(withImage: UIImage(named: "mail")!, textField: emailTextField)
        return view
    }()

    private lazy var passwordContainerView: UIView = {
        let view = Uitilites().inputContainerView(withImage: UIImage(named: "lock")!, textField: passwordTextField)
        return view
        
    }()
    
    private lazy var fullnameContainerView: UIView = {
        let view = Uitilites().inputContainerView(withImage: UIImage(named: "mail")!, textField: fullnameTextField)
        return view
    }()

    private lazy var usernameContainerView: UIView = {
        let view = Uitilites().inputContainerView(withImage: UIImage(named: "lock")!, textField: usernameTextField)
        return view
        
    }()
    
    private let emailTextField: UITextField = {
        let tf = Uitilites().textField(withPlaceholder: "Email")
        return tf
    }()
    
    private let passwordTextField: UITextField = {
        let tf = Uitilites().textField(withPlaceholder: "Password")
        tf.isSecureTextEntry = true
        return tf
    }()
    
    private let fullnameTextField: UITextField = {
        let tf = Uitilites().textField(withPlaceholder: "FullName")
        return tf
    }()
    
    private let usernameTextField: UITextField = {
        let tf = Uitilites().textField(withPlaceholder: "UserName")
        return tf
    }()
    
    private let alreadyHaveaccountButton: UIButton = {
        let button = Uitilites().attributedButton(firstPart: "Already have an account? ", secondPart: "Log In")
        button.addTarget(self, action: #selector(handleShowLogin), for: .touchUpInside)
        return button
    }()
    
    private let signupButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = .white
        button.setTitleColor(.twitterBlue, for: .normal)
        button.setTitle("Sign Up", for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.heightAnchor.constraint(equalToConstant: 50).isActive = true
        button.layer.cornerRadius = 15
        button.addTarget(self, action: #selector(handleSignup), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Selectors
    
    @objc func handleSignup() {
        guard let profileImage = profileImage else {
            print("DEBUG: Please select a profile image..")
            return
        }

        guard let email = emailTextField.text else {return}
        guard let password = passwordTextField.text else {return}
        guard let fullname = fullnameTextField.text else {return}
        guard let username = usernameTextField.text?.lowercased() else {return}
        
       
        let credentials = AuthCredentials(email: email, password: password, fullname: fullname, username: username, profileImage: profileImage)
        
        AuthService.shared.registerUser(credentials: credentials) { error, ref in
            guard let window = UIApplication.shared.windows.first(where: {$0.isKeyWindow}) else {return}
            
            guard let tab = window.rootViewController as? MainTabController else {return}
            
            tab.authenticateUserAndConfigureUI()
            
            self.dismiss(animated: true, completion: nil)
        }

        
        
        
      
    }
    
    @objc func handleAddProfilePhoto() {
        present(imagepicker, animated: true, completion: nil)
    }
    
    @objc func handleShowLogin() {
        navigationController?.popViewController(animated: true)
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .twitterBlue
        
        imagepicker.delegate = self
        imagepicker.allowsEditing = true
        
        view.addSubview(plusPhotoButton)
        plusPhotoButton.centerX(inView: view, topAnchor: view.safeAreaLayoutGuide.topAnchor)
        plusPhotoButton.setDimensions(width: 128, height: 128)
        
        let stack = UIStackView(arrangedSubviews: [emailContainerView,
                                                   passwordContainerView,
                                                   fullnameContainerView, usernameContainerView, signupButton])
        stack.axis = .vertical
        stack.spacing = 20
        stack.distribution = .fillEqually
        view.addSubview(stack)
        stack.anchor(top: plusPhotoButton.bottomAnchor, left: view.leftAnchor, right: view.rightAnchor, paddingTop: 32, paddingLeft: 32, paddingRight: 32)
        
        view.addSubview(alreadyHaveaccountButton)
        alreadyHaveaccountButton.centerX(inView: view)
        alreadyHaveaccountButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10).isActive = true

    }
}

extension RegistrationController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let profileimage = info[.editedImage] as? UIImage else {return}
        self.profileImage = profileimage
        
        plusPhotoButton.layer.cornerRadius = 128 / 2
        plusPhotoButton.layer.masksToBounds = true
        plusPhotoButton.imageView?.contentMode = .scaleAspectFill
        plusPhotoButton.imageView?.clipsToBounds = true
        plusPhotoButton.layer.borderColor = UIColor.white.cgColor
        plusPhotoButton.layer.borderWidth = 3
        
        self.plusPhotoButton.setImage(profileimage.withRenderingMode(.alwaysOriginal), for: .normal)
        
        dismiss(animated: true, completion: nil)
    }
}
