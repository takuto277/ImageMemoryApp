//
//  CropViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/05/27.
//
import UIKit
import CropViewController

class TrimmingImageViewController: NSObject {
    weak var owner: UIViewController?
    
    init(owner: UIViewController) {
        self.owner = owner
    }
}

extension TrimmingImageViewController: CropViewControllerDelegate {
    func open(image: UIImage) {
        let cropViewController = CropViewController(croppingStyle: .default, image: image)
        cropViewController.delegate = self
        owner?.present(cropViewController, animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        owner?.dismiss(animated: true)
    }
    
    func cropViewController(_ cropViewController: CropViewController, didCropToCircularImage image: UIImage, withRect cropRect: CGRect, angle: Int) {
        
    }
    
    func cropViewController(_ cropViewController: CropViewController, didFinishCancelled cancelled: Bool) {
        owner?.dismiss(animated: true)
    }
}
