//
//  DetailWordProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/30.
//

import Foundation

protocol DetailWordProtocol: AnyObject {
    func attachView(_ view: DetailWordViewControllerProtocol)
    func getWordData()
    func decideButtonPushed()
    func editButtonPushed()
}

protocol DetailWordViewControllerProtocol: AnyObject {
    func attachData(_ wordData: WordData, editButtonHidden: Bool)
    func navigationWithDismiss()
    func navigationWithPopView()
    func navigationForEditDetailWordVC(wordData: WordData)
}
