//
//  ImageCollectionViewCell.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/24/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    
    // Image view to show the result image
    @IBOutlet weak var resultImageView: UIImageView!
    
    // Single image result record
    var imageResult: ImageResult?
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    // Call this to configure view
    func configureCell() {
        // Set view's appearance
        self.layer.shadowOffset = CGSize(width: 0.5, height: 3.0)
        self.layer.shadowColor = textFieldShadowColor.cgColor
        self.layer.shadowOpacity = 0.8
        
        // Download the image at the url and assign it to the imageview
        HTTPServices.instance.downloadImageTask(imageURL: imageResult?.thumbnailURL) {[weak self] (image, success) in
            if let strongSelf = self{
                if success{
                    DispatchQueue.main.async {
                        strongSelf.imageResult?.thumbnailImage = image
                        strongSelf.resultImageView.image = image
                        strongSelf.resultImageView.alpha = 0
                        // Tiny animation to provide a fade in animation. Can be noticed if the result set is big and when scrolling. 
                        UIView.animate(withDuration: 0.5, animations: {
                            strongSelf.resultImageView.alpha = 1.0
                        })
                    }
                    
                }
            }
            
        }
    }
}
