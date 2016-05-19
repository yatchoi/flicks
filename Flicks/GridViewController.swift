//
//  GridViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit

class GridViewController: UIViewController, UICollectionViewDataSource {
  
  @IBOutlet weak var collectionView: UICollectionView!
  
  var movies: [NSDictionary]!
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    collectionView.dataSource = self
  }
  
  func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return movies?.count ?? 0
  }

  func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
    let cell = collectionView.dequeueReusableCellWithReuseIdentifier("movieGridCell", forIndexPath: indexPath) as? MovieGridViewCell
    
    let movie = movies[indexPath.row]
    
    if let posterPath = movie["poster_path"] as? String {
      let posterFullURL = NSURL(string: MovieModel.BaseImagePath + posterPath)!
      cell?.setImageFromUrl(posterFullURL)
    }
    else {
      cell?.gridImage.image = nil
    }
    
    return cell!
  }
  
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
    if (segue.identifier == "movieDetailsSegue") {
      let destinationVC = segue.destinationViewController as! MovieDetailsViewController
      
      guard let sourceCell = sender as? UICollectionViewCell else {
        return
      }
      
      guard let indexPath = collectionView.indexPathForCell(sourceCell) else {
        return
      }
      
      destinationVC.movieData = movies[indexPath.row]
    }
  }
}

