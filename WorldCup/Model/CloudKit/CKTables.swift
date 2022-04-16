//
//  CKTables.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

enum CKTablesRecordKeys {
    static let id              = "id"
    static let draw            = "draw"
    static let goalsAgainst    = "goalsAgainst"
    static let goalsDifference = "goalsDifference"
    static let goalsFor        = "goalsFor"
    static let lost            = "lost"
    static let played          = "played"
    static let points          = "points"
    static let teamID          = "teamID"
    static let won             = "won"
}

class CKTables {
    
    static let database = CKContainer(identifier: Constants.cloudKitContainerIdentifier).publicCloudDatabase
    
    class func publish(tables: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        let saveOperation = CKModifyRecordsOperation(recordsToSave: tables,
                                                     recordIDsToDelete: nil)
        print("publishing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    callback(.success("CKTables: \(#function) \(tables.count) tables"))
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        } else {
            saveOperation.modifyRecordsCompletionBlock = { _, _, _ in
                print(#function, "Fernando saved to DISCOVER")
            }
        }
        database.add(saveOperation)
    }
    
    class func fetch() async -> Result<[CKTablesEntity], WCError> {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.tables, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        print("fetching...")
        if #available(iOS 15.0, *) {
            let itens: [CKTablesEntity] = await withCheckedContinuation { continuation in
                var temp = [CKTablesEntity]()
                operation.recordMatchedBlock = { (recordId, result) in
                    switch result {
                    case let .success(record):
                        //print(record)
                        var item = CKTablesEntity()
                        item.recordID        = record.recordID
                        item.id              = record[CKTablesRecordKeys.id] as! String
                        item.draw            = record[CKTablesRecordKeys.draw] as! Int
                        item.goalsAgainst    = record[CKTablesRecordKeys.goalsAgainst] as! Int
                        item.goalsDifference = record[CKTablesRecordKeys.goalsDifference] as! Int
                        item.goalsFor        = record[CKTablesRecordKeys.goalsFor] as! Int
                        item.lost            = record[CKTablesRecordKeys.lost] as! Int
                        item.played          = record[CKTablesRecordKeys.played] as! Int
                        item.points          = record[CKTablesRecordKeys.points] as! Int
                        item.teamID          = record[CKTablesRecordKeys.teamID] as! String
                        item.won             = record[CKTablesRecordKeys.won] as! Int
                        temp.append(item)
                    case let .failure(error):
                        // if a single record failed to get fetched, you would see why here.
                        print("something went wrong recordMatchedBlock \(error.localizedDescription)")
                    }
                }
                operation.queryResultBlock = { result in
                    //print("CKStad queryCompletionBlock: Jobs done!")
                    switch result {
                    case .success(_):
                        print("the query was successful")
                    case let .failure(error):
                        print("Something went wrong queryResultBlock \(error.localizedDescription)")
                    }
                    continuation.resume(returning: temp)
                }
                database.add(operation)
            }
            return .success(itens)
        } else {
            return .failure(.ParseFailed)
        }
    }
    
    class func removeAll(by ids: [CKRecord.ID]) async -> Result<Bool, WCError> {
        print("removing...")
        if #available(iOS 15.0, *) {
            let result: Result<Void, Error> = await withCheckedContinuation { continuation in
                let saveOperation = CKModifyRecordsOperation(recordsToSave: nil,
                                                             recordIDsToDelete: ids)
                saveOperation.modifyRecordsResultBlock = { result in
                    continuation.resume(returning: result)
                }
                database.add(saveOperation)
            }
            switch result {
            case .success(_):
                return .success(true)
            case .failure(_):
                return .failure(.ParseFailed)
            }
        } else {
            return .failure(.ParseFailed)
        }
    }
    
}

struct CKTablesEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var teamID: String = ""
    var points: Int = 0
    var played: Int = 0
    var won: Int = 0
    var lost: Int = 0
    var draw: Int = 0
    var goalsAgainst: Int = 0
    var goalsFor: Int = 0
    var goalsDifference: Int = 0
}
