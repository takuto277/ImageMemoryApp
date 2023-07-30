//
//  CreateImageViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/05/27.
//

import UIKit

class CreateImageViewController: UIViewController {
    private let presenter: CreateImageProtocol
    
    init(presenter: CreateImageProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: CreateImageViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var editScreenView: UIView! {
        didSet {
            ImageEditScreen.editScreenWidth = editScreenView.frame.width
            ImageEditScreen.editScreenheight = editScreenView.frame.height
        }
    }
    let sampleView = SampleView(frame: CGRect(x: UIScreen.main.bounds.width/2, y: UIScreen.main.bounds.height/2, width: 100, height: 100))
    
    
    @IBAction func pushAddImageButton(_ sender: Any) {
        let selectImageViewController = ViewControllerFactory.selectImageViewController()
        navigationController?.pushViewController(selectImageViewController, animated: true)
        
    }
    
    
    @IBAction func createdButton(_ sender: Any) {
      //  let data = try? JSONEncoder().encode(editImage)
        UIGraphicsBeginImageContextWithOptions(self.editScreenView.frame.size, false, 0.0)
      //  view.drawHierarchy(in: view.frame, afterScreenUpdates: true)
        self.editScreenView.drawHierarchy(in: self.editScreenView.frame, afterScreenUpdates: true)
        let screenShotImage:UIImage = UIGraphicsGetImageFromCurrentImageContext()!  //スリーンショットがUIImage型で取得できる
        UIGraphicsEndImageContext()
        
        guard let imageURL = self.encodeImageToBase64(screenShotImage) else { return }
        let wordData = WordData(imageURL: imageURL, wordName: "test", number: 1)
        if DataBaseService.shared.insertWordData(wordData: wordData) {
            print("登録成功")
        }
    }
    
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

extension CreateImageViewController: CreateImageViewProtocol {
    func setImageOnEditScreenView(images: [SampleView]) {
        for view in images {
            self.editScreenView.addSubview(view)
            view.parentVC = self
            
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

///------- 使用しなくなった選択型tableView-------------

//class OperationSelectView: UIView,UITableViewDelegate,UITableViewDataSource {
//    private var operateView: SampleView!
//    //スクリーンの横幅、縦幅を定義
//    let screenWidth = Int(UIScreen.main.bounds.size.width)
//    let screenHeight = Int(UIScreen.main.bounds.size.height)
//    //テーブルビューインスタンス作成
//    var tableView: UITableView  =   UITableView()
//
//    init(opetateView: SampleView) {
//        self.operateView = opetateView
//
//        super.init(frame: CGRect(x: ImageEditScreen.editScreenWidth - 100, y: ImageEditScreen.editScreenheight - 300, width: 100, height: 200))
//    }
//
//
//    func create() -> UIView {
//        self.backgroundColor = .blue
//        //cellに名前を付ける
//        self.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        //セパレーターの色を指定
//        self.tableView.separatorColor = UIColor.blue
//        //テーブルビューの設置場所を指定
//        tableView.frame = self.bounds
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        self.addSubview(tableView)
//        return self
//    }
//
//    //テーブルに表示するセル配列
//    var operationArray = ["拡大", "縮小", "右回転", "左回転", "削除", "閉じる"]
//
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return self.operationArray.count
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = UITableViewCell(style: UITableViewCell.CellStyle.default, reuseIdentifier: "cell")
//        cell.textLabel?.text = operationArray[indexPath.row]
//        return cell
//    }
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        switch indexPath.row {
//        case 0:
//            operateView.transform = CGAffineTransform(scaleX: 1.1, y: 1.1)
//        case 1:
//            operateView.transform = CGAffineTransform(scaleX: 0.9, y: 0.9)
//        case 2:
//            print("左回転")
//        case 3:
//            print("右回転")
//        case 4:
//            print("削除")
//
//        case 6:
//            print("閉じる")
//        default:
//            print("")
//        }
//    }
//}
