//
//  SelectImageViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/05/27.
//

import UIKit
import SDWebImage

final class SelectImageViewController: UIViewController {
    private let presenter: SelectImageProtocol
    
    private var hits: [Hits] = []
    private var imageArray: [String] = []
    
    init(presenter: SelectImageProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: SelectImageViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - IBOutlet
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    // MARK: - IBAction
    
    @IBAction func pushSearchButton(_ sender: Any) {
        // ローディング開始
        self.startLoading(view: self.view)
        self.imageArray.removeAll()
        if let text = searchTextField.text {
            self.presenter.getImages(with: text) { (hits) in
                guard let data = hits,
                      data.count != 0 else{
                    DispatchQueue.main.async {
                        // ローディング終了
                        self.stopLoading(view: self.view)
                        let alert = UIAlertController(title: "検索にヒットしませんでした", message: nil, preferredStyle: .alert)
                        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
                        self.present(alert, animated: true, completion: nil)
                    }
                    return
                }
                self.hits = data
                self.hits.forEach({ hit in
                    self.imageArray.append(hit.webformatURL)
                })
                
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                    // ローディング終了
                    self.stopLoading(view: self.view)
                }
            }
        }
    }
    
    // MARK: - Life cycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: String(describing: SelectImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "SelectImageCollectionViewCell")
        
        self.presenter.attachView(self)
        setDismissKeyboard()
    }
    
    // MARK: - Private method
    
    private func displayPopupView() {
        if (view.subviews.first(where: { $0.tag == 999 }) == nil) {
            let popupView = UIView()
            popupView.layer.cornerRadius = 10
            popupView.frame = CGRect(x: 0, y: 0, width: 200, height: 150)
            popupView.center = view.center
            popupView.tag = 999
            
            let label = UILabel()
            label.text = "画像を検索してください"
            label.textColor = .white
            label.textAlignment = .center
            label.frame = CGRect(x: 0, y: 0, width: 220, height: 50)
            label.center = CGPoint(x: popupView.bounds.width / 2, y: popupView.bounds.height / 2)
            
            popupView.addSubview(label)
            view.addSubview(popupView)
        }
    }
    
    private func removePopupView() {
        // 画面内に配置されたUIViewを取得
        if let popupView = view.subviews.first(where: { $0.tag == 999 }) {
            // UIViewを親ビューから取り除く
            popupView.removeFromSuperview()
        }
    }
}

// MARK: - CollectionView

extension SelectImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if imageArray.isEmpty {
            self.displayPopupView()
            return 0
        } else {
            removePopupView()
            if imageArray.count <= 10 {
                return imageArray.count
            }
            return 10
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        if !self.imageArray.isEmpty{
            DispatchQueue.main.async {
                cell.imageView.sd_setImage(with: URL(string:self.imageArray[indexPath.row]), completed: nil)
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        cell.imageView.sd_setImage(with: URL(string:self.imageArray[indexPath.row]),
                                   completed: { (image, error,cacheType, url) in
            guard let image = image else { return }
            TrimmingImageViewController(owner: self).open(image: image)
        })
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        // 横方向のスペース調整
        let horizontalSpace:CGFloat = 5
        
        //セルのサイズを指定。画面上にセルを3つ表示させたいのであれば、デバイスの横幅を3分割した横幅　- セル間のスペース*2（セル間のスペースが二つあるため）
        let cellSize:CGFloat = self.view.bounds.width/3 - horizontalSpace*2
        
        // 正方形で返すためにwidth,heightを同じにする
        return CGSize(width: cellSize, height: cellSize)
    }
}

// MARK: - Protocol

extension SelectImageViewController: SelectImageViewControllerProtocol {
    
}
