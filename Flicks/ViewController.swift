//
//  ViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import MBProgressHUD

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

  @IBOutlet weak var tableView: UITableView!
  
  @IBOutlet weak var errorView: UIView!
  
  var movies: [NSDictionary]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.dataSource = self
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "triggerRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
  }
  
  func triggerRefresh(refreshControl: UIRefreshControl) {
    let mainVC = self.parentViewController as! MainViewController
    mainVC.makeMovieRequest(refreshControl)
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

