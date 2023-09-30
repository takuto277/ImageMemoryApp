//
//  DetailWordViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/10.
//

import UIKit

class DetailWordViewController: UIViewController {
    private let presenter: DetailWordProtocol
    private let wordData: WordData
    private let calledFlg: DetailWordCalledFlg
    
    init(presenter: DetailWordProtocol, wordData: WordData, calledFlg: DetailWordCalledFlg) {
        self.presenter = presenter
        self.wordData = wordData
        self.calledFlg = calledFlg
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlet
    @IBOutlet weak var englishWord: UILabel!
    @IBOutlet weak var japaneseWord: UILabel!
    @IBOutlet weak var englishSentence: UILabel!
    @IBOutlet weak var japaneseSentence: UILabel!
    @IBOutlet weak var wordImage: UIImageView!
    @IBOutlet weak var decideButton: UIButton!
    @IBOutlet weak var editButton: UIButton!
    
    // MARK: - IBAction
    
    @IBAction func decideButtonPushed(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
    @IBAction func editButtonPushed(_ sender: Any) {
        let editDetailWordViewController = ViewControllerFactory.editdetailWordViewController(wordData, nil, nil)
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(self)
        self.attachData()
    }
    
    // MARK: - Private method
    
    func attachData() {
        self.englishWord.text = wordData.englishWordName
        self.japaneseWord.text = wordData.japanWordName
        self.englishSentence.text = wordData.englishSentence
        self.japaneseSentence.text = wordData.japanSentence
        self.wordImage.image = Converter().decodeBase64ToImage(wordData.imageURL)
        
        self.decideButton.setTitle("閉じる", for: .normal)
        // 呼ばれた画面次第で、表示する情報を変更する
        if self.calledFlg == .Catalog {
            self.editButton.setTitle("編集", for: .normal)
        } else {
            self.editButton.isHidden = true
        }
    }
}

extension DetailWordViewController: DetailWordViewControllerProtocol {
    
}
