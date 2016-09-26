//
//  CustomTextField.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/24/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import UIKit

class CustomTextField: UITextField {

    // Custom inset for the textfield
    var inset: CGFloat = 8.0
    
    // Change the frame rectangle of the textfield
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: inset, dy: inset)
    }
    
    // Change the frame rectangle of the textfield's edit area
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return textRect(forBounds: bounds)
    }
    
    override func awakeFromNib() {
        setupView()
    }
    
    // configure the view's appearance
    private func setupView(){
        self.borderStyle = .none
    }
    
    
}
