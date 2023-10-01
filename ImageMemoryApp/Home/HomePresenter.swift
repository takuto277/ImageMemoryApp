//
//  HomePresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/02.
//

import Foundation

class HomePresenter {
    var view: HomeViewControllerProtocol?
}

extension HomePresenter: HomeProtocol {
    func attachView(_ view: HomeViewControllerProtocol) {
        self.view = view
    }
    
    func getLearnWordData() {
        <#code#>
    }
    
    
}
