//
//  MovieTableViewCell.swift
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieTableViewCell: UITableViewCell {

  @IBOutlet weak var movieTitleLabel: UILabel!
  @IBOutlet weak var movieSynopsisLabel: UILabel!
  @IBOutlet weak var movieImageView: UIImageView!
  
  func setImageFromUrl(url: NSURL) {
    movieImageView.af_setImageWithURL(url)
  }
}
