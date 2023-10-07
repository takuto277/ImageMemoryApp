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
    

    
    init(_ presenter: LearningEnglishProtocol) {
        self.presenter = presenter
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
        self.presenter.confirmCorrection(true)
    }
    
    @IBAction func wordImageRightPushed(_ sender: Any) {
        self.presenter.confirmCorrection(false)
    }
    
    @IBAction func knowButtonPushed(_ sender: Any) {
        self.presenter.selectedKnowButton()
    }
    
    @IBAction func unknownButtonPushed(_ sender: Any) {
        self.presenter.selectedUnknownButton()
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
        self.presenter.checkNextNumber()
    }
}

    //MARK: - Protocol

extension LearningEnglishViewController: LearningEnglishViewControllerProtocol {
    /// 現在の英単語日表示/更新
    func fadeOutAndChangeInfo(_ randomValue: Bool, _ wordData: WordData, _ fakeImage: String, _ currentCount: Int, completion: (() -> Void)?) {
        UIView.animate(withDuration: 0.5, animations: {
            self.englishSentence.alpha = 0.0
            self.wordImageLeft.alpha = 0.0
            self.wordImageRight.alpha = 0.0
        }) { (finished) in
            if finished {
                // ランダムな画像を生成
                let imageLeft = Converter().decodeBase64ToImage(randomValue
                                                                ? wordData.imageURL
                                                                : fakeImage)
                let imageRight = Converter().decodeBase64ToImage(randomValue
                                                                 ? fakeImage
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
    
    /// 現在の英単語処理が完了
    func finishedCurrentWordDataProcess() {
        self.presenter.checkNextNumber()
    }
    
    func navigationToDetailWordScreen(_ wordData: WordData) {
        let detailWordViewController = ViewControllerFactory.detailWordViewController(wordData, .LearningEnglish)
        detailWordViewController.modalPresentationStyle = .fullScreen
        self.present(detailWordViewController, animated: true)
    }
    
    func navigationToResultScreen() {
        let resultViewController = ViewControllerFactory.resultViewController()
        navigationController?.pushViewController(resultViewController, animated: true)
    }
    

}
