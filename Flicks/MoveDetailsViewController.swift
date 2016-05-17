//
//  MoveDetailsViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/17/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit

class MovieDetailsViewController: UIViewController {
  var movieData: NSDictionary!
  
  @IBOutlet weak var backgroundImage: UIImageView!
  
  @IBOutlet weak var movieTitle: UILabel!
  @IBOutlet weak var overviewText: UILabel!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    initializeBackgroundImage()
    initializeText()
  }
  
  func initializeBackgroundImage() {
    if let posterPath = movieData["backdrop_path"] as? String {
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
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
  }
}