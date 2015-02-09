//
//  ViewController.swift
//  Rotten Tomatoes
//
//  Created by Jeremy Hageman on 2/2/15.
//  Copyright (c) 2015 CodePath. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UICollectionViewDataSource {
    

    @IBOutlet weak var errorView: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var viewStyleSegment: UISegmentedControl!
    @IBOutlet weak var movieTitleLable: UILabel!

    var refreshControl: UIRefreshControl!
    
    var moviesArray: NSArray?
    
    let CellId = "com.codepath.mycell"
    let CollectionId = "com.codepath.mycollection"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.hidden = true
        tableView.dataSource = self
        tableView.estimatedRowHeight = 100
        
        collectionView.dataSource = self
        collectionView.hidden = false
        
        viewStyleSegment.sizeToFit()
        
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: "fetchMovies", forControlEvents: UIControlEvents.ValueChanged)
        
        let dummyTableVC = UITableViewController()
        dummyTableVC.tableView = tableView
        dummyTableVC.refreshControl = refreshControl
        
        fetchMovies()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        errorView.hidden = true
    }
    
    func fetchMovies() {
        self.errorView.hidden = true
        MBProgressHUD.showHUDAddedTo(self.view, animated: true)
        
        let YourApiKey = "6zr49gek9an5ymg5tdh3ac67"
        let RottenTomatoesURLString = "http://api.rottentomatoes.com/api/public/v1.0/lists/dvds/top_rentals.json?apikey=" + YourApiKey
        let request = NSMutableURLRequest(URL: NSURL(string: RottenTomatoesURLString)!)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue(), completionHandler:{ (response, data, error) in
            println("response: \(response)")
            MBProgressHUD.hideHUDForView(self.view, animated: true)
            var errorValue: NSError? = error
            if errorValue != nil {
                println("data: \(error)")
                self.errorView.hidden = false
            } else if (data.length > 0)  {
                self.errorView.hidden = true
                let dictionary = NSJSONSerialization.JSONObjectWithData(data, options: nil, error: &errorValue) as NSDictionary
                self.moviesArray = dictionary["movies"] as? NSArray
                self.collectionView.reloadData()
                self.tableView?.reloadData()
                self.refreshControl.endRefreshing()
            }
        })
    }
    
    @IBAction func changeContentView(sender: AnyObject) {
        
        if viewStyleSegment.selectedSegmentIndex == 0 {
            tableView.hidden = true
            collectionView.hidden = false
        } else {
            tableView.hidden = false
            collectionView.hidden = true
        }
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let array = moviesArray {
            return array.count
        } else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let array = moviesArray {
            return array.count
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let movie = self.moviesArray![indexPath.row] as NSDictionary
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(CollectionId, forIndexPath: indexPath) as MovieCollectionViewCell
        cell.movieTitleLabel.text = movie["title"] as NSString
        let ratings = movie["ratings"] as NSDictionary
        let criticsScore = ratings["critics_score"] as Int
        cell.ratingLabel.text = "\(String(criticsScore))%"
        
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["original"] as NSString
        let urlRequest = NSURLRequest(URL: NSURL(string: posterUrl)!)
        let placeholder = UIImage(named: "no_photo")
        
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            cell.posterImage.image = image;
            cell.posterImage.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                cell.posterImage.alpha = 1.0
            })
            let fullSizeImageUrl = posterUrl.stringByReplacingOccurrencesOfString("_tmb.jpg", withString: "_ori.jpg")
            cell.posterImage.setImageWithURL(NSURL(string: fullSizeImageUrl))
        }
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        
        cell.posterImage.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: imageRequestSuccess, failure: imageRequestFailure)
        
        return cell
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let movie = self.moviesArray![indexPath.row] as NSDictionary
        let cell = tableView.dequeueReusableCellWithIdentifier(CellId, forIndexPath: indexPath) as MovieTableViewCell
        cell.movieTitleLabel.text = movie["title"] as NSString
        let posters = movie["posters"] as NSDictionary
        let posterUrl = posters["original"] as NSString
        let urlRequest = NSURLRequest(URL: NSURL(string: posterUrl)!)
        let placeholder = UIImage(named: "no_photo")
        
        let imageRequestSuccess = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, image : UIImage!) -> Void in
            cell.posterThumb.image = image;
            cell.posterThumb.alpha = 0
            UIView.animateWithDuration(0.5, animations: {
                cell.posterThumb.alpha = 1.0
            })
        }
        let imageRequestFailure = {
            (request : NSURLRequest!, response : NSHTTPURLResponse!, error : NSError!) -> Void in
            NSLog("imageRequrestFailure")
        }
        
        cell.posterThumb.setImageWithURLRequest(urlRequest, placeholderImage: placeholder, success: imageRequestSuccess, failure: imageRequestFailure)
        
        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let details = MovieDetailsViewController()
        let movie = self.moviesArray![indexPath.row] as NSDictionary
        details.movieDictionary = movie
        self.navigationController?.pushViewController(details, animated: true)
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
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
        } else if segue.identifier == "showMovieDetialControllerSegueFromCollection" {
            let cell = sender as UICollectionViewCell
            if let indexPath = collectionView.indexPathForCell(cell) {
                let movieDetailsController = segue.destinationViewController as MovieDetailsViewController
                movieDetailsController.movieDictionary = self.moviesArray![indexPath.row] as? NSDictionary
                collectionView.deselectItemAtIndexPath(indexPath, animated: true)
            }
        }
    }
}

