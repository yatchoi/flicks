//
//  AppDelegate.swift
//  Flicks
//
//  Created by Yat Choi on 5/16/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

  var window: UIWindow?


  func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
    window = UIWindow(frame: UIScreen.mainScreen().bounds)
    let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
    
    let tableViewControllerForNowPlaying = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController")
    let gridViewControllerForNowPlaying = mainStoryboard.instantiateViewControllerWithIdentifier("GridViewController")
    
    let tableViewControllerForTopRated = mainStoryboard.instantiateViewControllerWithIdentifier("ViewController")
    let gridViewControllerForTopRated = mainStoryboard.instantiateViewControllerWithIdentifier("GridViewController")
    
    let nowPlayingNavController = mainStoryboard.instantiateViewControllerWithIdentifier("MainNavController")
    nowPlayingNavController.tabBarItem.title = "Now Playing"
    nowPlayingNavController.tabBarItem.image = UIImage(named: "NowPlaying")
    
    let topRatedNavController = mainStoryboard.instantiateViewControllerWithIdentifier("MainNavController")
    topRatedNavController.tabBarItem.title = "Top Rated"
    topRatedNavController.tabBarItem.image = UIImage(named: "TopRated")

    let nowPlayingViewController = nowPlayingNavController.childViewControllers[0] as! MainViewController
    nowPlayingViewController.tableViewController = tableViewControllerForNowPlaying
    nowPlayingViewController.gridViewController = gridViewControllerForNowPlaying
    
    let topRatedViewController = topRatedNavController.childViewControllers[0] as! MainViewController
    topRatedViewController.tableViewController = tableViewControllerForTopRated
    topRatedViewController.gridViewController = gridViewControllerForTopRated
    topRatedViewController.loadTopRated = true
    
    let tabBarController = FlicksTabBarController()
    tabBarController.viewControllers = [nowPlayingNavController, topRatedNavController]
    
    window?.rootViewController = tabBarController
    window?.makeKeyAndVisible()

    return true
  }

  func applicationWillResignActive(application: UIApplication) {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
  }

  func applicationDidEnterBackground(application: UIApplication) {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
  }

  func applicationWillEnterForeground(application: UIApplication) {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
  }

  func applicationDidBecomeActive(application: UIApplication) {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
  }

  func applicationWillTerminate(application: UIApplication) {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
  }


}

