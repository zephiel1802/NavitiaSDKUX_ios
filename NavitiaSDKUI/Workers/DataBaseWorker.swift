//
//  DataBaseWorker.swift
//  NavitiaSDKUI
//
//  Created by Flavien Sicard on 14/02/2019.
//

import Foundation
import SQLite3

class DataBaseWorker {

    var db: OpaquePointer?
    var journeysList = [Journeysss]()
    
    func connection() {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent("JourneysDatabase.sqlite")

        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            print("SQLITE : error opening database")
        } else {
            print("SQLITE : OK OK data")
        }
        
        if sqlite3_exec(db, "CREATE TABLE IF NOT EXISTS autocompletion (coverage TEXT, name TEXT, idNavitia TEXT UNIQUE, type INTEGER)", nil, nil, nil) != SQLITE_OK {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : error creating table: \(errmsg)")
        } else {
            print("SQLITE : OK OK Table")
        }
    }
    
    func buttonSave(coverage: String, name: String, id: String, type: String) {
        //getting values from textfields
        let coverage = coverage.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let name = name.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let idNavitia = id.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        let type = type.trimmingCharacters(in: .whitespacesAndNewlines) as NSString
        

        
        //creating a statement
        var stmt: OpaquePointer?
        
        //the insert query
        let queryString = "INSERT INTO autocompletion (coverage, name, idNavitia, type) VALUES (?, ?, ?, ?);"
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : error preparing insert: \(errmsg)")
            return
        }
        
        //binding the parameters
        if sqlite3_bind_text(stmt, 1, coverage.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 2, name.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 3, idNavitia.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }
        
        if sqlite3_bind_text(stmt, 4, type.utf8String, -1, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure binding name: \(errmsg)")
            return
        }

        //executing the query to insert values
        if sqlite3_step(stmt) != SQLITE_DONE {
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("SQLITE : failure inserting hero: \(errmsg)")
            return
        }
        
        
        readValues()
        
        //displaying a success message
        print("SQLITE : Journeys saved successfully")
    }
    
    func readValues()  {
        
        //first empty the list of heroes
        journeysList.removeAll()
        
        //this is our select query
        let queryString = "SELECT * FROM autocompletion"
        
        //statement pointer
        var stmt:OpaquePointer?
        
        //preparing the query
        if sqlite3_prepare(db, queryString, -1, &stmt, nil) != SQLITE_OK{
            let errmsg = String(cString: sqlite3_errmsg(db)!)
            print("error preparing insert: \(errmsg)")
            return
        }
        
        //traversing through all the records
        while(sqlite3_step(stmt) == SQLITE_ROW){
            let coverage = String(cString: sqlite3_column_text(stmt, 0))
            let name = String(cString: sqlite3_column_text(stmt, 1))
            let idNavitia = String(cString: sqlite3_column_text(stmt, 2))
            let type = String(cString: sqlite3_column_text(stmt, 3))
            
            //adding values to list
            journeysList.append(Journeysss(id: 0,
                                           coverage: String(describing: coverage),
                                           name: String(describing: name),
                                           idNavitia: String(describing: idNavitia),
                                           type: String(describing: type)))
        }
        
    }
}

class Journeysss {
    
    var id: Int
    let coverage: String
    let name: String
    let idNavitia: String
    let type: String
    
    init(id: Int, coverage: String, name: String, idNavitia: String, type: String) {
        self.id = id
        self.coverage = coverage
        self.name = name
        self.idNavitia = idNavitia
        self.type = type
    }
}
