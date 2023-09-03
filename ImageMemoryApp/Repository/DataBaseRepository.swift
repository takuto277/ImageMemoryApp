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
}
