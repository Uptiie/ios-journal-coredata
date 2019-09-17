//
//  EntryDetailViewController.swift
//  Journal Core Data
//
//  Created by Uptiie on 9/17/19.
//  Copyright © 2019 Lambda School. All rights reserved.
//

import UIKit

class EntryDetailViewController: UIControl {
    
    // MARK: - Properties
    
    let titleContainerView: UIView = UIView()
    let titleTextField: UITextField = UITextField()
    let textContainerView: UIView = UIView()
    let textView: UITextView = UITextView()
    
    // MARK: - Required Initializers
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupSubViews()
    }
    
    // MARK: - Methods and Functions
    
    func setupSubViews() {
        // Background image
        addSubview(titleContainerView)
        titleContainerView.translatesAutoresizingMaskIntoConstraints = false
        titleContainerView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30).isActive = true
        titleContainerView.topAnchor.constraint(equalTo: topAnchor, constant: 40).isActive = true
        titleContainerView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30).isActive = true
        titleContainerView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        titleContainerView.layer.backgroundColor = #colorLiteral(red: 0.9094783664, green: 0.9096308351, blue: 0.90945822, alpha: 1)
    }

}
