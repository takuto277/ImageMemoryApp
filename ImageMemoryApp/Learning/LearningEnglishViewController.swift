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
    
    private var isviewFirstLoaded = true
    private var currentNumber: Int = 0
    // 正解画像位置を格納(randoValueがtrueならLeftが正解, falseならRightが正解)
    private var correctImageLocation: Bool = true
    
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
        self.presenter.confirmCorrection(self.correctImageLocation == true)
    }
    
    @IBAction func wordImageRightPushed(_ sender: Any) {
        self.presenter.confirmCorrection(self.correctImageLocation == false)
    }
    
    @IBAction func knowButtonPushed(_ sender: Any) {
        // TODO: 更新処理する
    }
    
    @IBAction func unknownButtonPushed(_ sender: Any) {
        // TODO: navigationに遷移させる
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
        if !self.isviewFirstLoaded {
            self.presenter.checkNextNumber(self.wordDataArray.count, self.currentNumber)
        } else {
            // 初回だけこっち
            self.presenter.firstLoaded()
            self.isviewFirstLoaded = false
        }
    }
}

    //MARK: - Protocol

extension LearningEnglishViewController: LearningEnglishViewControllerProtocol {

    func increaceCurrentNumber() {
        self.currentNumber += 1
    }
    
    /// 現在の英単語日表示/更新
    func fadeOutAndChangeInfo(completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.englishSentence.alpha = 0.0
            self.wordImageLeft.alpha = 0.0
            self.wordImageRight.alpha = 0.0
        }) { (finished) in
            if finished {
                let wordData = self.wordDataArray[self.currentNumber]
                let randomValue = arc4random_uniform(2) == 0
                self.correctImageLocation = randomValue
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
                
                // コールバックを実行して次のアニメーションを開始
                completion?()
            }
        }
    }
    
    
    /// 次の英単語表示
    func fadeInInfo() {
        // ラベルを元に戻すアニメーションを追加
        UIView.animate(withDuration: 0.5, animations: {
            self.englishSentence.alpha = 1.0
            self.wordImageLeft.alpha = 1.0
            self.wordImageRight.alpha = 1.0
        })
        self.presenter.textReading(self.englishSentence.text ?? "")
    }
    
    /// 読み上げ機能
    /// - Parameter text: 読み上げたい英文
    func textReading(_ text: String) {
        let synthesizer = AVSpeechSynthesizer()
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
        synthesizer.speak(utterance)
    }
    
    /// 現在の英単語データを取得する
    /// - Parameter correction: 問題の正誤(true: 正解, false: 不正解)
    func getCurrentWordData(_ correction: Bool) {
        self.presenter.updateCurrentWordData(self.wordDataArray[self.currentNumber], correction)
    }
    
    
    /// 現在の英単語処理が完了
    func finishedCurrentWordDataProcess() {
        self.presenter.checkNextNumber(self.wordDataArray.count, self.currentNumber)
    }
    
    func navigationToScreen() {
        
    }
}
