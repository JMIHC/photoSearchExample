//
//  ViewController.swift
//  photoSearchExample
//
//  Created by John Cornyn on 9/9/16.
//  Copyright © 2016 Johnny Cornyn. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UISearchBarDelegate {

    @IBOutlet weak var scrollView: UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        searchFlickrByHashtag("dogs")
        
    }
        func searchFlickrByHashtag(searchString:String) {
        let manager = AFHTTPSessionManager()
            
        let searchParameters = ["method": "flickr.photos.search",
                                "api_key": "a9428b4f9da5e201442ccd948032ca8a",
                                "format": "json",
                                "nojsoncallback": 1,
                                "text": searchString,
                                "extras": "url_m",
                                "per_page": 5]
        
        manager.GET("https://api.flickr.com/services/rest/?method=flickr.photos.search",
                    parameters: searchParameters,
                    progress: nil,
                    success: { (operation: NSURLSessionDataTask,responseObject: AnyObject?) in
                        if let responseObject = responseObject {
                            print("Response: " + responseObject.description)
                            
                            //let json = JSON(responseObject)
                            //if let scroll = json["photos"][3]["url_m"].string {
                            //}
                            
                            if let photos = responseObject["photos"] as? [String: AnyObject] {
                                if let photoArray = photos["photo"] as? [[String: AnyObject]] {
                                    let imageWidth = self.view.frame.width
                                    self.scrollView.contentSize = CGSizeMake(320, 320 * CGFloat(photoArray.count))
                                    for (i,photoDictionary) in photoArray.enumerate() {
                                        if let imageURLString = photoDictionary["url_m"] as? String {
                                                let imageView = UIImageView(frame: CGRectMake(0, imageWidth*CGFloat(i), imageWidth, imageWidth))
                                                if let url = NSURL(string: imageURLString) {
                                                    imageView.setImageWithURL(url)
                                                    self.scrollView.addSubview(imageView)
                                                }
                                            }
                                        }
                                    }
                                }
                        }
            },
                    failure: { (operation: NSURLSessionDataTask?,error: NSError) in
                        print("Error: " + error.localizedDescription)
        })
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func searchBarSearchButtonClicked(searchBar: UISearchBar) {
        for subview in self.scrollView.subviews {
            subview.removeFromSuperview()
        }
        searchBar.resignFirstResponder()
        if let searchText = searchBar.text {
            searchFlickrByHashtag(searchText)
        }
    }

}

