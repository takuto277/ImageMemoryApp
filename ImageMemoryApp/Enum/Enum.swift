//
//  Enum.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/09/04.
//

import Foundation

/// 単語詳細画面にあるTextViewのタグ番号
enum EditDetailWordTextViewTag: Int {
    case englishWord = 1
    case japanWord = 2
    case englishSentence = 3
    case japanSentence = 4
}

enum DetailWordCalledFlg: Int {
    case Catalog
    case EditDetailWord
    case LearningEnglish
}

enum WordDataEnum {
    case englishWordName
    case japanWordName
    case englishSentence
    case japanSentence
    case proficiency
    case priorityNumber
    case number
    case deleteFlg
    case imageURL
}

enum UserSelectionFlg {
    case correct
    case incorrect
    case know
    case unknown
}

enum ProficiencyStatus: Int {
    case zero = 0
    case one
    case two
}

enum PriorityNumberStatus: Int {
    case zero = 0
    case one
    case two
    case three
    case four
    case five
    case six
    case seven
    case eight
    case nine
    case ten
}
