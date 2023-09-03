//
//  CatalogPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/03.
//

import Foundation

class CatalogPresenter {
    var view: CatalogViewControllerProtocol?
    let dataBaseRepository: DataBaseRepositoryProtocol
    
    init(dataBaseRepository: DataBaseRepositoryProtocol) {
        self.dataBaseRepository = dataBaseRepository
    }
}

extension CatalogPresenter: CatalogProtocol {
    func attachView(_ view: CatalogViewControllerProtocol) {
        self.view = view
    }
    
    func getAllWordData() {
        var wordsData = [WordData]()
        do {
            wordsData = try dataBaseRepository.getAllWordData()
        } catch {
            print("全てのWordDataを取得できなかった")
        }
        self.view?.fetchAllWordData(wordsData)
    }
}

