//
//  DetailWordProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/09.
//

import Foundation

protocol DetailWordProtocol: AnyObject {
    func attachView(_ view: DetailWordViewControllerProtocol)
    func saveWordData(_ wordData: WordData)
}

protocol DetailWordViewControllerProtocol: AnyObject {
    func dismissScreen()
}
