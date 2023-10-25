//
//  ResultViewController.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/06.
//

import UIKit
import FSCalendar

class ResultViewController: UIViewController {
    private let presenter: ResultPresenter
    private var historyDays: [String] = []
    
    init(presenter: ResultPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var totalScore: UILabel!
    @IBOutlet weak var calendar: FSCalendar!
    
    @IBAction func finishButtonPushed(_ sender: Any) {
        self.presenter.saveLearningHistory()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.attach(self)
        self.presenter.getScore()
        self.presenter.getDate()
        self.presenter.getLearningHistoryArray()
        calendar.delegate = self
        calendar.dataSource = self
        calendar.backgroundColor = UIColor(named: "gold")
        navigationItem.hidesBackButton = true
    }
}

extension ResultViewController: ResultViewControllerProtocol {
    func setScoreData(learnResult: LearnResult) {
        self.score.text = learnResult.correctCount
        self.totalScore.text = learnResult.totalCount
    }
    
    func setHistoryDays(historyDays: [String]) {
        self.historyDays = historyDays
    }
}

extension ResultViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let df = DateFormatter()
        df.dateFormat = "yyyy/MM/dd"
        if self.historyDays.first(where: { $0 == df.string(from: date) }) != nil {
            return 1
        }
        return 0
    }
}
