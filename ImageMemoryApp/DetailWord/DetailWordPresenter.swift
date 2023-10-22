//
//  DetailWordPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/30.
//

import Foundation

class DetailWordPresenter {
    var view: DetailWordViewControllerProtocol?
    private let wordData: WordData
    private let calledFlg: DetailWordCalledFlg
    
    init(_ wordData: WordData, _ calledFlg: DetailWordCalledFlg) {
        self.wordData = wordData
        self.calledFlg = calledFlg
    }
}

extension DetailWordPresenter: DetailWordProtocol {
    func attachView(_ view: DetailWordViewControllerProtocol) {
        self.view = view
    }
    
    func getWordData() {
        // 呼ばれた画面次第で、表示する情報を変更する(カタログ画面からのみ編集できるようにする)
        self.view?.attachData(self.wordData, editButtonHidden:self.calledFlg != .Catalog)
    }
    
    func decideButtonPushed() {
        if self.calledFlg == .LearningEnglish {
            // 英語学習画面の時のみモーダル遷移であるためdismissする
            self.view?.navigationWithDismiss()
        } else {
            self.view?.navigationWithPopView()
        }
    }
    
    func editButtonPush() {
        self.view?.navigationForEditDetailWordVC(wordData: wordData)
    }
}
