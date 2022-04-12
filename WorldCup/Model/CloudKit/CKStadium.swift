//
//  CKStadium.swift
//  WorldCup
//
//  Created by Fernando Cani on 12/04/22.
//

import Foundation
import CloudKit

class CKStadium {
    //let container = CKContainer.default()
    //if let containerIdentifier = container.containerIdentifier {
    //    print(containerIdentifier)
    //}
    
    //static let database = CKContainer.default().publicCloudDatabase
    static let database = CKContainer(identifier: Constants.cloudKitContainerIdentifier).publicCloudDatabase

    @available(iOS 15.0, *)
    class func fetch() async throws -> [CKStadiumEntity] {
        let predicate = NSPredicate(value: true)
        let query = CKQuery(recordType: "CD_StadiumEntity", predicate: predicate)
        let operation = CKQueryOperation(query: query)
        //print("CKStad Let's go!")
        let items: [CKStadiumEntity] = await withCheckedContinuation { continuation in
            var temp = [CKStadiumEntity]()
            operation.recordMatchedBlock = { (recordId, result) in
                switch result {
                case let .success(record):
                    //print(record)
                    var stad = CKStadiumEntity()
                    stad.recordID   = record.recordID
                    stad.city       = record["CD_city"] as! String
                    stad.capacity   = record["CD_capacity"] as! Int
                    stad.name       = record["CD_name"] as! String
                    temp.append(stad)
                case let .failure(error):
                    // if a single record failed to get fetched, you would see why here.
                    print("something went wrong recordMatchedBlock \(error.localizedDescription)")
                }
            }
            operation.queryResultBlock = { result in
                //print("CKStad queryCompletionBlock: Jobs done!")
                switch result {
                case .success(_):
                    //print("the query was successful \(String(describing: cursor))")
                    continuation.resume(returning: temp)
                case let .failure(error):
                    print("Something went wrong queryResultBlock \(error.localizedDescription)")
                }
            }
            database.add(operation)
        }
        return items
    }
    
}

struct CKStadiumEntity: Identifiable {
    var id = UUID()
    var recordID: CKRecord.ID?
    var name: String = ""
    var capacity: Int = 0
    var city: String = ""
}
