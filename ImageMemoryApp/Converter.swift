//
//  Converter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/08/06.
//

import Foundation
import UIKit

struct Converter {
    // UIImageをBase64エンコードして文字列に変換する関数
    func encodeImageToBase64(_ image: UIImage) -> String? {
        if let imageData = image.jpegData(compressionQuality: 1.0) {
            let base64String = imageData.base64EncodedString()
            return base64String
        }
        return nil
    }
    
    // Base64エンコードされた文字列からUIImageを作成する関数
    func decodeBase64ToImage(_ base64String: String) -> UIImage? {
        if let imageData = Data(base64Encoded: base64String) {
            if let image = UIImage(data: imageData) {
                return image
            }
        }
        return nil
    }
}
