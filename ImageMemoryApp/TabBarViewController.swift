//
//  TabBarViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/02.
//

import UIKit

class TabBarController: UITabBarController {
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let viewController1 = ViewControllerFactory.createImageViewController()
   //     let navigationController1 = UINavigationController(rootViewController: viewController1)
  //      navigationController1.tabBarItem = UITabBarItem(tabBarSystemItem: .favorites, tag: 0)
        
        let viewController2 = ViewControllerFactory.selectImageViewController()
    //    let navigationController2 = UINavigationController(rootViewController: viewController2)
   //     navigationController2.tabBarItem = UITabBarItem(tabBarSystemItem: .history, tag: 1)
        
        viewControllers = [viewController1, viewController2]
    }
}
