//
//  CreateImageViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/05/27.
//

import UIKit

protocol EditDetailWordViewControllerDelegate: AnyObject {
    func didDismissViewController(_ viewController: UIViewController)
}

class CreateImageViewController: UIViewController {
    private let presenter: CreateImageProtocol
    
    init(presenter: CreateImageProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: CreateImageViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
// MARK: - IBOutlet
    
    @IBOutlet weak var wordTextField: UITextField!
    @IBOutlet weak var editScreenFrame: UIImageView!
    @IBOutlet weak var editScreenView: UIView! {
        didSet {
            ImageEditScreen.editScreenWidth = editScreenView.frame.width
            ImageEditScreen.editScreenheight = editScreenView.frame.height
        }
    }
    
 // MARK: - IBAction
    
    @IBAction func pushAddImageButton(_ sender: Any) {
        let selectImageViewController = ViewControllerFactory.selectImageViewController()
        navigationController?.pushViewController(selectImageViewController, animated: true)
    }
    
    @IBAction func createdButton(_ sender: Any) {
        // 英単語のバリデーションチェック
        guard let wordName = wordTextField.text,
              !wordName.isEmpty else {
            DispatchQueue.main.async {
                let alert = UIAlertController(title: "英単語を入力してください", message: nil, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                self.present(alert, animated: true, completion: nil)
            }
            return
        }
        
        // 親ビューの範囲を取得
        guard let parentView = self.editScreenView.superview else {
            return
        }
        
        // 詳細画面に遷移前にスクリーンショットを取得
        UIGraphicsBeginImageContextWithOptions(parentView.frame.size, false, 0.0)
        parentView.drawHierarchy(in: parentView.bounds, afterScreenUpdates: true)
        let screenShotImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        
        // 詳細画面に遷移
        let editDetailWordViewController = ViewControllerFactory.editdetailWordViewController(wordName, screenShotImage, "", self)
        navigationController?.pushViewController(editDetailWordViewController, animated: true)
    }
    
// MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        presenter.attachView(self)
        presenter.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        presenter.viewWillAppear()
    }
}

 // MARK: - Protocol

extension CreateImageViewController: CreateImageViewProtocol {
    func setImageOnEditScreenView(images: [SampleView]) {
        for view in images {
            self.editScreenView.addSubview(view)
            view.parentVC = self
            
        }
    }
}

extension CreateImageViewController: EditDetailWordViewControllerDelegate {
    func didDismissViewController(_ viewController: UIViewController) {
        if viewController is EditDetailWordViewController {
            self.wordTextField.text = ""
            ImageEditScreen.shared.deleteImageAll()
            self.editScreenView.subviews.forEach { subView in
                subView.removeFromSuperview()
            }
        }
    }
}
