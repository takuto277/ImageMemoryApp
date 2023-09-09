//
//  DetailWordViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/08/02.
//

import UIKit

class DetailWordViewController: UIViewController {
    var presenter: DetailWordProtocol?
    weak var delegate: DetailWordViewControllerDelegate?
    
    // private
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
    
// MARK: - IBOutlet
    @IBOutlet weak var englishWordTextView: UITextView?
    @IBOutlet weak var japanWordTextView: UITextView? {
        willSet {
            newValue?.delegate = self
        }
    }
    
    @IBOutlet weak var imageView: UIImageView? {
        willSet {
            newValue?.contentMode = .scaleAspectFit
            newValue?.clipsToBounds = true
            newValue?.translatesAutoresizingMaskIntoConstraints = false
        }
    }
    @IBOutlet weak var englishSentenceTextView: UITextView? {
        willSet {
            newValue?.delegate = self
            // UITextFieldの枠線を表示する
            newValue?.layer.borderColor = UIColor(named: "gold")?.cgColor
            newValue?.layer.borderWidth = 1.0
        }
    }
    @IBOutlet weak var japanSentenceTextView: UITextView? {
        willSet {
            newValue?.delegate = self
            // UITextFieldの枠線を表示する
            newValue?.layer.borderColor = UIColor(named: "gold")?.cgColor
            newValue?.layer.borderWidth = 1.0
        }
    }
    
//MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.attachView(self)
        // 初期設定
        self.setImageSetting()
        self.setInitalWordData()
    }
    
//MARK: - @IBAction
    @IBAction func decisionButton(_ sender: Any) {
        guard let image = self.imageView?.image,
              let imageURL = Converter().encodeImageToBase64(image) else {
            print("画像のコンバートに失敗しました")
            return
        }
        
        guard let englishWordName = self.englishWordTextView?.text, !englishWordName.isEmpty else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "英単語を入力してください", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return }
        
        if self.japanWordTextView?.text == "英単語の日本語訳を入力" && self.japanWordTextView?.textColor == UIColor.gray {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "英単語の日本語訳を入力してください", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        guard let japanWordName = self.japanWordTextView?.text else { return }
        
        if englishSentenceTextView?.text == "英文を入力してください。" && englishSentenceTextView?.textColor == UIColor.gray {
            self.sentence = ""
        }
        
        if japanSentenceTextView?.text == "英文の日本語訳を入力してください。" && japanSentenceTextView?.textColor == UIColor.gray {
            self.japanSentenceTextView?.text = ""
        }
        
        self.presenter?.saveWordData(WordData(englishWordName: englishWordName,
                                              japanWordName: japanWordName,
                                              englishSentence: self.sentence,
                                              japanSentence: self.japanSentenceTextView?.text ?? "",
                                              proficiency: "0",
                                              priorityNumber: "0",
                                              number: 0,
                                              deleteFlg: "0",
                                              imageURL: imageURL))
    }
    
// MARK: - Private method
    private func setImageSetting() {
        // 画像のアスペクト比を計算します
        let imageAspectRatio = image.size.width / image.size.height
        // imageViewの幅と高さの制約を設定します
        imageView?.translatesAutoresizingMaskIntoConstraints = false
        imageView?.widthAnchor.constraint(equalTo: imageView!.heightAnchor, multiplier: imageAspectRatio).isActive = true
    }
    
    private func setInitalWordData() {
        self.englishWordTextView?.text = self.wordText
        self.imageView?.image = self.image
        self.englishSentenceTextView?.text = sentence
        // プレースホルダーのテキストを設定
        if self.japanWordTextView?.text == "" {
            let placeholderText = "英単語の日本語訳を入力"
            self.japanWordTextView?.text = placeholderText
            self.japanWordTextView?.textColor = UIColor.gray
        }
        if self.englishSentenceTextView?.text == "" {
            let placeholderText = "英文を入力してください。"
            self.englishSentenceTextView?.text = placeholderText
            self.englishSentenceTextView?.textColor = UIColor.gray
        }
        if self.japanSentenceTextView?.text == "" {
            let placeholderText = "英文の日本語訳を入力してください。"
            self.japanSentenceTextView?.text = placeholderText
            self.japanSentenceTextView?.textColor = UIColor.gray
        }
    }
}

// MARK: - TextView

extension DetailWordViewController: UITextViewDelegate {
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        // プレースホルダーが表示されている場合は消去する
        if textView.tag == DetailWordTextViewTag.japanWord.rawValue && textView.text == "英単語の日本語訳を入力" && textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.white
    } else if textView.tag == DetailWordTextViewTag.englishSentence.rawValue && textView.text == "英文を入力してください。" && textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.white
    } else if textView.tag == DetailWordTextViewTag.japanSentence.rawValue && textView.text == "英文の日本語訳を入力してください。" && textView.textColor == UIColor.gray {
            textView.text = ""
            textView.textColor = UIColor.white
        }
        // 編集を許可する
        return true
    }
    
    func textViewDidEndEditing(_ textView: UITextView) {
        // テキストが空の場合にプレースホルダーを再表示する
        if textView.tag == DetailWordTextViewTag.japanWord.rawValue && textView.text.isEmpty {
            let placeholderText = "英単語の日本語訳を入力"
            textView.text = placeholderText
            textView.textColor = UIColor.gray
        } else if textView.tag == DetailWordTextViewTag.englishSentence.rawValue && textView.text.isEmpty {
            let placeholderText = "英文を入力してください。"
            textView.text = placeholderText
            textView.textColor = UIColor.gray
        } else if textView.tag == DetailWordTextViewTag.japanSentence.rawValue && textView.text.isEmpty {
            let placeholderText = "英文の日本語訳を入力してください。"
            textView.text = placeholderText
            textView.textColor = UIColor.gray
        }
    }
}

// MARK: - Protocol

extension DetailWordViewController: DetailWordViewControllerProtocol {
    func dismissScreen() {
        if let navigationController = self.navigationController {
            navigationController.popToRootViewController(animated: true)
            self.delegate?.didDismissViewController(self)
            self.dismiss(animated: true)
        }
    }
}
