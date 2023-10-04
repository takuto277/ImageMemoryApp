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
    
    func changeInfo() {
        self.view?.fadeOutAndChangeInfo()
        self.view?.fadeInInfo()
    }
    
    func textReading(_ text: String) {
        self.view?.textReading(text)
    }
    
    func confirmCorrection(_ correction: Bool) {
        if correction {
            // 次の問題へ
            self.view?.fadeOutAndChangeInfo()
            self.view?.fadeInInfo()
        } else {
            // 解説表示
            self.view?.navigationToScreen()
        }
    }
    
    func checkNextNumber() {
        <#code#>
    }
}
