//
//  CreateImageProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/01.
//

import Foundation

protocol CreateImageProtocol: AnyObject {
    func attachView(_ view: CreateImageViewProtocol)
    func viewDidLoad()
}

protocol CreateImageViewProtocol: AnyObject {
    func setImageOnEditScreenView(images: [SampleView])
}
