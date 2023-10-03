//
//  HomePresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/02.
//

import Foundation

class HomePresenter {
    var view: HomeViewControllerProtocol?
    let dataBaseRepository: DataBaseRepositoryProtocol
    
    init(dataBaseRepository: DataBaseRepositoryProtocol) {
        self.dataBaseRepository = dataBaseRepository
    }
}

extension HomePresenter: HomeProtocol {
    func attachView(_ view: HomeViewControllerProtocol) {
        self.view = view
    }
    
    func getLearnWordData() {
        var wordData = [WordData]()
        var fakeImageArray: [String] = []
        do {
            wordData = try self.dataBaseRepository.getLearningWordData()
        } catch {
            print("英単語の取得に失敗しました。")
        }
        
        for wordData in wordData {
            fakeImageArray.append(wordData.imageURL)
            
            if fakeImageArray.count > 100 {
                break
            }
        }
        
        self.view?.fetchLearnWordData(<#T##wordsData: [WordData]##[WordData]#>, fakeImageArray)
    }
    
    
}
