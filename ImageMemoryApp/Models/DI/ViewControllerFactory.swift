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
    
    static func detailWordViewController(_ wordText: String, _ image: UIImage, _ sentence: String, _ viewController: UIViewController?) -> UIViewController {
        let vc = DetailWordViewController(wordText, image, sentence)
        vc.presenter = DetailWordPresenter(dataBaseRepository: DataBaseRepository())
        vc.delegate = viewController as? DetailWordViewControllerDelegate
        return vc
    }
}
