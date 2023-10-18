//
//  ViewControllerFactory.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/02.
//

import UIKit

struct ViewControllerFactory {
    static func homeViewController() -> UIViewController {
        let presenter = HomePresenter(dataBaseRepository: DataBaseRepository())
        let vc = HomeViewController(presenter: presenter)
        return vc
    }
    
    static func learningEnglishViewController(_ wordDataArray: [WordData], _ fakeImageArray: [String]) -> UIViewController {
        let presenter = LearningEnglishPresenter(DataBaseRepository(), wordDataArray, fakeImageArray)
        let vc = LearningEnglishViewController(presenter)
        return vc
    }
    
    static func resultViewController(learnResult: LearnResult) -> UIViewController {
        let presenter = ResultPresenter(dataBaseRepository: DataBaseRepository(), learnResult: learnResult)
        let vc = ResultViewController(presenter: presenter)
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
        return vc
    }
    
    static func selectImageViewController() -> UIViewController {
        let presenter = SelectImagePresenter()
        let vc = SelectImageViewController(presenter: presenter)
        return vc
    }
    
    static func detailWordViewController(_ wordData: WordData, _ calledFlg: DetailWordCalledFlg) -> UIViewController {
        let presenter = DetailWordPresenter(wordData, calledFlg)
        let vc = DetailWordViewController(presenter: presenter)
        return vc
    }
    
    static func editdetailWordViewController(_ wordData: WordData, _ image: UIImage?, _ viewController: UIViewController?) -> UIViewController {
        let vc = EditDetailWordViewController(wordData, image)
        vc.presenter = EditDetailWordPresenter(dataBaseRepository: DataBaseRepository())
        vc.delegate = viewController as? EditDetailWordViewControllerDelegate
        return vc
    }
}
