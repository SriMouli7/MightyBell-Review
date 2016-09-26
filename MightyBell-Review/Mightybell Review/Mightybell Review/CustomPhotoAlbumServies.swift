//
//  CustomPhotoLibraryServies.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/25/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import UIKit
import Photos


// Singleton to funnel all the Photos Library calls
class CustomPhotoAlbumServices {
    
    // Singleton instance
    static let sharedInstance = CustomPhotoAlbumServices()
    
    // Custom album name to be created in the Photos app
    static let albumName = "ImageFinder"
    
    // Reference to the custom album (PHPhotoAssetCollection)
    var assetCollection: PHAssetCollection!
    
    // restrict the creation of other instances
    private init() {}
    
    // closure that takes in parameters and attempts to save the image to the Photos app'
    let saveImageClosure:(PHAssetCollection,UIImage, (@escaping (Bool)->Void)) -> Void = { arg1, arg2, arg3 in
        PHPhotoLibrary.shared().performChanges({
            // Save the image to the custom album
            let assetChangeRequest = PHAssetChangeRequest.creationRequestForAsset(from: arg2)
            let assetPlaceholder = assetChangeRequest.placeholderForCreatedAsset
            var assetPlaceholderArray = Array<PHObjectPlaceholder>()
            assetPlaceholderArray.append(assetPlaceholder!)
            if let albumChangeRequest = PHAssetCollectionChangeRequest(for: arg1) {
                albumChangeRequest.addAssets(assetPlaceholderArray as NSFastEnumeration)
            }
            }, completionHandler: { (success, error) in
                
                // Closure for displaying the success/failure message
                arg3(success)
                
                
                if success{
                    // Debug print statement
                    print("Saved To Photos")
                }else{
                    // Debug print statement
                    print("Save Failed")
                }
                
        })
    }
    
    // Method to fetch reference to the custom album created by this app in the Photos app
    func fetchAssetCollectionForAlbum() -> PHAssetCollection! {
        
        let fetchOptions = PHFetchOptions()
        fetchOptions.predicate = NSPredicate(format: "title = %@", CustomPhotoAlbumServices.albumName)
        let collectionResults = PHAssetCollection.fetchAssetCollections(with: .album, subtype: .any, options: fetchOptions)
        
        if collectionResults.firstObject != nil {
            return collectionResults.firstObject
        }
        return nil
    }

    // Interfacing save image method.
    // Takes in a closure as parameter that Displays success/failure of the image save attempt message
    func saveImage(image: UIImage, completionHandler: @escaping (_ succes: Bool) -> Void) {
        
        if assetCollection == nil {
            // If the custom album idoes not exist, create the album.
            PHPhotoLibrary.shared().performChanges({
                PHAssetCollectionChangeRequest.creationRequestForAssetCollection(withTitle: CustomPhotoAlbumServices.albumName)
            }) { [unowned self] success, _ in
                if success {
                    // Save the reference to the custom album
                    self.assetCollection = self.fetchAssetCollectionForAlbum()
                    // Call the save closure
                    self.saveImageClosure(self.assetCollection, image, completionHandler)
                }
            }
        }else{
            // If album already exists, call the save closure.
            self.saveImageClosure(self.assetCollection, image, completionHandler)
        }
        
        
    }
    
    
}
