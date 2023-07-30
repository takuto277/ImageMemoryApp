//
//  CatalogViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/28.
//

import UIKit

class CatalogViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    init() {
        super.init(nibName: String(describing: CatalogViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: CatalogTableViewCell.self), bundle: nil), forCellReuseIdentifier: "CatalogTableViewCell")
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        cell.englishLabel.text = "english"
        cell.japaneseLabel.text = "japanese"
        cell.heartImageView.image = UIImage(named: "heart_gold")
        return cell
    }
}
