//
//  ViewControllerFactory.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/02.
//

import UIKit

struct ViewControllerFactory {
    static func homeViewController() -> UIViewController {
      //  let presenter = SelectImagePresenter()
        let vc = HomeViewController()
  //      vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func catalogViewController() -> UIViewController {
        let vc = CatalogViewController()
        vc.presenter = CatalogPresenter(dataBaseRepository: DataBaseRepository())
        return vc
    }
    static func createImageViewController() -> UIViewController {
        let presenter = CreateImagePresenter()
        let vc = CreateImageViewController(presenter: presenter)
  //      vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func selectImageViewController() -> UIViewController {
        let presenter = SelectImagePresenter()
        let vc = SelectImageViewController(presenter: presenter)
  //      vc.modalPresentationStyle = .fullScreen
        return vc
    }
    
    static func detailWordViewController(_ wordData: WordData, _ calledFlg: DetailWordCalledFlg) -> UIViewController {
        let presenter = DetailWordPresenter()
        let vc = DetailWordViewController(presenter: presenter, wordData: wordData, calledFlg: calledFlg)
        return vc
    }
    
    static func editdetailWordViewController(_ wordData: WordData, _ image: UIImage?, _ viewController: UIViewController?) -> UIViewController {
        let vc = EditDetailWordViewController(wordData, image)
        vc.presenter = EditDetailWordPresenter(dataBaseRepository: DataBaseRepository())
        vc.delegate = viewController as? EditDetailWordViewControllerDelegate
        return vc
    }
}
