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
    
    static var editScreenWidth: CGFloat = 0
    static var editScreenheight: CGFloat = 0
    
    private var Images: [SampleView] = []
    func addImages(image: SampleView) {
        Images.append(image)
    }
    
    func getImages() -> [SampleView]{
        return Images
    }
    
    func deleteImage(image: SampleView){
        Images.removeAll(where: { $0.frame == image.frame})
        
    }
}
