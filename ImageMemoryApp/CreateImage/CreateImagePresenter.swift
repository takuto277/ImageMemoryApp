//
//  CreateImagePresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/01.
//

import Foundation
//TODO: 後で削除
import UIKit

class CreateImagePresenter {
    var view: CreateImageViewProtocol?
}

extension CreateImagePresenter: CreateImageProtocol {
    func attachView(_ view: CreateImageViewProtocol) {
        self.view = view
    }
    
    func viewDidLoad() {
    }
    
    func viewWillAppear() {
        //現在の画像を取得
        let arrayhoge:[SampleView] = ImageEditScreen.shared.getImages()
        self.view?.setImageOnEditScreenView(images: arrayhoge)
    }
}
