//
//  HTTPServices.swift
//  Mightybell Review
//
//  Created by Sri Mouli Puttege on 9/16/16.
//  Copyright © 2016 Orange Matrix. All rights reserved.
//

import Foundation
import UIKit


// List of required item keys in the data obtained from request call
struct APIResultKeys {
    static let Images = "images"
    static let ThumbnailImage = "thumbnailUrl"
    static let Value = "value"
    static let FullSizeImageURL = "contentUrl"
}


// Singleton to funnel all the network calls
class HTTPServices{
    
    // Singleton instance
    static let instance = HTTPServices()
    
    // API Key and base url
    private let apiKey = "1d332bbf0ac946499cecb087a23073e3"
    private let baseURLString = "https://api.cognitive.microsoft.com/bing/v5.0/search"
    
    // Restrict creation of objects
    private init(){}
    
    // Get instance of NSURLSession
    let session = URLSession.shared
    
    
    // Pass in the image search query string to fetch the search results
    // Takes in a closure as parameter providing the results obtained from the data task.
    func getImageURLs(queryString: String, completionHandler: @escaping (_ resultsArray: Array<ImageResult>?, _ success: Bool) -> Void){
        
        // Form the URL from Components
        let components = NSURLComponents(string: baseURLString)
        var queryItems = [URLQueryItem]()
        
        // Specify parameters
        let queryStringURLEncoded = queryString.replacingOccurrences(of: " ", with: "+")
        queryItems.append(URLQueryItem(name: "q", value: queryStringURLEncoded))
        
        
        components?.queryItems = queryItems
        
        // Create a URL Request object
        let request = NSMutableURLRequest(url: (components?.url!)!)
        // Set the HTTP method
        request.httpMethod = "GET"
        // Set the API key in the header of the request
        request.setValue(apiKey, forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
        
        // Create a data task to download the image search results
        let task = session.dataTask(with: request as URLRequest) { (data, response, error) in
            
            // Ensure there is no error and the httpresponsecode is Success
            guard error == nil  && (response as? HTTPURLResponse)!.statusCode == 200 else {
                completionHandler(nil, false)
                return
            }
            
            
            // Debug - Print to console
            print(response.debugDescription)
            
            // Debug print statement
            print("START JSON")
            do{
                // Serialize the data downloaded to JSON format
                let x = try JSONSerialization.jsonObject(with: data!, options: .allowFragments) as? [String: AnyObject]
                print(x!)
                print("FINISH JSON")
                if let results = x![APIResultKeys.Images] as? [String:AnyObject]{
                    print("RESULTS - \(results)")
                    if let imageResults = results[APIResultKeys.Value] as? [AnyObject]{
                        var imageURLs = [String]()
                        var imageResultsArray = [ImageResult]()
                        for result in imageResults{
                            if let singleResult = result as? [String: AnyObject]{
                                // Retrieve the data required from the response data
                                let thumbnailImage = singleResult[APIResultKeys.ThumbnailImage] as? String
                                if thumbnailImage != nil{
                                    imageURLs.append(thumbnailImage!)
                                    
                                }
                                let fullSizeImageURL = singleResult[APIResultKeys.FullSizeImageURL] as? String
                                
                                if thumbnailImage != nil && (fullSizeImageURL != nil){
                                    // Form an image result record
                                    let imageResult = ImageResult(thumbURL: thumbnailImage!, fullURL: fullSizeImageURL!)
                                    // Append it to the result image records array
                                    imageResultsArray.append(imageResult)
                                }
                                // Debug - Print image URLs
                                print(thumbnailImage)
                            }
                        }
                        completionHandler(imageResultsArray, true)
                    }else{
                        completionHandler(nil, false)
                    }
                }else{
                    completionHandler(nil, false)
                }
            }catch{
                completionHandler(nil, false)
            }
        }
        
        task.resume()
    }
    
    
    
    // Pass in the url of the image and download the data.
    // Takes in a closure as parameter providing the results obtained from the data task.
    func downloadImageTask(imageURL: String?, completionHandler: @escaping (_ image: UIImage?, _ success: Bool) -> Void){
        // Check if image url exists
        if imageURL == nil{
            completionHandler(nil, false)
            return
        }
        
        // Form the URL
        guard let imageURL = URL(string: imageURL!) else{
            completionHandler(nil, false)
            return
        }
        
        // Debug - Print Image URL to the console.
        print("Image URL- \(imageURL)")
        let dataTask = session.dataTask(with: imageURL) { (data, response, error) in
            // Ensure there is no error and daat exists
            guard error == nil && data != nil else {
                completionHandler(nil, false)
                return
            }
            // Pass in the image to the colosure
            if let image = UIImage(data: data!){
                completionHandler(image, true)
            }else{
                completionHandler(nil, false)
            }
        }
        dataTask.resume()
        
    }
    
}
