//
//  EditDetailWordPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/09.
//

import Foundation

class EditDetailWordPresenter {
    var view: EditDetailWordViewControllerProtocol?
    let dataBaseRepository: DataBaseRepositoryProtocol
    
    init(dataBaseRepository: DataBaseRepositoryProtocol) {
        self.dataBaseRepository = dataBaseRepository
    }
}

extension EditDetailWordPresenter: EditDetailWordProtocol {
    func attachView(_ view: EditDetailWordViewControllerProtocol) {
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
    
    func updateWordData(_ wordData: WordData) {
        if self.dataBaseRepository.updateWordData(wordData: wordData) {
            print("更新登録成功")
            self.view?.dismissScreen()
        }
    }
}
