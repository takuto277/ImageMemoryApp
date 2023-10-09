//
//  ResultProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/06.
//

import Foundation

protocol ResultProtocol: AnyObject {
    func attach(_ view: ResultViewControllerProtocol)
    func getScore()
    func getLearningHistory()
}

protocol ResultViewControllerProtocol: AnyObject {
    func setScoreData()
}
