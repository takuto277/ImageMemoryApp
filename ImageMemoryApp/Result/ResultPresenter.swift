//
//  ResultPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/06.
//

import Foundation

class ResultPresenter {
    var view: ResultViewControllerProtocol?
    private let learnResult: LearnResult
    
    init(learnResult: LearnResult) {
        self.learnResult = learnResult
    }
}

extension ResultPresenter: ResultProtocol {
    func getScore() {
        self.view?.setScoreData(learnResult: self.learnResult)
    }
    
    func getLearningHistory() {
        
    }
    
    func attach(_ view: ResultViewControllerProtocol) {
        self.view = view
    }
}
