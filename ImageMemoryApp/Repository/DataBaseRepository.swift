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
    func getAllWordData() throws -> [WordData] {
        do {
            return try dataBaseService.getAllWordData()
        } catch {
            throw myError.case1
        }
    }
    
    func getWordDataCount() throws -> Int {
        return dataBaseService.getWordDataCount()
    }
    
    func getLearningWordData() throws -> [WordData] {
        do {
            return try dataBaseService.getLearningWordData()
        } catch {
            throw myError.case1
        }
    }
    
    func updateLearningWordData(_ wordDataArray: [WordData]) throws -> Bool {
        do {
            return try dataBaseService.updateLearningWordData(wordDataArray)
        } catch {
            throw myError.case1
        }
    }
    
    func insertWordData(wordData: WordData) -> Bool {
        return dataBaseService.insertWordData(wordData: wordData)
    }
}
