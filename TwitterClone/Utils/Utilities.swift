//
//  Utilities.swift
//  TwitterClone
//
//  Created by benji on 18/12/2021.
//

import UIKit

class Uitilites {
    
    func inputContainerView(withImage image: UIImage, textField: UITextField) -> UIView {
        
        let view = UIView()
        let iv = UIImageView()
        view.heightAnchor.constraint(equalToConstant: 50).isActive = true

        
        iv.image = image
        iv.tintColor = .white
        view.addSubview(iv)
        iv.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, paddingLeft: 8, paddingBottom: 8)
        iv.setDimensions(width: 24, height: 24)
        
        view.addSubview(textField)
        textField.anchor(left: iv.rightAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 8, paddingBottom: 8)
        
        let seperatedView = UIView()
        seperatedView.backgroundColor = .white
        view.addSubview(seperatedView)
        seperatedView.anchor(left: view.leftAnchor, bottom: view.bottomAnchor, right: view.rightAnchor, paddingLeft: 10, paddingRight: 10, height: 0.75)
        
        return view
       
    }
    
    func textField(withPlaceholder placeholder: String) -> UITextField {
        let tf = UITextField()
        tf.textColor = .white
        tf.font = UIFont.systemFont(ofSize: 16)
        tf.attributedPlaceholder = NSAttributedString(string: placeholder, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
        return tf
    }
    
    func attributedButton(firstPart: String, secondPart: String) -> UIButton {
        let button = UIButton(type: .system)
        
        let attributedTitle = NSMutableAttributedString(string: firstPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedTitle.append(NSAttributedString(string: secondPart, attributes: [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 16),
            NSAttributedString.Key.foregroundColor: UIColor.white]))
        
        button.setAttributedTitle(attributedTitle, for: .normal)
        
        return button
    }
}


