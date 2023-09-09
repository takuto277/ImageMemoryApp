//
//  DetailWordPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/09.
//

import Foundation

class DetailWordPresenter {
    var view: DetailWordViewControllerProtocol?
    let dataBaseRepository: DataBaseRepositoryProtocol
    
    init(dataBaseRepository: DataBaseRepositoryProtocol) {
        self.dataBaseRepository = dataBaseRepository
    }
}

extension DetailWordPresenter: DetailWordProtocol {
    func attachView(_ view: DetailWordViewControllerProtocol) {
        self.view = view
    }
    
    func saveWordData(_ wordData: WordData) {
        var wordData = wordData
        if wordData.number == 0 {
            // 番号が初期の場合、設定する
            do {
                wordData.number = try self.dataBaseRepository.getWordDataCount() + 1
            } catch {
                print("データカウントが取得できなかった")
            }
        }
        if self.dataBaseRepository.insertWordData(wordData: wordData) {
            print("登録成功")
            self.view?.dismissScreen()
        }
    }
}
