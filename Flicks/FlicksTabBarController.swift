//
//  FlicksTabBarController.swift
//  Flicks
//
//  Created by Yat Choi on 5/19/16.
//  Copyright © 2016 yatchoi. All rights reserved.
//

import UIKit

class FlicksTabBarController: UITabBarController, ListGridDelegate {
  func listGridPicker(didSelectIndex index:Int) {
    if self.viewControllers == nil {
      return
    }
    for vc in self.viewControllers! {
      let mainVC = vc.childViewControllers[0] as! MainViewController
      mainVC.viewSegmentedControl.selectedSegmentIndex = index
      mainVC.updateActiveViewControllerByIndex(index)
    }
  }
}
