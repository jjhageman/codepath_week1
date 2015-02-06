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
    
    var movieDictionary: NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let movie = self.movieDictionary? {
            movieTitleLabel.text = movie["title"] as NSString
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
