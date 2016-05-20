//
//  FullPosterViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/19/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit

class FullPosterViewController: UIViewController, HasMovieData, UIScrollViewDelegate {
  var movieData: NSDictionary!

  @IBOutlet weak var backgroundImage: UIImageView!
  @IBOutlet weak var scrollView: UIScrollView!
  
  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
    initializeBackgroundImage()
    scrollView.delegate = self
  }
  
  func setMovieDataObject(movieData: NSDictionary) {
    self.movieData = movieData
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
  
  func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
    return backgroundImage
  }

  @IBAction func imageDoubleTapped(sender: UITapGestureRecognizer) {
    scrollView.zoomScale = 1.0
  }
  
  @IBAction func fullScreenImageSwiped(sender: UISwipeGestureRecognizer) {
    if (sender.direction == UISwipeGestureRecognizerDirection.Right) || (sender.direction == UISwipeGestureRecognizerDirection.Left) {
      self.dismissViewControllerAnimated(true, completion: {});
    }
  }
}
