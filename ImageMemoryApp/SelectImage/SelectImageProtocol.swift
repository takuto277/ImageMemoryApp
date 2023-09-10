//
//  SelectImageProtocol.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/01.
//

import Foundation

protocol SelectImageProtocol: AnyObject {
    func attachView(_ view: SelectImageViewControllerProtocol)
    func getImages(with keyword:String,completion:@escaping ([Hits]?) -> ())
}

protocol SelectImageViewControllerProtocol: AnyObject {
    
}
