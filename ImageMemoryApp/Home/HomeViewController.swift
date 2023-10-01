//
//  HomeViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/28.
//

import UIKit

class HomeViewController: UIViewController {
    
    init() {
        super.init(nibName: String(describing: HomeViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    // MARK: - IBAction
    
    @IBAction func startButtonPushed(_ sender: Any) {
        // 10個の学習データ取得
        // 20個のフェイク画像を取得
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
}

    //MARK: - Protocol

extension HomeViewController: HomeViewControllerProtocol {
    func fetchLearnWordData(_ wordsData: [WordData], _ faceImageArray: [String]) {
        <#code#>
    }
}
