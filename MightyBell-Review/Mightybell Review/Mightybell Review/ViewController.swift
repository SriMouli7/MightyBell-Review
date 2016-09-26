//
//  ViewController.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/24/16.
//  Copyright © 2016 Mightybell. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {

    // Textfield to take in the input for the search
    @IBOutlet weak var searchTextField: CustomTextField!
    // Collection view to display the results of the search
    @IBOutlet weak var resultsCollectionView: UICollectionView!
    // Label to display the message if no results obtained
    @IBOutlet weak var noResultsLabel: UILabel!
    // Activity indicator to give wait experience to the user
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    // Image result records array
    var imageResultsArray: [ImageResult]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set the delagates of the collection view and textfield to self
        self.searchTextField.delegate = self
        self.resultsCollectionView.delegate = self
        // Configure initial appearance of the view
        self.resultsCollectionView.backgroundColor = UIColor.clear
        self.activityIndicator.isHidden = true
        self.noResultsLabel.isHidden = true
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    //****************************** TEXTFIELD DELEGATE METHODS **********************************
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        dismissKeyboard()
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // When Search(return) pressed, dismiss the keyboard
        dismissKeyboard()
        
        if textField.text != nil && textField.text != ""{
            // If the query string is non nil and not empty, remove all the existing data from the collectionview if any and start animating the activity indicator
            self.imageResultsArray?.removeAll()
            self.imageResultsArray = nil
            self.resultsCollectionView.reloadData()
            activityIndicator.isHidden = false
            activityIndicator.startAnimating()
            
            // Fetch the results from the API using the query string
            fetchResults(queryString: textField.text)
        }
        return true
    }
    //****************************** TEXTFIELD DELEGATE METHODS **********************************
    
    
    //****************************** COLLECTION VIEW DELEGATE METHODS **********************************
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        if imageResultsArray != nil{
            return 1
        }
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.imageResultsArray != nil{
            // If results exist, then hide the no results lable
            self.noResultsLabel.isHidden = true
            return (self.imageResultsArray?.count)!
        }
        return 0
    }
    
    // Specify the size of each cell of the collectionview
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return collectionViewCellSizeDynamic
    }
    
    // Specify the minimum spacing between the cells
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewMinimumSpacing
    }
    
    // Specify the vertical spacing between the rows
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return collectionViewRowGap
    }
    
    // Configure each cell of the collection view
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: imageCollectionViewCellIdentifier, for: indexPath) as? ImageCollectionViewCell{
            
            // Pass in the image result record
            cell.imageResult = imageResultsArray?[indexPath.row]
            cell.configureCell()
            return cell
        }
        
        return UICollectionViewCell()
    }
    
    // When tapped on a cell, enlarge the image and provide options to save and dismiss
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        // Dismiss the keyboard if active
        dismissKeyboard()
        // load the full image view XIB file.
        if let fullImageView = Bundle.main.loadNibNamed("FullImageView", owner: self, options: nil)?[0] as? FullImageView{
            //Pass in the result image record
            fullImageView.imageResult = (imageResultsArray?[indexPath.row])!
            // Configure the view
            fullImageView.configureView()
            fullImageView.alpha = 0
            fullImageView.frame = self.view.frame
            self.view.window?.addSubview(fullImageView)
            // Animate the full image view
            UIView.animate(withDuration: 0.5) {
                fullImageView.alpha = 1.0
            }
        }
 
        
    }
    
    //****************************** COLLECTION VIEW DELEGATE METHODS **********************************

    // Call this method with a query string and it fetches the images associated with that string.
    func fetchResults(queryString: String?){
        // ensure the query string is non nil and not empty
        guard queryString != nil  && queryString != "" else {
            return
        }
        
        // Debug print statement to print the query string to the console
        print("Query String - \(queryString)")
        // Fetch the results from the API
        HTTPServices.instance.getImageURLs(queryString: queryString!) { [unowned self] (resultsArray, success) in
            // If success then reload the collectionview with the fetched results
            if success{
                self.imageResultsArray = resultsArray
                DispatchQueue.main.async {
                    self.noResultsLabel.isHidden = false
                    self.activityIndicator.isHidden = true
                    self.resultsCollectionView.reloadData()
                    self.activityIndicator.stopAnimating()
                    
                }
                // Else show no results label
            }else{
                DispatchQueue.main.async {
                    self.activityIndicator.isHidden = true
                    self.noResultsLabel.isHidden = false
                }
            }
            
        }
    }
    
    // Call this method to dismiss the keyboard
    func dismissKeyboard(){
        self.searchTextField.resignFirstResponder()
    }
}

