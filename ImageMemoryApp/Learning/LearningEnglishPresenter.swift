//
//  LearningPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/01.
//

import Foundation

class LearningEnglishPresenter {
    var view: LearningEnglishViewControllerProtocol?
    private let wordDataArray: [WordData]
    private let fakeImageArray: [String]
    private var currentNumber: Int = 0
    
    private var isviewFirstLoaded = true
    // 正解画像位置を格納(randoValueがtrueならLeftが正解, falseならRightが正解)
    private var correctImageLocation: Bool = true
    
    init(_ wordDataArray: [WordData], _ fakeImageArray: [String]) {
        self.wordDataArray = wordDataArray
        self.fakeImageArray = fakeImageArray
    }
}

extension LearningEnglishPresenter: LearningEnglishProtocol {
    func attachView(_ view: LearningEnglishViewControllerProtocol) {
        self.view = view
    }
    
    /// 読み上げ機能呼び出し
    /// - Parameter text: 読み上げたい文章
    func textReading(_ text: String) {
        self.view?.textReading(text)
    }
    
    /// 選択した画像の正誤確認
    /// - Parameter correction: 選んだ画像の位置(true: 左画像, false: 右画像)
    func confirmCorrection(_ selectedLeft: Bool) {
        if self.correctImageLocation == selectedLeft {
            //TODO: ここで単語を更新
            self.view?.finishedCurrentWordDataProcess()
        } else {
            // TODO: ここで単語更新
            // 解説表示
            self.view?.navigationToDetailWordScreen(self.wordDataArray[self.currentNumber])
        }
    }
    
    /// 次の英単語有無確認
    /// - Parameters:
    ///   - wordDataCount: 英単語
    ///   - currentCount: 現在の表示した英語数
    func checkNextNumber() {
        if self.wordDataArray.count - 1 >= self.currentNumber + 1 {
            if !self.isviewFirstLoaded {
                self.currentNumber += 1
            } else {
                self.isviewFirstLoaded = false
            }
            
            let randomValue = arc4random_uniform(2) == 0
            self.correctImageLocation = randomValue
            let fakeImage = self.fakeImageArray[Int(arc4random_uniform(UInt32(self.fakeImageArray.count)))]
            self.view?.fadeOutAndChangeInfo(randomValue, self.wordDataArray[self.currentNumber],fakeImage, self.currentNumber, completion: { [weak self] in
                self?.view?.fadeInInfo()
            })
        } else {
            // 次の問題がない場合、結果画面へ遷移
            self.view?.navigationToResultScreen()
        }
    }
}
