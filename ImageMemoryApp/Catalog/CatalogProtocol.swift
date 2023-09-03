//
//  CatalogProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/03.
//

import Foundation

protocol CatalogProtocol: AnyObject {
    func attachView(_ view: CatalogViewControllerProtocol)
    func getAllWordData()
}

protocol CatalogViewControllerProtocol: AnyObject {
    func fetchAllWordData(_ wordsData: [WordData])
}
