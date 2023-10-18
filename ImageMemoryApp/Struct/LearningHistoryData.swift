//
//  LearningHistoryData.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/10/19.
//

import Foundation

struct LearningHistoryData: Codable {
    let learningDay: String
    let year: String
    let correctCount: String
    let totalCount: String
    var correctRate: String {
        let correctCount = correctCount == "0" ? "1" : correctCount
        let totalCount = totalCount == "0" ? "1" : totalCount
        return String((Int(correctCount) ?? 1) * 100 / (Int(totalCount) ?? 1))
    }
}
