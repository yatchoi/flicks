//
//  ViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource {

  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var errorView: UIView!
  
  var movies: [NSDictionary]!
  
  var loadTopRated = false
  
  static let NowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key="
  static let TopRatedURL = "https://api.themoviedb.org/3/movie/top_rated?api_key="
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.dataSource = self
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "makeMovieRequest:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
    makeMovieRequest(refreshControl)
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func makeMovieRequest(refreshControl: UIRefreshControl) {
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var baseApiUrl: String
    
    if (loadTopRated) {
      baseApiUrl = ViewController.TopRatedURL
    } else {
      baseApiUrl = ViewController.NowPlayingURL
    }
    
    let url = NSURL(string: baseApiUrl + apiKey)
    
    // Build request
    let request = NSURLRequest(
      URL: url!,
      cachePolicy: NSURLRequestCachePolicy.ReloadIgnoringLocalCacheData,
      timeoutInterval: 10)
    
    // Build session
    let session = NSURLSession(
      configuration: NSURLSessionConfiguration.defaultSessionConfiguration(),
      delegate: nil,
      delegateQueue: NSOperationQueue.mainQueue()
    )
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    // Make call
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      
      guard let data = dataOrNil else {
        self.errorView.hidden = false
        refreshControl.endRefreshing()
        return
      }
      
      guard error == nil else {
        self.errorView.hidden = false
        refreshControl.endRefreshing()
        return
      }
      
      self.errorView.hidden = true
      
      if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
        data, options:[]) as? NSDictionary {
        if let results = responseDictionary["results"] as? [NSDictionary] {
          self.movies = results
          self.tableView.reloadData()
          refreshControl.endRefreshing()
        }
      }
    })
    task.resume()
  }
  
  func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }
  
  func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCellWithIdentifier("movieCell", forIndexPath: indexPath) as? MovieTableViewCell
    
    let movie = movies[indexPath.row]
    let movieName = movie["original_title"] as? String
    let movieSynopsis = movie["overview"] as? String
    
    if let posterPath = movie["poster_path"] as? String {
      let posterFullURL = NSURL(string: MovieModel.BaseImagePath + posterPath)!
      cell?.setImageFromUrl(posterFullURL)
    }
    else {
      cell?.movieImageView.image = nil
    }
    
    cell?.movieTitleLabel.text = movieName
    cell?.movieSynopsisLabel.text = movieSynopsis
    
    return cell!
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "movieDetailsSegue") {
      let destinationVC = segue.destinationViewController as! MovieDetailsViewController
      
      guard let sourceCell = sender as? UITableViewCell else {
        return
      }
      
      guard let indexPath = tableView.indexPathForCell(sourceCell) else {
        return
      }
      
      destinationVC.movieData = movies[indexPath.row]
    }
  }
}

