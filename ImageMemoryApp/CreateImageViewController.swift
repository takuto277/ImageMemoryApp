//
//  CreateImageViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/05/27.
//

import UIKit

class CreateImageViewController: UIViewController {
    
    @IBOutlet weak var editScreenView: UIView!
    let sampleView = SampleView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 100, height: 100))

    override func viewDidLoad() {
        super.viewDidLoad()
        self.editScreenView.addSubview(sampleView)
    }
}

class SampleView: UIImageView {
    var ownTransform: CGAffineTransform!
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
        self.backgroundColor = UIColor.red
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
    @objc func longPressedObject(_ :UILongPressGestureRecognizer) {
        UIView.animate(withDuration: 0.5, delay: 1.0, animations: {
            self.transform = CGAffineTransform(scaleX: 2, y: 2)
        })
    }
}
