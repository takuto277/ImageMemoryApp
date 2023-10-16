//
//  SelectImagePresenter.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/06/01.
//

import Foundation

class SelectImagePresenter {
    var view: SelectImageViewControllerProtocol?
}

extension SelectImagePresenter: SelectImageProtocol {
    func attachView(_ view: SelectImageViewControllerProtocol) {
        self.view = view
    }
    
    func getImages(with keyword:String,completion:@escaping ([Hits]?) -> ()){
        
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
