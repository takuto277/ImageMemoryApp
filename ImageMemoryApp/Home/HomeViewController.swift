//
//  HomeViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/28.
//

import UIKit

class HomeViewController: UIViewController {
    let presenter: HomeProtocol
    
    init(presenter: HomeProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - IBAction
    
    @IBAction func startButtonPushed(_ sender: Any) {
        self.presenter.getLearnWordData()
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(self)
    }
}

//MARK: - Protocol

extension HomeViewController: HomeViewControllerProtocol {
    func navigationToLearningScreen(_ wordsData: [WordData], _ fakeImageArray: [String]) {
        let learningEnglishViewController = ViewControllerFactory.learningEnglishViewController(wordsData, fakeImageArray)
        learningEnglishViewController.hidesBottomBarWhenPushed = true
        navigationController?.pushViewController(learningEnglishViewController, animated: true)
    }
}
