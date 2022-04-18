//
//  CKStadium.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

enum CKStadiumRecordKeys {
    static let id       = "id"
    static let name     = "name"
    static let capacity = "capacity"
    static let city     = "city"
    static let index    = "index"
}

class CKStadium {
    //let container = CKContainer.default()
    //if let containerIdentifier = container.containerIdentifier {
    //    print(containerIdentifier)
    //}
    
    //static let database = CKContainer.default().publicCloudDatabase
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
    
    class func fetch() async -> Result<[CKStadiumEntity], WCError> {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordTypes.stadiums.title, predicate: predicate)
        print("fetching...")
        let itens: [CKStadiumEntity] = await withCheckedContinuation { continuation in
            var temp = [CKStadiumEntity]()
            let operation = CKQueryOperation(query: query)
            operation.recordMatchedBlock = { (recordId, result) in
                switch result {
                case let .success(record):
                    //print(record)
                    var item = CKStadiumEntity()
                    item.recordID   = record.recordID
                    item.id         = record[CKStadiumRecordKeys.id] as! String
                    item.name       = record[CKStadiumRecordKeys.name] as! String
                    item.city       = record[CKStadiumRecordKeys.city] as! String
                    item.capacity   = record[CKStadiumRecordKeys.capacity] as! Int
                    item.index      = record[CKStadiumRecordKeys.index] as! Int
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

struct CKStadiumEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var capacity: Int = 0
    var city: String = ""
    var index: Int = 0
}
