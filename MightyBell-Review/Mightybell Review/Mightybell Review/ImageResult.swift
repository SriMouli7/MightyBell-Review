//
//  ImageResult.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/25/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import Foundation
import UIKit


// Single image result record
class ImageResult {
    
    // Private variable to hold the thumbnail image url
    private var _thumbnailURL: String
    // Private variable to hold the full size image url. Can be used to download a high resolution imagefor full image view and/or to save to photos app.( Not used anywhere in the app)
    private var _fullSizeImageURL: String
    
    // Thumbnail image url getter
    var thumbnailURL : String{
        return _thumbnailURL
    }
    // Full size image url getter
    var fullSizeImageURL: String{
        return _fullSizeImageURL
    }
    // The images
    var thumbnailImage: UIImage?
    var actualImage: UIImage?
    
    // Initializer
    required init(thumbURL: String, fullURL: String) {
        self._thumbnailURL = thumbURL
        self._fullSizeImageURL = fullURL
    }
    
}
