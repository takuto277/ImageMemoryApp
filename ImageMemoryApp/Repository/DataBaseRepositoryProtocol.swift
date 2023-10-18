//
//  DataBaseRepositoryProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/03.
//

import Foundation

protocol DataBaseRepositoryProtocol: AnyObject {
    func getAllWordData() throws -> [WordData]
    func getWordDataCount() throws -> Int
    func getLearningWordData() throws -> [WordData]
    func updateLearningWordData(_ wordDataArray: [WordData]) throws -> Bool
    func insertWordData(wordData: WordData) -> Bool
    func insertLearningHistory(learningHistoryData: LearningHistoryData) async
    func getLearningHistoryDays(year: String) -> [String]
}
