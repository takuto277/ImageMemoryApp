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
    
    
    // -----修正予定
    var searchImageManager = SearchImageManager()

    var hits: [Hits] = []
    private var imageArray: [String] = []

    private var count = 0
    
    // ------
    
    init(presenter: SelectImageProtocol) {
        self.presenter = presenter
        super.init(nibName: String(describing: SelectImageViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    
    
    @IBAction func pushSearchButton(_ sender: Any) {
        if let text = searchTextField.text {
            searchImageManager.getImages(with: text) { (hits) in
                guard let data = hits,
                      data.count != 0 else{
                    DispatchQueue.main.async {
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
                }

            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.collectionView.dataSource = self
        self.collectionView.delegate = self
        self.collectionView.register(UINib(nibName: String(describing: SelectImageCollectionViewCell.self), bundle: nil), forCellWithReuseIdentifier: "SelectImageCollectionViewCell")
    }
}

extension SelectImageViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
        if !self.imageArray.isEmpty{
            DispatchQueue.main.async {
                cell.imageView.sd_setImage(with: URL(string:self.imageArray[indexPath.row]), completed: nil)
            }
        }else{
            cell.imageView.image = UIImage(named: "sampleImage")
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "SelectImageCollectionViewCell", for: indexPath) as! SelectImageCollectionViewCell
       // cell.imageView.image = UIImage(named: "sampleImage")
        
        cell.imageView.sd_setImage(with: URL(string:self.imageArray[indexPath.row]),
                       completed: { (image, error,cacheType, url) in
                // here image is the UIImage
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

struct SearchImageModel:Codable{
    let hits:[Hits]
}

struct Hits:Codable {
    let webformatURL:String
}



struct SearchImageManager {
    func getImages(with keyword:String,completion:@escaping ([Hits]?) -> ()){
        //APIKey 22576227-26b7f5cefaed90131ae202127
        
        let urlString = "https://pixabay.com/api/?key=\(AccessTokens.share.pixabayAPIKey)&q=\(keyword)"

        //①URL型に変換
        if let url = URL(string: urlString) {

            //②URLSessionを作る
            let session = URLSession(configuration: .default)
            //③SessionTaskを与える
            let task = session.dataTask(with: url) { data, response, error in
                if error != nil {
                    print(error!)

                    completion(nil)
                }

                if let safeData = data {
                    // print(response)
                    let decoder = JSONDecoder()
                    do {
                        let decodedData = try decoder.decode(SearchImageModel.self, from: safeData)

                        completion(decodedData.hits)

                        //print(decodedData.hits[0].webformaturl)

                    } catch  {
                        print(String(describing: error))
                    }
                }
            }
            //④Taskを始める
            task.resume()
        }
    }
}
