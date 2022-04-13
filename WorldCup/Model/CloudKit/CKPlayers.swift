//
//  CKPlayers.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

enum CKPlayersRecordKeys {
    static let id       = "id"
    static let name     = "name"
    static let birth    = "birth"
    static let gender   = "gender"
}

class CKPlayers {
    
    static let database = CKContainer(identifier: Constants.cloudKitContainerIdentifier).publicCloudDatabase
    
    class func publish(players: [CKRecord], callback: @escaping (Result<String, WCError>) -> Void) {
        fatalError("falta implementar")
        //let recordToDiscover = CKRecord(recordType: RecordTypes.players)
        //recordToDiscover.setValue("Rafa",   forKey: CKPlayersRecordKeys.name)
        //recordToDiscover.setValue(Date(),   forKey: CKPlayersRecordKeys.birth)
        //recordToDiscover.setValue("F",      forKey: CKPlayersRecordKeys.gender)
        let saveOperation = CKModifyRecordsOperation(recordsToSave: players,
                                                     recordIDsToDelete: nil)
        print("publishing...")
        if #available(iOS 15.0, *) {
            saveOperation.modifyRecordsResultBlock = { result in
                switch result {
                case .success(_):
                    callback(.success("CKPlayers: \(#function) \(players.count) players"))
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
    
    class func fetch(callback: @escaping (Result<[CKPlayersEntity], WCError>) -> Void) {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.players, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        var temp = [CKPlayersEntity]()
        print("fetching...")
        if #available(iOS 15.0, *) {
            operation.recordMatchedBlock = { (recordId, result) in
                switch result {
                case let .success(record):
                    //print(record)
                    var item = CKPlayersEntity()
                    item.recordID   = record.recordID
                    item.id         = record[CKPlayersRecordKeys.id] as! String
                    item.name       = record[CKPlayersRecordKeys.name] as! String
                    item.gender     = record[CKPlayersRecordKeys.gender] as! String
                    item.birth      = record[CKPlayersRecordKeys.birth] as! Date
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

struct CKPlayersEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var name: String = ""
    var gender: String = ""
    var birth: Date = Date()
}
