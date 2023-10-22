//
//  DataBaseRepository.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/03.
//

import Foundation

class DataBaseRepository {
    let dataBaseService: DataBaseService = DataBaseService.shared
}

extension DataBaseRepository: DataBaseRepositoryProtocol {
    func getAllWordData() -> [WordData] {
        do {
            return try dataBaseService.getAllWordData()
        } catch {
            return []
        }
    }
    
    func getWordDataCount() throws -> Int {
        return dataBaseService.getWordDataCount()
    }
    
    func getLearningWordData() -> [WordData] {
        do {
            return try dataBaseService.getLearningWordData()
        } catch {
            return []
        }
    }
    
    func updateLearningWordData(_ wordDataArray: [WordData]) -> Bool {
        do {
            return try dataBaseService.updateLearningWordData(wordDataArray)
        } catch {
            return false
        }
    }
    
    func insertWordData(wordData: WordData) -> Bool {
        return dataBaseService.insertWordData(wordData: wordData)
    }
    
    func updateWordData(wordData: WordData) -> Bool {
        return dataBaseService.updateWordData(wordData: wordData)
    }
}
