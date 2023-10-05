//
//  LearningPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/01.
//

import Foundation

class LearningEnglishPresenter {
    var view: LearningEnglishViewControllerProtocol?
}

extension LearningEnglishPresenter: LearningEnglishProtocol {
    func attachView(_ view: LearningEnglishViewControllerProtocol) {
        self.view = view
    }
    
    func firstLoaded() {
        self.view?.fadeOutAndChangeInfo(completion: { [weak self] in
            self?.view?.fadeInInfo()
        })
    }
    
    /// 読み上げ機能呼び出し
    /// - Parameter text: 読み上げたい文章
    func textReading(_ text: String) {
        self.view?.textReading(text)
    }
    
    /// 選択した画像の正誤確認
    /// - Parameter correction: 正誤(true: 正解, false: 不正解)
    func confirmCorrection(_ correction: Bool) {
        if correction {
            // 正解の英単語データ取得
            self.view?.getCurrentWordData(true)
        } else {
            // 不正解の英単語データ取得
            self.view?.getCurrentWordData(false)
            // 解説表示
            self.view?.navigationToScreen()
        }
        self.view?.finishedCurrentWordDataProcess()
    }
    
    /// 現在の英単語更新
    /// - Parameters:
    ///   - wordData: <#wordData description#>
    ///   - correction: <#correction description#>
    func updateCurrentWordData(_ wordData: WordData, _ correction: Bool) {
        // TODO: 習熟度とか変更
        if correction {
            // 正解
        } else {
            // 不正解
        }
    }
    
    /// 次の英単語有無確認
    /// - Parameters:
    ///   - wordDataCount: <#wordDataCount description#>
    ///   - currentCount: <#currentCount description#>
    func checkNextNumber(_ wordDataCount: Int, _ currentCount: Int) {
        if wordDataCount >= currentCount + 1 {
            self.view?.increaceCurrentNumber()
            self.view?.fadeOutAndChangeInfo(completion: { [weak self] in
                self?.view?.fadeInInfo()
            })
        } else {
            // TODO: 終わり画面へ遷移
            // wordDataも持って行った方がいいかも
        }
    }
}
