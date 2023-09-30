//
//  DetailWordViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/10.
//

import UIKit

class DetailWordViewController: UIViewController {
    
    // MARK: - IBOutlet
    @IBOutlet weak var englishWord: UILabel!
    @IBOutlet weak var japaneseWord: UILabel!
    @IBOutlet weak var enjlishSentence: UILabel!
    @IBOutlet weak var japaneseSentence: UILabel!
    @IBOutlet weak var wordImage: UIImageView!
    @IBOutlet weak var decideButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction func decideButtonPushed(_ sender: Any) {
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension DetailWordViewController: DetailWordViewControllerProtocol {
    
}
