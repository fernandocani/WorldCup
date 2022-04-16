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
    
    class func publish(stadiums: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        let saveOperation = CKModifyRecordsOperation(recordsToSave: stadiums,
                                                     recordIDsToDelete: nil)
        print("publishing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    callback(.success("CKStadium: \(#function) \(stadiums.count) stadiums"))
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
    
    class func fetch() async -> Result<[CKStadiumEntity], WCError> {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: RecordTypes.stadiums, predicate: predicate)
        print("fetching...")
        if #available(iOS 15.0, *) {
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
                        //DispatchQueue.main.async {
                        //    callback(.success(temp))
                        //    return .success(temp)
                        //}
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
    
    class func removeAll(by ids: [CKRecord.ID], callback: @escaping (Bool) -> ()) {
        let saveOperation = CKModifyRecordsOperation(recordsToSave: nil,
                                                     recordIDsToDelete: ids)
        print("removing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    print("CKStadium: ", #function, "\(ids.count) stadiums")
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

struct CKStadiumEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var capacity: Int = 0
    var city: String = ""
    var index: Int = 0
}
