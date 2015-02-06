//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Jeremy Hageman on 2/2/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    
    var moviesArray: NSArray?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        let YourApiKey = "6zr49gek9an5ymg5tdh3ac67"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            var errorValue: NSError? = nil
            let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
            self.moviesArray = dictionary["movies"] as? NSArray
            self.tableView.reloadData()
        })
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = moviesArray {
            return array.count
        } else {
            return 0
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = self.moviesArray![indexPath.row] as NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier("com.codepath.mycell") as MovieTableViewCell
        cell.movieTitleLabel.text = movie["title"] as NSString
        cell.movieDescriptionLabel.text = movie["synopsis"] as NSString
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["original"] as NSString
        cell.posterThumb.setImageWithURL(NSURL(string: posterUrl))
        return cell
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        let details = MovieDetailsViewController()
        let movie = self.moviesArray![indexPath.row] as NSDictionary
        details.movieDictionary = movie
        self.navigationController?.pushViewController(details, animated: true)
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "showMovieDetialControllerSegue" {
            let cell = sender as UITableViewCell
            if let indexPath = tableView.indexPathForCell(cell) {
                let movieDetailsController = segue.destinationViewController as MovieDetailsViewController
                movieDetailsController.movieDictionary = self.moviesArray![indexPath.row] as? NSDictionary
                tableView.deselectRowAtIndexPath(indexPath, animated: true)
            }
        }
    }
}

