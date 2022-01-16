//
//  EditProfileFooter.swift
//  TwitterClone
//
//  Created by benji on 04/01/2022.
//

import UIKit

protocol EditProfileFooterDelegate: AnyObject {
    func handleLogout()
}

class EditProfileFooter: UIView {
    
    // MARK: - Properties
    
    weak var delegate: EditProfileFooterDelegate?
    
    private lazy var logoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Logout", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        button.addTarget(self, action: #selector(handleLogout), for: .touchUpInside)
        button.backgroundColor = .red
        button.layer.cornerRadius = 5
        return button
    }()
    
    // MARK: - Lifecycle
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(logoButton)
        logoButton.anchor(left: leftAnchor, right: rightAnchor, paddingLeft: 16, paddingRight: 16)
        logoButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logoButton.centerY(inView: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleLogout() {
        delegate?.handleLogout()
    }
    
}
