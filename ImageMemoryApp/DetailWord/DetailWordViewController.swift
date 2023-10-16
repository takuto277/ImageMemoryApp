//
//  DetailWordViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/10.
//

import UIKit

class DetailWordViewController: UIViewController {
    private let presenter: DetailWordProtocol
    
    init(presenter: DetailWordProtocol) {
        self.presenter = presenter
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
        self.presenter.decideButtonPushed()
    }
    
    @IBAction func editButtonPushed(_ sender: Any) {
        self.presenter.editButtonPushed()
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attachView(self)
        self.presenter.getWordData()
    }
    
    // MARK: - Private method
    
    func attachData(_ wordData: WordData, editButtonHidden: Bool) {
        self.englishWord.text = wordData.englishWordName
        self.japaneseWord.text = wordData.japanWordName
        self.englishSentence.text = wordData.englishSentence
        self.japaneseSentence.text = wordData.japanSentence
        self.wordImage.image = Converter().decodeBase64ToImage(wordData.imageURL)
        self.decideButton.setTitle("閉じる", for: .normal)
        self.editButton.setTitle("編集", for: .normal)
        
        self.editButton.isHidden = editButtonHidden
    }
}

extension DetailWordViewController: DetailWordViewControllerProtocol {
    func navigationWithDismiss() {
        self.dismiss(animated: true)
    }
    
    func navigationWithPopView() {
        self.navigationController?.popViewController(animated: true)
    }
    
    func navigationForEditDetailWordVC(wordData: WordData) {
        let editDetailWordViewController = ViewControllerFactory.editdetailWordViewController(wordData, nil, nil)
    }
}
