//
//  FullImageView.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/26/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import UIKit
import Foundation

class FullImageView: UIView {

    // Full Size ImageView
    @IBOutlet weak var fullImageView: UIImageView!
    // UIView containing Save and Done options
    @IBOutlet weak var actionsView: UIView!
    // Save Success/Failure Message View
    @IBOutlet weak var messageView: UIView!
    // Save Success/Failure Message Label
    @IBOutlet weak var messageLabel: UILabel!
    
    // current status of messageView's is hidden property
    var hideActionsView: Bool = false
    
    // Single image result record
    var imageResult: ImageResult?
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // Call this to configure view
    func configureView(){
        // Initialize a tap gesture recognizer
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(imageTapped(gesture:)))
        // Add it to the image view
        self.fullImageView.addGestureRecognizer(tapGesture)
        // Enable user interaction to the image view.
        self.fullImageView.isUserInteractionEnabled = true
        // Assign the image to be displayed in the image view
        self.fullImageView.image = imageResult?.thumbnailImage
        // Set initial backgroundColor
        self.backgroundColor = UIColor.white
    }
    
    // Gesture Recognizer action method
    func imageTapped(gesture: UITapGestureRecognizer) {
        //Debug print statement
        print("Image Tapped")
        // Toggle the to-hide bool variable
        hideActionsView = !hideActionsView
        // Hide/unhide the actions view
        self.actionsView.isHidden = hideActionsView
        // Toggle full screen mode with tiny animations
        if hideActionsView{
            UIView.animate(withDuration: 0.4, animations: {
                self.backgroundColor = UIColor.black
            })
        }else{
            UIView.animate(withDuration: 0.3, animations: {
                self.backgroundColor = UIColor.white
            })
            
        }
        
    }
    
    // Done tapped action -> dismiss view
    @IBAction func doneTapped(_ sender: UIButton) {
        // Remove full screen image from the superview
        UIView.animate(withDuration: 0.5, animations: { 
            self.alpha = 0
            }) { (success) in
                self.removeFromSuperview()
        }
        
        
    }
    
    // Save tapped action -> Save to Photos app
    @IBAction func saveTapped(_ sender: UIButton) {
        //Debug print statement
        print("Image Save Tapped")
        // Ensure image exists
        if imageResult?.thumbnailImage != nil{
            // Attempt to save the image
            CustomPhotoAlbumServices.sharedInstance.saveImage(image: (imageResult?.thumbnailImage)!, completionHandler: { [weak self](success) in
                if let strongSelf = self{
                    var msg = ""
                    // Set message based of attempt
                    if success{
                        msg = imageSaveSuccessMessage
                    }else{
                        msg = imageSaveFailureMessage
                    }
                    // Show and hide the message for a short span.
                    DispatchQueue.main.async {
                        strongSelf.messageLabel.text = msg
                        strongSelf.messageView.isHidden = false
                        strongSelf.messageView.alpha = 0
                        UIView.animate(withDuration: 1.0, animations: {
                            strongSelf.messageView.alpha = 1.0
                            }, completion: { (success) in
                                UIView.animate(withDuration: 0.5, animations: {
                                    strongSelf.messageView.alpha = 0
                                    }, completion: { (success) in
                                        strongSelf.messageView.isHidden = true
                                })
                        })
                    }
                }
                
            })
            //Debug print statement
            print("Image not nil while saving")
        }
        //Debug print statement
        print("Image Save Attempt Finished")
    }

}
