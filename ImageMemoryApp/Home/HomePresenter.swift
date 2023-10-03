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
        var resultWordDatas = [WordData]()
        var fakeImageArray: [String] = []
        do {
            wordData = try self.dataBaseRepository.getLearningWordData()
        } catch {
            print("英単語の取得に失敗しました。")
        }
        
        // 学習する英単語の配列を生成
        let targetNumbers = [["0", "1", "2", "3", "4"], ["5", "6", "7"], ["8", "9", "10"]]
        
        targetNumbers.forEach { targetNumber in
            let filterArray = self.filterStructArray(wordData: wordData, targetNumbers: targetNumber).shuffled()
            let numberOfElementToGet = filterArray.count >= 5 ? 5 : filterArray.count
            Array(filterArray.prefix(5)).forEach { wordData in
                resultWordDatas.append(wordData)
            }
        }
        
        // 学習する英単語が10個未満の時に補充
        if resultWordDatas.count < 10 {
            var wordDatas = wordData
            wordDatas.shuffle()
            for wordData in wordDatas {
                // 登録されている英単語データは登録しない
                if !resultWordDatas.contains(where: { $0.number == wordData.number }) {
                    resultWordDatas.append(wordData)
                }
                if resultWordDatas.count > 10 {
                    break
                }
            }
        }
        
        // 不正解画像の配列を生成
        for wordData in wordData {
            fakeImageArray.append(wordData.imageURL)
            
            if fakeImageArray.count > 100 {
                break
            }
        }
        
        self.view?.fetchLearnWordData(resultWordDatas, fakeImageArray)
    }
    
    private func filterStructArray(wordData: [WordData], targetNumbers: [String]) -> [WordData] {
        var resultArray = [WordData]()
        
        // 該当する優先度の英単語を配列に追加
        for item in wordData {
            if targetNumbers.contains(item.priorityNumber) {
                resultArray.append(item)
            }
        }
        return resultArray
    }
}
