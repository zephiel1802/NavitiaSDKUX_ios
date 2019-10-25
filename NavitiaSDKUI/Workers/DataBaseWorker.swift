//
//  DataBaseWorker.swift
//  NavitiaSDKUI
//
//  Copyright © 2019 kisio. All rights reserved.
//

import Foundation
import SQLite3

class DataBaseWorker {

    var db: OpaquePointer?
    
    func connection() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("JourneysDatabase.sqlite")
        
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("SQLITE : error opening database")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS autocompletion (id INTEGER PRIMARY KEY AUTOINCREMENT, coverage TEXT, name TEXT, idNavitia TEXT UNIQUE, type INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : error creating table: \(errmsg)")
        }
    }
    
    func saveHistoryItem(coverage: String, name: String, id: String, type: String) {
        if let tab = readValues(coverage: coverage), tab.count >= Configuration.maxHistory {
            if let id = getMinId(coverage: coverage) {
                removeID(id: id)
            }
        }
        
        // Getting values from textfields
        let coverage = coverage.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let idNavitia = id.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let type = type.trimmingCharacters(in: .whitespacesAndNewlines) as NSString

        // Creating a statement
        var stmt: OpaquePointer?
        
        // The insert query
        let queryString = "INSERT INTO autocompletion (coverage, name, idNavitia, type) VALUES (?, ?, ?, ?);"
        
        // Preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : error preparing insert: \(errmsg)")
            return
        }
        
        // Binding the parameters
        if sqlite3_bind_text(stmt, 1, coverage.utf8String, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, name.utf8String, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, idNavitia.utf8String, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 4, type.utf8String, -1, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }

        // Executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure inserting hero: \(errmsg)")
            return
        }
    }
    
    func remove() -> Bool {
        let queryString = "DELETE FROM autocompletion"
        
        // Statement pointer
        var stmt:OpaquePointer?
        
        // Preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            if sqlite3_step(stmt) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
                return false
            }
        } else {
            print("DELETE statement could not be prepared")
            return false
        }

        sqlite3_finalize(stmt)
        
        return true
    }
    
    func readValues(coverage: String) -> [AutocompletionHistory]? {
        // This is our select query
        let queryString = String(format: "SELECT * FROM autocompletion WHERE coverage = '%@' ORDER BY id DESC", coverage)
        
        // Statement pointer
        var stmt:OpaquePointer?
        
        // Preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return nil
        }
        
        var journeysList = [AutocompletionHistory]()
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let id = String(cString: sqlite3_column_text(stmt, 0))
            let coverage = String(cString: sqlite3_column_text(stmt, 1))
            let name = String(cString: sqlite3_column_text(stmt, 2))
            let idNavitia = String(cString: sqlite3_column_text(stmt, 3))
            let type = String(cString: sqlite3_column_text(stmt, 4))
            
            journeysList.append(AutocompletionHistory(id: Int(id) ?? 0,
                                           coverage: String(describing: coverage),
                                           name: String(describing: name),
                                           idNavitia: String(describing: idNavitia),
                                           type: String(describing: type)))
        }
        
        sqlite3_finalize(stmt)
        
        return journeysList
    }
    
    private func getMinId(coverage: String) -> Int32? {
        // This is our select query
        let queryString = String(format: "SELECT min(id) FROM autocompletion WHERE coverage = '%@'", coverage)

        var stmt:OpaquePointer?

        if sqlite3_prepare_v2(db, queryString, -1, &stmt, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return nil
        }
        
        while(sqlite3_step(stmt) == SQLITE_ROW) {
            let test = sqlite3_column_int(stmt, 0)
            return test
        }
        
        sqlite3_finalize(stmt)
        
        return nil
    }
    
    private func removeID(id: Int32) {
        let deleteStatementStirng = "DELETE FROM autocompletion WHERE id = ?;"
        
        var deleteStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, deleteStatementStirng, -1, &deleteStatement, nil) == SQLITE_OK {
            
            sqlite3_bind_int(deleteStatement, 1, id)
            
            if sqlite3_step(deleteStatement) == SQLITE_DONE {
                print("Successfully deleted row.")
            } else {
                print("Could not delete row.")
            }
        } else {
            print("DELETE statement could not be prepared")
        }
    }
}
