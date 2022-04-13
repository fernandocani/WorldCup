//
//  CKGroups.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

enum CKGroupsRecordKeys {
    static let id       = "id"
    static let name     = "name"
    static let index    = "index"
}

class CKGroups {
    
    static let database = CKContainer(identifier: Constants.cloudKitContainerIdentifier).publicCloudDatabase
    
    class func publish(groups: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        let saveOperation = CKModifyRecordsOperation(recordsToSave: groups,
                                                     recordIDsToDelete: nil)
        print("publishing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    callback(.success("CKGroups: \(#function) \(groups.count) groups"))
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
    
    class func fetch(callback: @escaping (Result<[CKGroupsEntity], WCError>) -> Void) {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.groups, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        var temp = [CKGroupsEntity]()
        print("fetching...")
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { (recordId, result) in
                switch result {
                case let .success(record):
                    //print(record)
                    var item = CKGroupsEntity()
                    item.recordID   = record.recordID
                    item.id         = record[CKGroupsRecordKeys.id] as! String
                    item.name       = record[CKGroupsRecordKeys.name] as! String
                    item.index      = record[CKGroupsRecordKeys.index] as! Int
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
                    print("CKGroups: ", #function, "\(ids.count) groups")
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

struct CKGroupsEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var index: Int = 0
}
