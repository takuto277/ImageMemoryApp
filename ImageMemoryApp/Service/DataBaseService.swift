//
//  DataBaseService.swift
//  ImageMemoryApp
//
//  Created by 小野拓人 on 2023/07/05.
//

import Foundation
import SQLite3

final class DataBaseService {
    static let shared = DataBaseService()
    
    private let dbFile = "DBVer1.sqlite"
    private var db: OpaquePointer?
    
    private init() {
        db = openDatabase()
        if !createTable() {
            print("Failed to create table")
        }
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
      CREATE TABLE IF NOT EXISTS movieData (
          image TEXT NOT NULL,
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
    
    func insertStudent(movieData: MovieData) -> Bool {
        let insertSql = """
                        INSERT INTO students
                            (image, number)
                            VALUES
                            (?, ?);
                        """;

        var insertStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (insertSql as NSString).utf8String, -1, &insertStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }
        
        sqlite3_bind_text(insertStmt, 1, (movieData.image as NSString).utf8String, -1, nil)
        sqlite3_bind_int(insertStmt, 2,Int32(movieData.number))
        
        if sqlite3_step(insertStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(insertStmt)
            return false
        }
        sqlite3_finalize(insertStmt)
        return true
    }
    
    func updateStudent(movieData: MovieData) -> Bool {
        let updateSql = """
        UPDATE  movieData
        SET     image = ?,
                number = ?
        WHERE   number = ?
        """
        var updateStmt: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, (updateSql as NSString).utf8String, -1, &updateStmt, nil) != SQLITE_OK {
            print("db error: \(getDBErrorMessage(db))")
            return false
        }

        sqlite3_bind_text(updateStmt, 1, (movieData.image as NSString).utf8String, -1, nil)

        if sqlite3_step(updateStmt) != SQLITE_DONE {
            print("db error: \(getDBErrorMessage(db))")
            sqlite3_finalize(updateStmt)
            return false
        }
        sqlite3_finalize(updateStmt)
        return true
    }
    
    func getStudent(number: Int) -> (success: Bool, errorMessage: String?, movieData: MovieData?) {
     
        var movieData: MovieData? = nil
        
        let sql = """
            SELECT  image, number
            FROM    movieData
            WHERE   number = ?;
            """
        
        var stmt: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, (sql as NSString).utf8String, -1, &stmt, nil) != SQLITE_OK {
            return (false, "Unexpected error: \(getDBErrorMessage(db)).", movieData)
        }
        
        sqlite3_bind_int(stmt, 1, Int32(number))
        
        if sqlite3_step(stmt) == SQLITE_ROW {
            let image = String(describing: String(cString: sqlite3_column_text(stmt, 0)))
            let number = Int(sqlite3_column_int(stmt, 1))
            
            movieData = MovieData(image: image, number: number)
        }
        
        sqlite3_finalize(stmt)
        return (true, nil, movieData)
    }
    
    func deleteStudent(number: Int) -> Bool {
        let deleteSql = "DELETE FROM movieData WHERE number = ?;";
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
