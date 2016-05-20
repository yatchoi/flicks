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
  
  var movies: [NSDictionary]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
    tableView.dataSource = self
    tableView.delegate = self
    
    let refreshControl = UIRefreshControl()
    refreshControl.addTarget(self, action: "triggerRefresh:", forControlEvents: UIControlEvents.ValueChanged)
    tableView.insertSubview(refreshControl, atIndex: 0)
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableView.contentInset = UIEdgeInsetsZero
    tableView.scrollIndicatorInsets = UIEdgeInsetsZero
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
    
    let backgroundView = UIView()
    backgroundView.backgroundColor = UIColor(red: 200, green: 0, blue: 90, alpha: 1)
    cell?.selectedBackgroundView = backgroundView
    
    var tapGestureRecognizer = UITapGestureRecognizer(target: self, action: "onPosterTap:")
    
    cell?.movieImageView.userInteractionEnabled = true
    cell?.movieImageView.addGestureRecognizer(tapGestureRecognizer)
    
    return cell!
  }
  
  func onPosterTap(sender: UITapGestureRecognizer) {
    print("poster tapped")
    
    guard let cell = sender.view?.superview?.superview as? MovieTableViewCell else {
      return
    }
    
    guard let indexPath = tableView.indexPathForCell(cell) else {
      return
    }
    
    performSegueWithIdentifier("fullScreenSegue", sender: cell)
  }
  
  func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
    tableView.deselectRowAtIndexPath(indexPath, animated: false)
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    var destinationVC: HasMovieData?
    if (segue.identifier == "movieDetailsSegue") {
      destinationVC = segue.destinationViewController as! MovieDetailsViewController
    } else if (segue.identifier == "fullScreenSegue") {
      destinationVC = segue.destinationViewController as! FullPosterViewController
    }
    
    guard let sourceCell = sender as? UITableViewCell else {
      return
    }
    
    guard let indexPath = tableView.indexPathForCell(sourceCell) else {
      return
    }
    
    destinationVC?.setMovieDataObject(movies[indexPath.row])
  }
}

