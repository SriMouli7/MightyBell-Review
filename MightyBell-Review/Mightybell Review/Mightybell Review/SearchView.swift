//
//  SearchView.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/24/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import UIKit

class SearchView: UIView {
    
    override func awakeFromNib() {
        setupView()
    }
    
    // Configure View's appearance
    private func setupView(){
        self.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.layer.shadowColor = textFieldShadowColor.cgColor
        self.layer.shadowOpacity = 0.8

    }

}
