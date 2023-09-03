//
//  CatalogViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/28.
//

import UIKit

class CatalogViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var presenter: CatalogProtocol?
    private var wordsData: [WordData]?
    
    init() {
        super.init(nibName: String(describing: CatalogViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter?.attachView(self)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.register(UINib(nibName: String(describing: CatalogTableViewCell.self), bundle: nil), forCellReuseIdentifier: "CatalogTableViewCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.presenter?.getAllWordData()
    }
}

extension CatalogViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.wordsData?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        cell.englishLabel.text = wordsData?[indexPath.row].englishWordName
        cell.japaneseLabel.text = wordsData?[indexPath.row].japanWordName
        cell.heartImageView.image = UIImage(named: "heart_gold")
        return cell
    }
}

extension CatalogViewController: CatalogViewControllerProtocol {
    func fetchAllWordData(_ wordsDatas: [WordData]) {
        self.wordsData = wordsDatas
        self.tableView.reloadData()
    }
}
