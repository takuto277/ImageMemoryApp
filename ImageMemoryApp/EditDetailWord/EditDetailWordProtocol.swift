//
//  EditDetailWordProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/09.
//

import Foundation

protocol EditDetailWordProtocol: AnyObject {
    func attachView(_ view: EditDetailWordViewControllerProtocol)
    func saveWordData(_ wordData: WordData)
    func updateWordData(_ wordData: WordData)
}

protocol EditDetailWordViewControllerProtocol: AnyObject {
    func dismissScreen()
}
