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
       //     let priorityNumber = "WHEN number = " + "\(wordData.number)" + "THEN" + "'" + wordData.priorityNumber + "'"
            let priorityNumber = "WHEN number = \(wordData.number) THEN '\(wordData.priorityNumber)'"
            let proficiency = "WHEN number = \(wordData.number) THEN '\(wordData.proficiency)'"
            
            priorityNumberCase += " " + priorityNumber
            proficiencyCase += " " + proficiency
            numberCase += numberCase == "" ? String(wordData.number) : ", " + String(wordData.number)
        }
        print("🧩\(priorityNumberCase)")
        print("🧩\(proficiencyCase)")
        print("🧩\(numberCase)")
        
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
    
//    private let dbFile = "DBVer1.sqlite"
//    private var db: OpaquePointer?
//
//    private init() {
//        db = openDatabase()
//        if !createTable() {
//            print("Failed to create table")
//        }
//        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
//    }
//
//    private func openDatabase() -> OpaquePointer? {
//        let fileURL = try! FileManager.default.url(for: .documentDirectory,
//                                                   in: .userDomainMask,
//                                                   appropriateFor: nil,
//                                                   create: false).appendingPathComponent(dbFile)
//
//        var db: OpaquePointer? = nil
//        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
//            print("Failed to open database")
//            return nil
//        }
//        else {
//            print("Opened connection to database")
//            return db
//        }
//    }
//
//    private func createTable() -> Bool {
//        let createSql = """
//      CREATE TABLE IF NOT EXISTS wordData (
//        imageURL TEXT NOT NULL,
//        wordName TEXT NOT NULL,
//        number INTEGER NOT NULL PRIMARY KEY
//      );
//      """
//
//        var createStmt: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
//            print("db error: \(getDBErrorMessage(db))")
//            return false
//        }
//
//        if sqlite3_step(createStmt) != SQLITE_DONE {
//            print("db error: \(getDBErrorMessage(db))")
//            sqlite3_finalize(createStmt)
//            return false
//        }
//
//        sqlite3_finalize(createStmt)
//        return true
//    }
//
//    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
//        if let err = sqlite3_errmsg(db) {
//            return String(cString: err)
//        } else {
//            return ""
//        }
//    }
//
//    func insertWordData(wordData: WordData) -> Bool {
//        let insertSql = """
//                        INSERT INTO wordData
//                            (imageURL, wordName, number)
//                            VALUES
//                            (?, ?, ?);
//                        """;
//
//        var insertStmt: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
//            print("db error: \(getDBErrorMessage(db))")
//            return false
//        }
//
//        sqlite3_bind_text(insertStmt, 1, (wordData.imageURL as NSString).utf8String, -1, nil)
//        sqlite3_bind_text(insertStmt, 2, (wordData.wordName as NSString).utf8String, -1, nil)
//        sqlite3_bind_int(insertStmt, 3,Int32(wordData.number))
//
//        if sqlite3_step(insertStmt) != SQLITE_DONE {
//            print("db error: \(getDBErrorMessage(db))")
//            sqlite3_finalize(insertStmt)
//            return false
//        }
//        sqlite3_finalize(insertStmt)
//        return true
//    }
//
//    func updateWordData(wordData: WordData) -> Bool {
//        let updateSql = """
//        UPDATE  wordData
//        SET     imageURL = ?,
//                wordName = ?,
//                number = ?
//        WHERE   number = ?
//        """
//        var updateStmt: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
//            print("db error: \(getDBErrorMessage(db))")
//            return false
//        }
//
//        sqlite3_bind_text(updateStmt, 1, (wordData.imageURL as NSString).utf8String, -1, nil)
//
//        if sqlite3_step(updateStmt) != SQLITE_DONE {
//            print("db error: \(getDBErrorMessage(db))")
//            sqlite3_finalize(updateStmt)
//            return false
//        }
//        sqlite3_finalize(updateStmt)
//        return true
//    }
//
//    func getWordData(number: Int) -> (success: Bool, errorMessage: String?, wordData: WordData?) {
//
//        var wordData: WordData? = nil
//
//        let sql = """
//            SELECT  imageURL, wordName, number
//            FROM    wordData
//            WHERE   number = ?;
//            """
//
//        var stmt: OpaquePointer? = nil
//        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
//            return (false, "Unexpected error: \(getDBErrorMessage(db)).", wordData)
//        }
//
//        sqlite3_bind_int(stmt, 1, Int32(number))
//
//        if sqlite3_step(stmt) == SQLITE_ROW {
//            let imageURL = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
//            let wordName = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
//            let number = Int(sqlite3_column_int(stmt, 2))
//
//            wordData = WordData(imageURL: imageURL, wordName: wordName, number: number)
//        }
//
//        sqlite3_finalize(stmt)
//        return (true, nil, wordData)
//    }
//
//    func deleteWordData(number: Int) -> Bool {
//        let deleteSql = "DELETE FROM wordData WHERE number = ?;";
//        var deleteStmt: OpaquePointer? = nil
//
//        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
//            print("db error: \(getDBErrorMessage(db))")
//            return false
//        }
//
//        sqlite3_bind_int(deleteStmt, 1,Int32(number))
//
//        if sqlite3_step(deleteStmt) != SQLITE_DONE {
//            print("db error: \(getDBErrorMessage(db))")
//            sqlite3_finalize(deleteStmt)
//            return false
//        }
//
//        sqlite3_finalize(deleteStmt)
//        return true
//    }
//}
