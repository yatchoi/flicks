//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import AFNetworking

class MovieTableViewCell: UITableViewCell {

  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var movieSynopsisLabel: UILabel!
  @IBOutlet weak var movieImageView: UIImageView!
  
  func setImageFromUrl(url: NSURL) {
//    movieImageView.af_setImageWithURL(url)    
    let imageRequest = NSURLRequest(URL: url)
    
    self.movieImageView.setImageWithURLRequest(
      imageRequest,
      placeholderImage: nil,
      success: { (imageRequest, imageResponse, image) -> Void in
        
        // imageResponse will be nil if the image is cached
        if imageResponse != nil {
          print("Image was NOT cached, fade in image")
          self.movieImageView.alpha = 0.0
          self.movieImageView.image = image
          UIView.animateWithDuration(0.3, animations: { () -> Void in
            self.movieImageView.alpha = 1.0
          })
        } else {
          print("Image was cached so just update the image")
          self.movieImageView.image = image
        }
      },
      failure: { (imageRequest, imageResponse, error) -> Void in
        // do something for the failure condition
    })
  }
  
  
}
