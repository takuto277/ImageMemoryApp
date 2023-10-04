//
//  LearningEnglishViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/01.
//

import UIKit
import AVFoundation

class LearningEnglishViewController: UIViewController {
    private let presenter: LearningEnglishProtocol
    private let wordDataArray: [WordData]
    private let fakeImageArray: [String]
    
    private var currentNumber: Int = 0
    
    init(_ presenter: LearningEnglishProtocol, _ wordDataArray: [WordData], _ fakeImageArray: [String]) {
        self.presenter = presenter
        self.wordDataArray = wordDataArray
        self.fakeImageArray = fakeImageArray
        super.init(nibName: String(describing: LearningEnglishViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var englishSentence: UILabel!
    @IBOutlet weak var wordImageLeft: UIImageView!
    @IBOutlet weak var wordImageRight: UIImageView!
    
    // MARK: - IBAction
    
    
    @IBAction func wordImageLeftPushed(_ sender: Any) {
        // TODO: 正解したものかの確認メソッド追加
        self.presenter.changeInfo()
    }
    
    @IBAction func wordImageRightPushed(_ sender: Any) {
        self.presenter.changeInfo()
    }
    
    @IBAction func knowButtonPushed(_ sender: Any) {
        self.presenter.changeInfo()
    }
    
    @IBAction func unknownButtonPushed(_ sender: Any) {
        self.presenter.changeInfo()
    }
    
    @IBAction func repeatButtonPushed(_ sender: Any) {
        self.presenter.textReading(self.englishSentence.text ?? "")
        // TODO: 音声流す処理
    }
    
    //MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.hidesBackButton = true
        self.presenter.attachView(self)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // TODO: 音声流す処理
        self.presenter.changeInfo()
    }
}

    //MARK: - Protocol

extension LearningEnglishViewController: LearningEnglishViewControllerProtocol {
    func fadeOutAndChangeInfo() {
        self.currentNumber += 1
        
        UIView.animate(withDuration: 0.5, animations: {
            self.englishSentence.alpha = 0.0
            self.wordImageLeft.alpha = 0.0
            self.wordImageRight.alpha = 0.0
        }) { (finished) in
            if finished {
                let wordData = self.wordDataArray[self.currentNumber]
                let randomValue = arc4random_uniform(2) == 0
                // ランダムな画像を生成
                let imageLeft = Converter().decodeBase64ToImage(randomValue
                                                                ? wordData.imageURL
                                                                : self.fakeImageArray[Int(arc4random_uniform(20))])
                let imageRight = Converter().decodeBase64ToImage(randomValue
                                                                 ? self.fakeImageArray[Int(arc4random_uniform(20))]
                                                                 : wordData.imageURL)
                // アニメーションが完了したら新しいテキストを設定
                self.englishSentence.text = wordData.englishSentence
                self.wordImageLeft.image = imageLeft
                self.wordImageRight.image = imageRight
            }
        }
    }
    
    func fadeInInfo() {
        // ラベルを元に戻すアニメーションを追加
        UIView.animate(withDuration: 0.5, animations: {
            self.englishSentence.alpha = 1.0
            self.wordImageLeft.alpha = 1.0
            self.wordImageRight.alpha = 1.0
        })
        self.presenter.textReading(self.englishSentence.text ?? "")
    }
    
    func textReading(_ text: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
}
