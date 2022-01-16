//
//  ConversationController.swift
//  TwitterClone
//
//  Created by benji on 16/12/2021.
//

import UIKit

class ConversationController: UIViewController {
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()
    }
    
    // MARK: - Helpers
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Messages"
    }
}
