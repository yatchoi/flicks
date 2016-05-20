//
//  MoveDetailsViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/17/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import MediaPlayer
import AVKit
import AVFoundation
import YouTubePlayer

class MovieDetailsViewController: UIViewController, HasMovieData {
  var movieData: NSDictionary!
  
  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var overviewText: UILabel!
  
  static let MovieURL = "https://api.themoviedb.org/3/movie/"
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initializeBackgroundImage()
    initializeText()
    
    let contentWidth = contentView.bounds.width
    let contentHeight = contentView.bounds.height
    scrollView.contentSize = CGSizeMake(contentWidth, contentHeight + 350)
    
    let frame = CGRectMake(0, 350, contentWidth, contentHeight)
    let subview = UIView(frame: frame)
    subview.addSubview(contentView)
    scrollView.addSubview(subview)
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
    getVideoURL()
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
          let videoKey = results[0]["key"] as? String
          self.playYoutubeVideo(videoKey!)
        }
      }
    })
    task.resume()
  }
  
  func playYoutubeVideo(videoKey: String) {
    var url = NSURL(string:"youtube://" + videoKey)!
    if UIApplication.sharedApplication().canOpenURL(url)  {
      UIApplication.sharedApplication().openURL(url)
    } else {
      url = NSURL(string:"http://www.youtube.com/watch?v=" + videoKey)!
      UIApplication.sharedApplication().openURL(url)
    }
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
  
  func setMovieDataObject(movieData: NSDictionary) {
    self.movieData = movieData
  }

}