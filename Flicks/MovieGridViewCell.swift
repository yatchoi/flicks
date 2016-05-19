//
//  MovieGridViewCell
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import AlamofireImage

class MovieGridViewCell: UICollectionViewCell {
  
  @IBOutlet weak var gridImage: UIImageView!
  
  func setImageFromUrl(url: NSURL) {
    gridImage.af_setImageWithURL(url)
  }
}
