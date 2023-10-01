//
//  HomeProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/02.
//

import Foundation

protocol HomeProtocol: AnyObject {
    func attachView(_ view: HomeViewControllerProtocol)
    func getLearnWordData()
}

protocol HomeViewControllerProtocol: AnyObject {
    func fetchLearnWordData(_ wordsData: [WordData], _ faceImageArray: [String])
}
