//
//  DataBaseService.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/05.
//

import Foundation
import SQLite3
import FMDB

enum myError: Error {
    case case1
}

/*
 englishWordName: 英単語の名前
 japanWordName: 日本での名前
 englishSentence: 英文
 japanSentence: 日本文
 proficiency: 習熟度フラグ(新単語:0, 学習中単語:1, 完了単語:2)
 priorityNumber: 学習する優先度(0~10)
 number: pk
 deleteFlg: 削除フラグ
 imageURL: 画像URLの文字列
 */
struct WordData {
    var englishWordName: String
    var japanWordName: String
    var englishSentence: String
    var japanSentence: String
    var proficiency: String
    var priorityNumber: String
    var number: Int = 0
    var deleteFlg: String
    var imageURL: String
    
    mutating func updateValues(valueName: WordDataEnum, newValue: String){
        switch valueName {
        case .englishWordName:
            self.englishWordName = newValue
        case .japanWordName:
            self.japanWordName = newValue
        case .englishSentence:
            self.englishSentence = newValue
        case .japanSentence:
            self.japanSentence = newValue
        case .proficiency:
            self.proficiency = newValue
        case .priorityNumber:
            self.priorityNumber = newValue
        case .number:
            guard let newValue = Int(newValue) else {
                break
            }
            self.number = newValue
        case .deleteFlg:
            self.deleteFlg = newValue
        case .imageURL:
            self.imageURL = newValue
            
        }
    }
}

final class DataBaseService {
    static let shared = DataBaseService()
    
    let database:FMDatabase?
    
    private init(){
        // データベースファイルのパスを取得
        let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first!.appending("/mydatabase.db")
        print(databasePath)
        
        // FMDatabaseオブジェクトを作成
        database = FMDatabase(path: databasePath)
        
        self.createTable()
    }
    
    private func createTable() {
        guard let database = self.database else { return }
        // データベースを開く
        if database.open() {
            // テーブルの作成
            let createTableSQL = """
        CREATE TABLE IF NOT EXISTS wordData (
                englishWordName TEXT NOT NULL,
                japanWordName TEXT NOT NULL,
                englishSentence TEXT NOUT NULL,
                japanSentence TEXT NOT NULL,
                proficiency TEXT NOT NULL,
                priorityNumber TEXT NOT NULL,
                number INTEGER NOT NULL PRIMARY KEY,
                deleteFlg TEXT NOT NULL,
                imageURL TEXT NOT NULL
        )
        """
            /*
             englishWordName: 英単語の名前
             japanWordName: 日本での名前
             englishSentence: 英文
             japanSentence: 日本文
             proficiency: 習熟度フラグ(新単語:0, 学習中単語:1, 完了単語:2)
             priorityNumber: 学習する優先度(0~10)
             number: pk
             deleteFlg: 削除フラグ
             imageURL: 画像URLの文字列
             */
            if database.executeUpdate(createTableSQL, withArgumentsIn: []) {
                print("テーブル作成成功")
            } else {
                print("テーブル作成失敗")
            }
        }
    }
    
    
    func insertWordData(wordData: WordData) -> Bool {
        guard let database = self.database else { return false}
        // データの挿入
        let insertSQL = """
        INSERT INTO wordData (
        englishWordName, japanWordName, englishSentence, japanSentence, proficiency, priorityNumber, number, deleteFlg, imageURL)
        VALUES (
        :englishWordName, :japanWordName, :englishSentence, :japanSentence, :proficiency, :priorityNumber, :number, :deleteFlg, :imageURL)
        """
        let param = ["englishWordName": wordData.englishWordName,
                     "japanWordName": wordData.japanWordName,
                     "englishSentence": wordData.englishSentence,
                     "japanSentence": wordData.japanSentence,
                     "proficiency": wordData.proficiency,
                     "priorityNumber": wordData.priorityNumber,
                     "number": wordData.number,
                     "deleteFlg": wordData.deleteFlg,
                     "imageURL": wordData.imageURL,] as [String : Any]
        if database.executeUpdate(insertSQL, withParameterDictionary: param as [AnyHashable : Any]) {
            print("データ挿入成功")
            return true
        } else {
            print("データ挿入失敗")
            return false
        }
    }
    
    func getWordData(number: Int) throws -> WordData {
        guard let database = self.database else {
            throw myError.case1
        }
        var wordData: WordData?
        // クエリの実行
        let querySQL = "SELECT * FROM wordData"
        if let resultSet = database.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                guard let englishWordName = resultSet.string(forColumn: "englishWordName"),
                      let japanWordName = resultSet.string(forColumn: "japanWordName"),
                      let englishSentence = resultSet.string(forColumn: "englishSentence"),
                      let japanSentence = resultSet.string(forColumn: "japanSentence"),
                      let proficiency = resultSet.string(forColumn: "proficiency"),
                      let priorityNumber = resultSet.string(forColumn: "priorityNumber"),
                      let deleteFlg = resultSet.string(forColumn: "deleteFlg"),
                      let imageURL = resultSet.string(forColumn: "imageURL") else {
                    throw myError.case1
                }
                let number = Int(resultSet.int(forColumn: "number"))
                wordData = WordData(englishWordName: englishWordName,
                                    japanWordName: japanWordName,
                                    englishSentence: englishSentence,
                                    japanSentence: japanSentence,
                                    proficiency: proficiency,
                                    priorityNumber: priorityNumber,
                                    number: number,
                                    deleteFlg: deleteFlg,
                                    imageURL: imageURL)
                
            }
        }
        guard let wordData = wordData else {
            throw myError.case1
            
        }
        return wordData
        
    }
    
    func getAllWordData() throws -> [WordData] {
        guard let database = self.database else {
            throw myError.case1
        }
        var wordDataArray = [WordData]()
        // クエリの実行
        let querySQL = "SELECT * FROM wordData"
        if let resultSet = database.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                guard let englishWordName = resultSet.string(forColumn: "englishWordName"),
                      let japanWordName = resultSet.string(forColumn: "japanWordName"),
                      let englishSentence = resultSet.string(forColumn: "englishSentence"),
                      let japanSentence = resultSet.string(forColumn: "japanSentence"),
                      let proficiency = resultSet.string(forColumn: "proficiency"),
                      let priorityNumber = resultSet.string(forColumn: "priorityNumber"),
                      let deleteFlg = resultSet.string(forColumn: "deleteFlg"),
                      let imageURL = resultSet.string(forColumn: "imageURL") else {
                    throw myError.case1
                }
                let number = Int(resultSet.int(forColumn: "number"))
                let wordData = WordData(englishWordName: englishWordName,
                                        japanWordName: japanWordName,
                                        englishSentence: englishSentence,
                                        japanSentence: japanSentence,
                                        proficiency: proficiency,
                                        priorityNumber: priorityNumber,
                                        number: number,
                                        deleteFlg: deleteFlg,
                                        imageURL: imageURL)
                wordDataArray.append(wordData)
                
            }
        }
        return wordDataArray
    }
    
    func getLearningWordData() throws -> [WordData] {
        guard let database = self.database else {
            throw myError.case1
        }
        var wordDataArray = [WordData]()
        // クエリの実行
        let querySQL = """
                        SELECT * FROM wordData
                        WHERE proficiency <> '2'
                        """
        if let resultSet = database.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                guard let englishWordName = resultSet.string(forColumn: "englishWordName"),
                      let japanWordName = resultSet.string(forColumn: "japanWordName"),
                      let englishSentence = resultSet.string(forColumn: "englishSentence"),
                      let japanSentence = resultSet.string(forColumn: "japanSentence"),
                      let proficiency = resultSet.string(forColumn: "proficiency"),
                      let priorityNumber = resultSet.string(forColumn: "priorityNumber"),
                      let deleteFlg = resultSet.string(forColumn: "deleteFlg"),
                      let imageURL = resultSet.string(forColumn: "imageURL") else {
                    throw myError.case1
                }
                let number = Int(resultSet.int(forColumn: "number"))
                let wordData = WordData(englishWordName: englishWordName,
                                        japanWordName: japanWordName,
                                        englishSentence: englishSentence,
                                        japanSentence: japanSentence,
                                        proficiency: proficiency,
                                        priorityNumber: priorityNumber,
                                        number: number,
                                        deleteFlg: deleteFlg,
                                        imageURL: imageURL)
                wordDataArray.append(wordData)
                
            }
        }
        return wordDataArray
    }
    
    func updateLearningWordData(_ wordDataArray: [WordData]) throws -> Bool {
        guard let database = self.database else {
            throw myError.case1
        }
        var priorityNumberCase = ""
        var proficiencyCase = ""
        var numberCase = ""
        wordDataArray.forEach { wordData in
            priorityNumberCase += " WHEN number = \(wordData.number) THEN '\(wordData.priorityNumber)'"
            proficiencyCase += " WHEN number = \(wordData.number) THEN '\(wordData.proficiency)'"
            numberCase += numberCase == "" ? String(wordData.number) : ", " + String(wordData.number)
        }
        
        let query = """
            UPDATE wordData
            SET
            priorityNumber = CASE
            \(priorityNumberCase)
            END,
            proficiency = CASE
            \(proficiencyCase)
            END
            WHERE
            number IN (\(numberCase));
            """
        
        return database.executeUpdate(query, withArgumentsIn: [])
    }
    
    func getWordDataCount() -> Int {
        var count = 0
        let querySQL = "SELECT COUNT (*) as count FROM wordData"
        if let resultSet = database?.executeQuery(querySQL, withArgumentsIn: []) {
            while resultSet.next() {
                count = Int(resultSet.int(forColumn: "count"))
            }
            return count
        }
        print("英単語数の取得失敗")
        return 0
    }
    
    func databaseClose() {
        guard let database = self.database else { return }
        // データベースを閉じる
        if !database.close() {
            print("データベースオープン失敗")
        }
    }
}
