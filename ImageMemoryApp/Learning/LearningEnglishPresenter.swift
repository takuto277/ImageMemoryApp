//
//  LearningPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/01.
//

import Foundation

class LearningEnglishPresenter {
    var view: LearningEnglishViewControllerProtocol?
    private let dataBaseRepository: DataBaseRepositoryProtocol
    private let wordDataArray: [WordData]
    private let fakeImageArray: [String]
    private var currentNumber: Int = 0
    private var newWordDataArray: [WordData] = []
    
    private var isviewFirstLoaded = true
    // 正解画像位置を格納(randoValueがtrueならLeftが正解, falseならRightが正解)
    private var correctImageLocation: Bool = true
    
    init(_ dataBaseRepository: DataBaseRepositoryProtocol, _ wordDataArray: [WordData], _ fakeImageArray: [String]) {
        self.dataBaseRepository = dataBaseRepository
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
            _ = self.updateWordData(.correct)
            self.view?.finishedCurrentWordDataProcess()
        } else {
            _ = self.updateWordData(.incorrect)
            // 解説表示
            self.view?.navigationToDetailWordScreen(self.wordDataArray[self.currentNumber])
        }
    }
    
    /// 理解済みボタン押下の処理
    func selectedKnowButton() {
        _ = self.updateWordData(.know)
        self.view?.finishedCurrentWordDataProcess()
    }
    
    /// 理解していないボタン押下の処理
    func selectedUnknownButton() {
        _ = self.updateWordData(.unknown)
        self.view?.navigationToDetailWordScreen(self.wordDataArray[self.currentNumber])
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
            do {
                _ = try self.dataBaseRepository.updateLearningWordData(self.newWordDataArray)
            } catch {
                print("保存で失敗")
            }
            // 次の問題がない場合、結果画面へ遷移
            self.view?.navigationToResultScreen()
        }
    }
    
    /// 学習単語の更新配列を作成
    /// - Parameter userSelectionFlg: ユーザー選択の正誤
    /// - Returns: true: 作成成功, false: 作成失敗
    private func updateWordData(_ userSelectionFlg: UserSelectionFlg) -> Bool {
        var newWordData = self.wordDataArray[self.currentNumber]
        newWordData.updateValues(valueName: .proficiency, newValue: "1")
        guard let priorityNumber = Int(newWordData.priorityNumber) else {
            print("予期せぬエラー: 変換に失敗したから、追加しません")
            return false
        }
        switch userSelectionFlg {
        case .correct:
            if priorityNumber < 10 {
                newWordData.updateValues(valueName: .priorityNumber, newValue: String(priorityNumber + 1))
                newWordData.updateValues(valueName: .proficiency, newValue: "1")
            } else {
                newWordData.updateValues(valueName: .proficiency, newValue: "2")
            }
            self.newWordDataArray.append(newWordData)
            return true
            
        case .incorrect, .unknown:
            if priorityNumber > 0 {
                newWordData.updateValues(valueName: .priorityNumber, newValue: String(priorityNumber - 1))
            }
            self.newWordDataArray.append(newWordData)
            return true
            
        case .know:
            newWordData.updateValues(valueName: .proficiency, newValue: "2")
            self.newWordDataArray.append(newWordData)
            return true
        }
    }
}
