//
//  EditProfileCell.swift
//  TwitterClone
//
//  Created by benji on 04/01/2022.
//

import UIKit

protocol EditProfileCellDelegate: AnyObject {
    func UpdateUserInfo(_ cell: EditProfileCell)
}

class EditProfileCell: UITableViewCell {
    
    // MARK: - Properties
    

    
    weak var delegate: EditProfileCellDelegate?
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 14)
        return label
    }()
    
    lazy var infoTextField: UITextField = {
        let tf = UITextField()
        tf.borderStyle = .none
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.textAlignment = .left
        tf.textColor = .twitterBlue
        tf.addTarget(self, action: #selector(handleUpdateUserInfo), for: .editingChanged)
        tf.text = "test user attribute"
        return tf
    }()
    
    
    // MARK: - Lifecycle
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .white
        selectionStyle = .none
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Selectors
    
    @objc func handleUpdateUserInfo() {
        delegate?.UpdateUserInfo(self)
    }
    
    // MARK: - Helpers
    

}
