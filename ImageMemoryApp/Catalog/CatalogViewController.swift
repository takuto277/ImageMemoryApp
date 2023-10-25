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
        setDismissKeyboard()
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
        guard let wordData = wordsData?[indexPath.row] else {return UITableViewCell()}
        let cell = tableView.dequeueReusableCell(withIdentifier: "CatalogTableViewCell", for: indexPath) as! CatalogTableViewCell
        cell.englishLabel.text = wordData.englishWordName
        cell.japaneseLabel.text = wordData.japanWordName
        cell.heartImageView.image = UIImage(named: self.getHeartImage(
            proficiency: ProficiencyStatus(rawValue: Int(wordData.proficiency) ?? 0) ?? .zero,
            priorityNumber: PriorityNumberStatus(rawValue: Int(wordData.priorityNumber) ?? 0) ?? .zero
        ))
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let wordsData = wordsData?[indexPath.row] else { return }
        let detailWordViewController = ViewControllerFactory.detailWordViewController(wordsData, .Catalog)
        navigationController?.pushViewController(detailWordViewController, animated: true)
    }
    
    // 暫定としてここに実装
    // ハート画像を選択
    private func getHeartImage(proficiency: ProficiencyStatus, priorityNumber: PriorityNumberStatus) -> String {
        switch (proficiency, priorityNumber) {
        case (.two, _):
            return "heart_gold"
        case (.zero, .zero), (.one, .zero):
            return "heart_01"
        case (.zero, .one), (.one, .one):
            return "heart_02"
        case (.zero, .two), (.one, .two):
            return "heart_03"
        case (.zero, .three), (.one, .three):
            return "heart_04"
        case (.zero, .four), (.one, .four):
            return "heart_05"
        default:
            return "heart_06"
        }
    }
}

extension CatalogViewController: CatalogViewControllerProtocol {
    func fetchAllWordData(_ wordsDatas: [WordData]) {
        self.wordsData = wordsDatas
        self.tableView.reloadData()
    }
}
