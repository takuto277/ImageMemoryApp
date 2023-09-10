//
//  SelectImage.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/10.
//

import Foundation

struct SearchImageModel:Codable{
    let hits:[Hits]
}

struct Hits:Codable {
    let webformatURL:String
}
