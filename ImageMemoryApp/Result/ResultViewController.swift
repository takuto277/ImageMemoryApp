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
    
    init(presenter: ResultPresenter) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @IBAction func finishButtonPushed(_ sender: Any) {
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        calendar.delegate = self
        calendar.dataSource = self
        navigationItem.hidesBackButton = true
    }
}

extension ResultViewController: ResultViewControllerProtocol {
    func setScoreData() {
        
    }
    
    
}

extension ResultViewController: FSCalendarDelegate, FSCalendarDataSource {
    
    func calendar(_ calendar: FSCalendar, numberOfEventsFor date: Date) -> Int {
        let df = DateFormatter()
        var eventArray = ["2023/10/04","2023/10/12","2023/10/18"]
        let today = Date()
        
        df.dateFormat = "yyyy/MM/dd"
        eventArray.append(df.string(from: today))
        if eventArray.first(where: { $0 == df.string(from: date) }) != nil {
                return 1
        }
        return 0
    }
}
