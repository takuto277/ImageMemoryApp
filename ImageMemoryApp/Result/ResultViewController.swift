//
//  ResultViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/06.
//

import UIKit

class ResultViewController: UIViewController {
    private let presenter: ResultPresenter
    
    init(presenter: ResultPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func finishButtonPushed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    
}
