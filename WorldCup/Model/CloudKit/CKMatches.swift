//
//  CKMatches.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

enum CKMatchesRecordKeys {
    static let id           = "id"
    static let date         = "date"
    static let goalsAway    = "goalsAway"
    static let goalsHome    = "goalsHome"
    static let type         = "type"
}

class CKMatches {
    
    static let database = CKContainer(identifier: Constants.cloudKitContainerIdentifier).publicCloudDatabase
    
    class func publish(matches: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        fatalError("falta implementar")
        let saveOperation = CKModifyRecordsOperation(recordsToSave: matches,
                                                     recordIDsToDelete: nil)
        print("publishing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    callback(.success("CKMatches: \(#function) \(matches.count) matches"))
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
    
    class func fetch(callback: @escaping (Result<[CKMatchesEntity], WCError>) -> Void) {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.matches, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        var temp = [CKMatchesEntity]()
        print("fetching...")
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { (recordId, result) in
                switch result {
                case let .success(record):
                    //print(record)
                    var item = CKMatchesEntity()
                    item.recordID   = record.recordID
                    item.id         = record[CKMatchesRecordKeys.id] as! String
                    item.date       = record[CKMatchesRecordKeys.date] as! Date
                    item.goalsAway  = record[CKMatchesRecordKeys.goalsAway] as! Int
                    item.goalsHome  = record[CKMatchesRecordKeys.goalsHome] as! Int
                    item.type       = record[CKMatchesRecordKeys.type] as! String
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
                    //print("the query was successful")
                    DispatchQueue.main.async {
                        callback(.success(temp))
                    }
                case let .failure(error):
                    print("Something went wrong queryResultBlock \(error.localizedDescription)")
                }
            }
            database.add(operation)
        } else {
            callback(.failure(.ParseFailed))
        }
    }
}

struct CKMatchesEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var date: Date = Date()
    var goalsAway: Int = 0
    var goalsHome: Int = 0
    var type: String = ""
}
