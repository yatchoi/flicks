//
//  MoveDetailsViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/17/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import XCDYouTubeKit

class MovieDetailsViewController: UIViewController, HasMovieData {
  var movieData: NSDictionary!
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var overviewText: UILabel!
  @IBOutlet weak var releasedLabel: UILabel!
  @IBOutlet weak var durationLabel: UILabel!
  
  static let MovieURL = "https://api.themoviedb.org/3/movie/"
  
  var videoKey: String?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initializeBackgroundImage()
    initializeText()
    
    let contentWidth = contentView.bounds.width
    let contentHeight = contentView.bounds.height
    scrollView.contentSize = CGSizeMake(contentWidth, contentHeight + 300)
    
    let frame = CGRectMake(0, 300, contentWidth, contentHeight)
    let subview = UIView(frame: frame)
    subview.addSubview(contentView)
    scrollView.addSubview(subview)
    
    getFullMovieData()
    getVideoURL()
  }
  
  func initializeBackgroundImage() {
    if let posterPath = movieData["poster_path"] as? String {
      let posterFullURL = NSURL(string: MovieModel.BaseImagePath + posterPath)!
      backgroundImage.af_setImageWithURL(posterFullURL)
    }
    else {
      backgroundImage.image = nil
    }
  }
  
  func initializeText() {
    if let titleString = movieData["title"] as? String {
      movieTitle.text = titleString
    }
    
    if let overviewString = movieData["overview"] as? String {
      overviewText.text = overviewString
      overviewText.sizeToFit()
    }
  }
  
  @IBAction func playTrailerTapped(sender: AnyObject) {
    if (videoKey != nil) {
      self.playYoutubeVideo(videoKey!)
    }
  }
  
  func getFullMovieData() {
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let movieId = String(movieData["id"]!)
    
    let url = NSURL(string: MovieDetailsViewController.MovieURL + movieId + "?api_key=" + apiKey)
    
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
    
    // Make call
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
      guard let data = dataOrNil else {
        return
      }
      
      guard error == nil else {
        return
      }
      
      if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
        data, options:[]) as? NSDictionary {
        if let results = responseDictionary as? NSDictionary {
          self.movieData = results
          self.updateMovieDataUI()
        }
      }
    })
    task.resume()
  }
  
  func getVideoURL() {
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    let movieId = String(movieData["id"]!)
    
    let url = NSURL(string: MovieDetailsViewController.MovieURL + movieId + "/videos?api_key=" + apiKey)
    
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
    
    // Make call
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
      guard let data = dataOrNil else {
        return
      }
      
      guard error == nil else {
        return
      }
      
      if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
        data, options:[]) as? NSDictionary {
        if let results = responseDictionary["results"] as? [NSDictionary] {
          self.videoKey = results[0]["key"] as? String
        }
      }
    })
    task.resume()
  }
  
  func updateMovieDataUI() {
    if let releaseDate = movieData["release_date"] as? String {
      releasedLabel.text = "Released: \(releaseDate)"
    }
    if let duration = movieData["runtime"] as? Int {
      durationLabel.text = "Duration: \(getRunTimeHours(duration)) hours \(getRunTimeMinutes(duration)) minutes"
    }
  }
  
  func getRunTimeHours(duration: Int) -> Int {
    return duration / 60
  }
  
  func getRunTimeMinutes(duration: Int) -> Int {
    return duration % 60
  }
  
  func playYoutubeVideo(videoKey: String) {
    let playerVC = XCDYouTubeVideoPlayerViewController(videoIdentifier: videoKey)
    self.presentMoviePlayerViewControllerAnimated(playerVC)
//    var url = NSURL(string:"youtube://" + videoKey)!
//    if UIApplication.sharedApplication().canOpenURL(url)  {
//      UIApplication.sharedApplication().openURL(url)
//    } else {
//      url = NSURL(string:"http://www.youtube.com/watch?v=" + videoKey)!
//      UIApplication.sharedApplication().openURL(url)
//    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setMovieDataObject(movieData: NSDictionary) {
    self.movieData = movieData
  }

}