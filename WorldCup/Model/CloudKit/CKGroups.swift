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
    
    class func fetch() async -> Result<[CKGroupsEntity], WCError> {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.groups, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        print("fetching...")
        if #available(iOS 15.0, *) {
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

struct CKGroupsEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var index: Int = 0
}

//extension Result where Success == Void {
//    public static func success() -> Self { .success(()) }
//}

//enum RemoveVoidResult {
//    case success
//    case failure(WCError)
//}
