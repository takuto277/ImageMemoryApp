//
//  DetailWordViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/08/02.
//

import UIKit

class DetailWordViewController: UIViewController {
    
    @IBOutlet weak var wordTextView: UITextView?
    @IBOutlet weak var imageView: UIImageView?
    @IBOutlet weak var sentenceField: UITextField?
    
    private let wordText: String
    private let image: UIImage
    private var sentence: String?
    
    init(_ wordText: String, _ image: UIImage, _ sentence: String?) {
        self.wordText = wordText
        self.image = image
        self.sentence = sentence
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.wordTextView?.text = self.wordText
        self.imageView?.image = self.image
        self.sentenceField?.text = sentence
    }
    
    @IBAction func decisionButton(_ sender: Any) {
        guard let image = self.imageView?.image,
              let word = self.wordTextView?.text,
              let imageURL = Converter().encodeImageToBase64(image) else { return }
        let wordData = WordData(imageURL: imageURL, wordName: word, number: 3)
        if DataBaseService.shared.insertWordData(wordData: wordData) {
            print("登録成功")
        }
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            self.dismiss(animated: true)
        }
    }
}
