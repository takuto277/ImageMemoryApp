//
//  ResultPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/06.
//

import Foundation

class ResultPresenter {
    var view: ResultViewControllerProtocol?
    private let dataBaseRepository: DataBaseRepositoryProtocol
    private let learnResult: LearnResult
    private var today: String = ""
    
    init(dataBaseRepository: DataBaseRepositoryProtocol, learnResult: LearnResult) {
        self.dataBaseRepository = dataBaseRepository
        self.learnResult = learnResult
    }
}

extension ResultPresenter: ResultProtocol {
    func attach(_ view: ResultViewControllerProtocol) {
        self.view = view
    }
    
    func getScore() {
        self.view?.setScoreData(learnResult: self.learnResult)
    }
    
    func getDate() {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        self.today = df.string(from: Date())
    }
    
    func getLearningHistoryArray() {
        var historyDays = self.dataBaseRepository.getLearningHistoryDays(year: String(self.today.prefix(4)))
        historyDays.append(today)
        self.view?.setHistoryDays(historyDays: historyDays)
    }
    
    func saveLearningHistory() {
        let learningHistoryData = LearningHistoryData(learningDay: self.today,
                                                      year: String(self.today.prefix(4)),
                                                      correctCount: self.learnResult.correctCount,
                                                      totalCount: self.learnResult.correctCount)
        Task {
            await self.dataBaseRepository.insertLearningHistory(learningHistoryData: learningHistoryData)
        }
    }
}
