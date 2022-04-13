//
//  CKTeams.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

enum CKTeamsRecordKeys {
    static let id               = "id"
    static let flag             = "flag"
    static let groupID          = "groupID"
    static let groupPosition    = "groupPosition"
    static let name             = "name"
    static let rank             = "rank"
    static let tableID          = "tableID"
}

class CKTeams {
    
    static let database = CKContainer(identifier: Constants.cloudKitContainerIdentifier).publicCloudDatabase
    
    class func publish(teams: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        let saveOperation = CKModifyRecordsOperation(recordsToSave: teams,
                                                     recordIDsToDelete: nil)
        print("publishing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    callback(.success("CKTeams: \(#function) \(teams.count) teams"))
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
    
    class func fetch(callback: @escaping (Result<[CKTeamsEntity], WCError>) -> Void) {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.teams, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        var temp = [CKTeamsEntity]()
        print("fetching...")
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { (recordId, result) in
                switch result {
                case let .success(record):
                    //print(record)
                    var item = CKTeamsEntity()
                    item.recordID       = record.recordID
                    item.id             = record[CKTeamsRecordKeys.id] as! String
                    item.name           = record[CKTeamsRecordKeys.name] as! String
                    item.flag           = record[CKTeamsRecordKeys.flag] as! String
                    item.groupID        = record[CKTeamsRecordKeys.groupID] as! String
                    item.groupPosition  = record[CKTeamsRecordKeys.groupPosition] as! Int
                    item.rank           = record[CKTeamsRecordKeys.rank] as! Int
                    item.tableID        = record[CKTeamsRecordKeys.tableID] as! String
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
    
    class func removeAll(by ids: [CKRecord.ID], callback: @escaping (Bool) -> ()) {
        let saveOperation = CKModifyRecordsOperation(recordsToSave: nil,
                                                     recordIDsToDelete: ids)
        print("removing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    print("CKTeams: ", #function, "\(ids.count) teams")
                    callback(true)
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
    
}

struct CKTeamsEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var flag: String = ""
    var groupID: String = ""
    var groupPosition: Int = 0
    var rank: Int = 0
    var tableID: String = ""
}
