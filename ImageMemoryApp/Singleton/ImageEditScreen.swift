//
//  ImageEditScreen.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/29.
//

import Foundation

final public class ImageEditScreen {
    private init() {}
    public static let shared = ImageEditScreen()
    
    private var Images: [SampleView] = []
    func addImages(image: SampleView) {
        Images.append(image)
    }
    
    func getImages() -> [SampleView]{
        return Images
    }
//    private var s: [String: Any] = ["Theme": "Vivid", "Brightness": 50]
//    public func keyString(forkey key: String) -> String? {
//        return settings[key] as? String
//    }
}
