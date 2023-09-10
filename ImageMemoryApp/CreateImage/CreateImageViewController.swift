//
//  CreateImageViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/05/27.
//

import UIKit

protocol DetailWordViewControllerDelegate: AnyObject {
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
        let detailWordViewController = ViewControllerFactory.detailWordViewController(wordName, screenShotImage, "", self)
        navigationController?.pushViewController(detailWordViewController, animated: true)
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

extension CreateImageViewController: DetailWordViewControllerDelegate {
    func didDismissViewController(_ viewController: UIViewController) {
        if viewController is DetailWordViewController {
            self.wordTextField.text = ""
            ImageEditScreen.shared.deleteImageAll()
            self.editScreenView.subviews.forEach { subView in
                subView.removeFromSuperview()
            }
        }
    }
}

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
