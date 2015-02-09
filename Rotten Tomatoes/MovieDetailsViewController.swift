//
//  MovieDetailsViewController.swift
//  Rotten Tomatoes
//
//  Created by Jeremy Hageman on 2/3/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
    
    @IBOutlet weak var movieTitleLabel: UILabel!
    @IBOutlet weak var synopsisLabel: UILabel!
    @IBOutlet weak var movieImage: UIImageView!
    @IBOutlet weak var ratingCircle: UIView!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    var movieDictionary: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ratingCircle.layer.cornerRadius = 40;

        if let movie = self.movieDictionary? {
            movieTitleLabel.text = movie["title"] as NSString
            
            let releaseYear = movie["year"] as Int
            let mpaaRating = movie["mpaa_rating"] as String
            yearLabel.text = String(releaseYear) + " | " + mpaaRating
            
            synopsisLabel.text = movie["synopsis"] as NSString
            
            let ratings = movie["ratings"] as NSDictionary
            let criticsScore = ratings["critics_score"] as Int
            ratingLabel.text = "\(String(criticsScore))%"
            
            let posters = movie["posters"] as NSDictionary
            let posterUrl = posters["original"] as NSString
            let urlRequest = NSURLRequest(URL: NSURL(string: posterUrl)!)
            
            let imageRequestSuccess = {
                (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
                self.movieImage.image = image;
                self.movieImage.alpha = 0
                UIView.animateWithDuration(0.5, animations: {
               self.movieImage.alpha = 1.0
                })
            }
            let imageRequestFailure = {
                (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
                NSLog("imageRequrestFailure")
            }
            
            movieImage.setImageWithURLRequest(urlRequest, placeholderImage: nil, success: imageRequestSuccess, failure: imageRequestFailure)
            let fullSizeImageUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg")
            movieImage.setImageWithURL(NSURL(string: fullSizeImageUrl))
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
