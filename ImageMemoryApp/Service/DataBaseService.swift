//
//  DataBaseService.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/05.
//

import Foundation
import SQLite3

struct WordData {
    let imageURL: String
    let wordName: String
    let number: Int
}

final class DataBaseService {
    static let shared = DataBaseService()
    
    private let dbFile = "DBVer1.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true))
    }
    
    private func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory,
                                                   in: .userDomainMask,
                                                   appropriateFor: nil,
                                                   create: false).appendingPathComponent(dbFile)
        
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("Failed to open database")
            return nil
        }
        else {
            print("Opened connection to database")
            return db
        }
    }
    
    private func createTable() -> Bool {
        let createSql = """
      CREATE TABLE IF NOT EXISTS wordData (
          imageURL TEXT NOT NULL,
      wordName TEXT NOT NULL,
      
          number INTEGER NOT NULL PRIMARY KEY
      );
      """
        
        var createStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (createSql as NSString).utf8String, -1, &createStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        if sqlite3_step(createStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(createStmt)
            return false
        }
        
        sqlite3_finalize(createStmt)
        return true
    }
    
    private func getDBErrorMessage(_ db: OpaquePointer?) -> String {
        if let err = sqlite3_errmsg(db) {
            return String(cString: err)
        } else {
            return ""
        }
    }
    
    func insertStudent(wordData: WordData) -> Bool {
        let insertSql = """
                        INSERT INTO students
                            (imageURL, wordName, number)
                            VALUES
                            (?, ?, ?);
                        """;

        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(insertStmt, 1, (wordData.imageURL as NSString).utf8String, -1, nil)
        sqlite3_bind_text(insertStmt, 2, (wordData.wordName as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertStmt, 3,Int32(wordData.number))
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    func updateStudent(wordData: WordData) -> Bool {
        let updateSql = """
        UPDATE  movieData
        SET     imageURL = ?,
                wordName = ?,
                number = ?
        WHERE   number = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }

        sqlite3_bind_text(updateStmt, 1, (wordData.imageURL as NSString).utf8String, -1, nil)

        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(updateStmt)
            return false
        }
        sqlite3_finalize(updateStmt)
        return true
    }
    
    func getWordData(number: Int) -> (success: Bool, errorMessage: String?, wordData: WordData?) {
     
        var wordData: WordData? = nil
        
        let sql = """
            SELECT  imageURL, wordName, number
            FROM    wordData
            WHERE   number = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", wordData)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(number))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let imageURL = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
            let wordName = String(describing: String(cString: sqlite3_column_text(stmt, 1)))
            let number = Int(sqlite3_column_int(stmt, 2))
            
            wordData = WordData(imageURL: imageURL, wordName: wordName, number: number)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, wordData)
    }
    
    func deleteWordData(number: Int) -> Bool {
        let deleteSql = "DELETE FROM wordData WHERE number = ?;";
        var deleteStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (deleteSql as NSString).utf8String, -1, &deleteStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_int(deleteStmt, 1,Int32(number))
        
        if sqlite3_step(deleteStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(deleteStmt)
            return false
        }

        sqlite3_finalize(deleteStmt)
        return true
    }
}
