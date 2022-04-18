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
    
    class func publish(itens: [CKRecord]) async -> Result<Bool, WCError> {
        let result: Result<Void, Error> = await withCheckedContinuation { continuation in
            let saveOperation = CKModifyRecordsOperation(recordsToSave: itens,
                                                         recordIDsToDelete: nil)
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
    }
    
    class func fetch() async -> Result<[CKGroupsEntity], WCError> {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.groups.title, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        print("fetching...")
        let itens: [CKGroupsEntity] = await withCheckedContinuation { continuation in
            var temp = [CKGroupsEntity]()
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
                    print("the query was successful")
                case let .failure(error):
                    print("Something went wrong queryResultBlock \(error.localizedDescription)")
                }
                continuation.resume(returning: temp)
            }
            database.add(operation)
        }
        return .success(itens)
    }
    
    class func removeAll(by ids: [CKRecord.ID]) async -> Result<Bool, WCError> {
        print("removing...")
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
    }
    
}

struct CKGroupsEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var index: Int = 0
}
