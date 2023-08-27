//
//  DetailWordViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/08/02.
//

import UIKit

class DetailWordViewController: UIViewController {
    
    @IBOutlet weak var wordTextView: UITextView?
    @IBOutlet weak var imageView: UIImageView? {
        willSet {
            newValue?.contentMode = .scaleAspectFit
            newValue?.clipsToBounds = true
            newValue?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var sentenceTextView: UITextView? {
        willSet {
            newValue?.delegate = self
            // UITextFieldの枠線を表示する
            newValue?.layer.borderColor = UIColor(named: "gold")?.cgColor
            newValue?.layer.borderWidth = 1.0
        }
    }
    
    weak var delegate: DetailWordViewControllerDelegate?
    
    private let wordText: String
    private let image: UIImage
    private var sentence: String
    
    init(_ wordText: String, _ image: UIImage, _ sentence: String = "") {
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
        // 画像のアスペクト比を計算します
        let imageAspectRatio = image.size.width / image.size.height
        // imageViewの幅と高さの制約を設定します
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.widthAnchor.constraint(equalTo: imageView!.heightAnchor, multiplier: imageAspectRatio).isActive = true
        
        // ここにコードを追加してcontentModeの値を出力します
        if let contentMode = self.imageView?.contentMode {
            print("ImageView contentMode: \(contentMode)")
        }
        
        self.wordTextView?.text = self.wordText
        self.imageView?.image = self.image
        self.sentenceTextView?.text = sentence
        // プレースホルダーのテキストを設定
        if self.sentenceTextView?.text == "" {
            let placeholderText = "英文を入力してください。"
            self.sentenceTextView?.text = placeholderText
            self.sentenceTextView?.textColor = UIColor.gray
        }
    }
    
    @IBAction func decisionButton(_ sender: Any) {
        guard let image = self.imageView?.image,
              let word = self.wordTextView?.text, !word.isEmpty,
              let imageURL = Converter().encodeImageToBase64(image) else {
          DispatchQueue.main.async {
              let alert = UIAlertController(title: "英単語を入力してください", message: nil, preferredStyle: .alert)
              alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
              self.present(alert, animated: true, completion: nil)
          }
            return }
        let number = DataBaseService.shared.getWordDataCount() + 1
        if sentenceTextView?.text == "英文を入力してください。" && sentenceTextView?.textColor == UIColor.gray {
            self.sentence = ""
        }
        let wordData = WordData(imageURL: imageURL,
                                wordName: word,
                                sentence: self.sentence,
                                proficiency: "0",
                                priorityNumber: "0",
                                number: number)
        if DataBaseService.shared.insertWordData(wordData: wordData) {
            print("登録成功")
        }
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            self.delegate?.didDismissViewController(self)
            self.dismiss(animated: true)
        }
    }
}

extension DetailWordViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
            // プレースホルダーが表示されている場合は消去する
            if textView.text == "英文を入力してください。" && textView.textColor == UIColor.gray {
                textView.text = ""
                textView.textColor = UIColor.white
            }
            // 編集を許可する
            return true
        }
    
        func textViewDidEndEditing(_ textView: UITextView) {
            // テキストが空の場合にプレースホルダーを再表示する
            if textView.text.isEmpty {
                let placeholderText = "英文を入力してください。"
                textView.text = placeholderText
                textView.textColor = UIColor.gray
            }
        }
    }
