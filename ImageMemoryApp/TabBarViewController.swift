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
        
        // ナビゲーションバー
        //        navigationBar.tintColor = UIColor.white
        //        navigationBar.barTintColor = UIColor.red
        //        navigationBar.isTranslucent = false
        //        navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor : UIColor.white]
        
        // タブバーコントローラー
        tabBar.tintColor = UIColor(named: "gold")
        tabBar.unselectedItemTintColor = UIColor.gray
        tabBar.barTintColor = UIColor.purple
        tabBar.isTranslucent = false
        
        // ダークモード時の設定
        if #available(iOS 13.0, *) {
            let appearance = UITabBarAppearance()
            appearance.backgroundColor = UIColor.black // ダークモードの背景色を設定
            tabBar.standardAppearance = appearance
            tabBar.scrollEdgeAppearance = appearance
        }
        
        let firstViewController = ViewControllerFactory.homeViewController()
      //  let firstViewController = DetailWordViewController()
        let firstTabBerItem = UITabBarItem(tabBarSystemItem: .bookmarks, tag: 1)
        firstTabBerItem.title = "learn"
        firstViewController.tabBarItem = firstTabBerItem
        let firstNavigationController = UINavigationController(rootViewController: firstViewController)
        
        
        let secondViewController = ViewControllerFactory.catalogViewController()
        secondViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.search, tag: 2)
        secondViewController.tabBarItem.title = "search"
        let secondNavigationController = UINavigationController(rootViewController: secondViewController)
        
        
        let thirdViewController = ViewControllerFactory.createImageViewController()
        thirdViewController.tabBarItem = UITabBarItem(tabBarSystemItem: UITabBarItem.SystemItem.downloads, tag: 3)
        thirdViewController.tabBarItem.title = "create"
        let thirdNavigationController = UINavigationController(rootViewController: thirdViewController)
        
        self.viewControllers = [firstNavigationController, secondNavigationController, thirdNavigationController]
        self.setViewControllers(self.viewControllers, animated:  false)
        print("🧩\(String(describing: self.viewControllers))")
    }
}
