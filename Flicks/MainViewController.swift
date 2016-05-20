//
//  MainViewController.swift
//  Flicks
//
//  Created by Yat Choi on 5/17/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit
import MBProgressHUD

class MainViewController: UIViewController {

  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var viewSegmentedControl: UISegmentedControl!
  
  @IBOutlet weak var errorView: UIView!
  
  var tableViewController: UIViewController?
  var gridViewController: UIViewController?
  weak var listGridDelegate: ListGridDelegate?
  
  private var activeViewController: UIViewController? {
    didSet {
      removeInactiveViewController(oldValue)
      updateActiveViewController()
    }
  }
  
  var viewControllers: [UIViewController]?
  
  var movies: [NSDictionary]!
  
  var loadTopRated = false
  
  static let NowPlayingURL = "https://api.themoviedb.org/3/movie/now_playing?api_key="
  static let TopRatedURL = "https://api.themoviedb.org/3/movie/top_rated?api_key="
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    self.listGridDelegate = self.parentViewController?.parentViewController as! FlicksTabBarController
    updateActiveViewControllerByIndex(viewSegmentedControl.selectedSegmentIndex)
    makeMovieRequest(nil)
  }
  
  override func viewWillAppear(animated: Bool) {
    super.viewWillAppear(animated)
    updateActiveViewController()
  }
  
  private func removeInactiveViewController(inactiveViewController: UIViewController?) {
    if let inActiveVC = inactiveViewController {
      // call before removing child view controller's view from hierarchy
      inActiveVC.willMoveToParentViewController(nil)
      
      inActiveVC.view.removeFromSuperview()
      
      // call after removing child view controller's view from hierarchy
      inActiveVC.removeFromParentViewController()
    }
  }
  
  private func updateActiveViewController() {
    if !self.isViewLoaded() {
      return
    }
    if let activeVC = activeViewController {
      // call before adding child view controller's view as subview
      addChildViewController(activeVC)
      
      activeVC.view.frame = contentView.bounds
      contentView.addSubview(activeVC.view)
      
      // call before adding child view controller's view as subview
      activeVC.didMoveToParentViewController(self)
    }
  }
  
  func makeMovieRequest(refreshControl: UIRefreshControl?) {
    let apiKey = "a07e22bc18f5cb106bfe4cc1f83ad8ed"
    var baseApiUrl: String
    
    if (loadTopRated) {
      baseApiUrl = MainViewController.TopRatedURL
    } else {
      baseApiUrl = MainViewController.NowPlayingURL
    }
    
    let url = NSURL(string: baseApiUrl + apiKey)
    
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
    
    MBProgressHUD.showHUDAddedTo(self.view, animated: true)
    
    // Make call
    let task: NSURLSessionDataTask = session.dataTaskWithRequest(request, completionHandler: { (dataOrNil, response, error) in
      MBProgressHUD.hideHUDForView(self.view, animated: true)
      refreshControl?.endRefreshing()
      
      guard let data = dataOrNil else {
        self.listGridDelegate?.updateErrorHidden(false)
        return
      }
      
      guard error == nil else {
        self.listGridDelegate?.updateErrorHidden(false)
        return
      }
      
      self.listGridDelegate?.updateErrorHidden(true)
      
      if let responseDictionary = try! NSJSONSerialization.JSONObjectWithData(
        data, options:[]) as? NSDictionary {
        if let results = responseDictionary["results"] as? [NSDictionary] {
          self.movies = results
          self.reloadViewData()
        }
      }
    })
    task.resume()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  @IBAction func didValueChange(sender: AnyObject) {
    let index = viewSegmentedControl.selectedSegmentIndex
    self.updateActiveViewControllerByIndex(index)
    self.listGridDelegate?.listGridPicker(didSelectIndex: index)
  }
  
  func updateActiveViewControllerByIndex(index: Int) {
    if (index == 0) {
      activeViewController = tableViewController
    } else {
      activeViewController = gridViewController
    }
  }
  
  func reloadViewData() {
    let tableVC = tableViewController as! ViewController
    let gridVC = gridViewController as! GridViewController
    tableVC.movies = movies
    gridVC.movies = movies
    tableVC.tableView?.reloadData()
    gridVC.collectionView?.reloadData()
  }

  /*
  // MARK: - Navigation

  // In a storyboard-based application, you will often want to do a little preparation before navigation
  override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
      // Get the new view controller using segue.destinationViewController.
      // Pass the selected object to the new view controller.
  }
  */

}
