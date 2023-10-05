//
//  ResultPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/06.
//

import Foundation

class ResultPresenter {
    var view: ResultViewControllerProtocol?
}

extension ResultPresenter: ResultProtocol {
    func attach(_ view: ResultViewControllerProtocol) {
        self.view = view
    }
}
