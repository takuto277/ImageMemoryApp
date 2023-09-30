//
//  DetailWordPresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/30.
//

import Foundation

class DetailWordPresenter {
    var view: DetailWordViewControllerProtocol?
}

extension DetailWordPresenter: DetailWordProtocol {
    func attachView(_ view: DetailWordViewControllerProtocol) {
        self.view = view
    }
}
