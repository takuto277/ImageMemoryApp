//
//  UIViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/21.
//

import Foundation
import UIKit

extension UIViewController {
    
    /// キーボード解除機能セット
    func setDismissKeyboard() {
        let tapGR: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tapGR.cancelsTouchesInView = false
        self.view.addGestureRecognizer(tapGR)
    }
    
    /// キーボード解除
    @objc func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    /// ローディング開始
    func startLoading(view: UIView) {
        let activityIndicator = UIActivityIndicatorView(style: .large)
        activityIndicator.center = view.center
        activityIndicator.hidesWhenStopped = true
        activityIndicator.startAnimating()
        view.addSubview(activityIndicator)
    }
    
    /// ローディング終了
    func stopLoading(view: UIView) {
        for subview in view.subviews {
            if let activityIndicator = subview as? UIActivityIndicatorView {
                activityIndicator.stopAnimating()
                activityIndicator.removeFromSuperview()
            }
        }
    }
}






