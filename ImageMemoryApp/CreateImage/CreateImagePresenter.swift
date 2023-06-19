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
        //現在の画像を取得
        //
        //TODO: テスト用で後で削除
        let hoge = SampleView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 100, height: 100))
        let fuga = SampleView(frame: CGRect(x: 0, y: 0, width: 100, height: 100))
        let arrayhoge:[SampleView] = [hoge, fuga, hoge, hoge]
        //----
        self.view?.setImageOnEditScreenView(images: arrayhoge)
    }
}
