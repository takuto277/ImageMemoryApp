//
//  SampleView.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/10.
//

import Foundation
import UIKit
/*
 名前を変え忘れた、いい名前が思いつかない
 新しい画像を追加されてそれを表示するためのView
 */
class SampleView: UIImageView{
    var ownTransform: CGAffineTransform!
    var parentVC: UIViewController?
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.image = UIImage(named: "sampleImage")
        backgroundColor = .red
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panObject(_:))))
        addGestureRecognizer(UIPinchGestureRecognizer(target: self, action: #selector(pinchObject)))
        addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotateObject(_:))))
        addGestureRecognizer((UITapGestureRecognizer(target: self, action: #selector(tapObject(_:)))))
        addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPressedObject(_:))))
        self.isUserInteractionEnabled = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc func panObject(_ sender: UIPanGestureRecognizer) {
        if sender.state == .began {
            ownTransform = self.transform
        }
        self.transform = ownTransform.translatedBy(x: sender.translation(in: self).x, y: sender.translation(in: self).y)
    }
    
    @objc func tapObject(_ sender: UITapGestureRecognizer) {
        // 触れたViewを最上面に持ってくる
        sender.view?.superview?.bringSubviewToFront(sender.view!)
    }
    
    @objc func rotateObject(_ sender: UIRotationGestureRecognizer) {
        let rotation = sender.rotation
        if sender.state == .began {
            ownTransform = self.transform
        }
        self.transform = ownTransform.rotated(by: rotation)
    }
    
    @objc func pinchObject(_ sender: UIPinchGestureRecognizer) {
        if sender.state == .began {
            ownTransform = self.transform
        }
        self.transform = ownTransform.scaledBy(x: sender.scale, y: sender.scale)
    }
    
    @objc func longPressedObject(_ sender: UILongPressGestureRecognizer) {
        guard let parentVC = parentVC else { return }
        UIView.animate(withDuration: 0.5, delay: 1.0, animations: {
            
            let alert = UIAlertController(title: "削除しますが宜しいでしょうか？", message: nil, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "削除", style: .destructive, handler: { _ in
                self.isHidden = true
                ImageEditScreen.shared.deleteImage(image: self)
            }))
            alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
            parentVC.present(alert, animated: true, completion: nil)
        })
    }
}
