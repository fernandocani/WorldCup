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
    static let index        = "index"
    static let date         = "date"
    static let goalsAway    = "goalsAway"
    static let goalsHome    = "goalsHome"
    static let type         = "type"
    static let teamHomeID   = "teamHomeID"
    static let teamAwayID   = "teamAwayID"
    static let stadiumID    = "stadiumID"
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
    
    class func fetch() async -> Result<[CKMatchesEntity], WCError> {
        let predicate = NSPredicate(value: true)
        //let predicate = NSPredicate(format: "%K == %@", RecordKeys.gender, "M")
        let query = CKQuery(recordType: RecordTypes.matches, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        print("fetching...")
        if #available(iOS 15.0, *) {
            let itens: [CKMatchesEntity] = await withCheckedContinuation { continuation in
                var temp = [CKMatchesEntity]()
                operation.recordMatchedBlock = { (recordId, result) in
                    switch result {
                    case let .success(record):
                        //print(record)
                        var item = CKMatchesEntity()
                        item.recordID   = record.recordID
                        item.id         = record[CKMatchesRecordKeys.id] as! String
                        item.teamAwayID = record[CKMatchesRecordKeys.teamAwayID] as! String
                        item.teamHomeID = record[CKMatchesRecordKeys.teamHomeID] as! String
                        item.stadiumID  = record[CKMatchesRecordKeys.stadiumID] as! String
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

struct CKMatchesEntity: Identifiable {
    var id: String = ""
    var recordID: CKRecord.ID?
    var index: Int = 0
    var teamHomeID: String = ""
    var teamAwayID: String = ""
    var stadiumID: String = ""
    var date: Date = Date()
    var goalsAway: Int = 0
    var goalsHome: Int = 0
    var type: String = ""
}

enum MatchesConstructor {
    case match01
    case match02
    case match03
    case match04
    case match05
    case match06
    case match07
    case match08
    case match09
    case match10
    case match11
    case match12
    case match13
    case match14
    case match15
    case match16
    case match17
    case match18
    case match19
    case match20
    case match21
    case match22
    case match23
    case match24
    case match25
    case match26
    case match27
    case match28
    case match29
    case match30
    case match31
    case match32
    case match33
    case match34
    case match35
    case match36
    case match37
    case match38
    case match39
    case match40
    case match41
    case match42
    case match43
    case match44
    case match45
    case match46
    case match47
    case match48
    case match49
    case match50
    case match51
    case match52
    case match53
    case match54
    case match55
    case match56
    case match57
    case match58
    case match59
    case match60
    case match61
    case match62
    case match63
    case match64
    
    var homeTeam: String {
        switch self {
        case .match01: return "A1"
        case .match02: return "A3"
        case .match03: return "B1"
        case .match04: return "B3"
        case .match05: return "D1"
        case .match06: return "D3"
        case .match07: return "C1"
        case .match08: return "C3"
        case .match09: return "F1"
        case .match10: return "E1"
        case .match11: return "E3"
        case .match12: return "F3"
        case .match13: return "G3"
        case .match14: return "H3"
        case .match15: return "H1"
        case .match16: return "G1"
            
        case .match17: return "B4"
        case .match18: return "A1"
        case .match19: return "A4"
        case .match20: return "B1"
        case .match21: return "D4"
        case .match22: return "C4"
        case .match23: return "D1"
        case .match24: return "C1"
        case .match25: return "E4"
        case .match26: return "F1"
        case .match27: return "F4"
        case .match28: return "E1"
        case .match29: return "G4"
        case .match30: return "H4"
        case .match31: return "G1"
        case .match32: return "H1"
            
        case .match33: return "B4"
        case .match34: return "B2"
        case .match35: return "A2"
        case .match36: return "A4"
        case .match37: return "D2"
        case .match38: return "D4"
        case .match39: return "C4"
        case .match40: return "C2"
        case .match41: return "F4"
        case .match42: return "F2"
        case .match43: return "E4"
        case .match44: return "E2"
        case .match45: return "H2"
        case .match46: return "H4"
        case .match47: return "G2"
        case .match48: return "G4"
            
        case .match49: return "1stA"
        case .match50: return "1stC"
        case .match51: return "1stB"
        case .match52: return "1stD"
        case .match53: return "1stE"
        case .match54: return "1stG"
        case .match55: return "1stF"
        case .match56: return "1stH"
            
        case .match57: return "W49"
        case .match58: return "W53"
        case .match59: return "W51"
        case .match60: return "W55"
            
        case .match61: return "W57"
        case .match62: return "W59"
            
        case .match63: return "L61"
            
        case .match64: return "W61"
        }
    }
    
    var awayTeam: String {
        switch self {
        case .match01: return "A2"
        case .match02: return "A4"
        case .match03: return "B2"
        case .match04: return "B4"
        case .match05: return "D2"
        case .match06: return "D4"
        case .match07: return "C4"
        case .match08: return "C2"
        case .match09: return "F2"
        case .match10: return "E2"
        case .match11: return "E4"
        case .match12: return "F4"
        case .match13: return "G4"
        case .match14: return "H4"
        case .match15: return "H2"
        case .match16: return "G2"
            
        case .match17: return "B2"
        case .match18: return "A3"
        case .match19: return "A2"
        case .match20: return "B3"
        case .match21: return "D2"
        case .match22: return "C2"
        case .match23: return "D3"
        case .match24: return "C3"
        case .match25: return "E2"
        case .match26: return "F3"
        case .match27: return "F2"
        case .match28: return "E3"
        case .match29: return "G2"
        case .match30: return "H2"
        case .match31: return "G3"
        case .match32: return "H3"
            
        case .match33: return "B1"
        case .match34: return "B3"
        case .match35: return "A3"
        case .match36: return "A1"
        case .match37: return "D3"
        case .match38: return "D1"
        case .match39: return "C1"
        case .match40: return "C3"
        case .match41: return "F1"
        case .match42: return "F3"
        case .match43: return "E1"
        case .match44: return "E3"
        case .match45: return "H3"
        case .match46: return "H1"
        case .match47: return "G3"
        case .match48: return "G1"
            
        case .match49: return "2stB"
        case .match50: return "2stD"
        case .match51: return "2stA"
        case .match52: return "2stC"
        case .match53: return "2stF"
        case .match54: return "2stH"
        case .match55: return "2stE"
        case .match56: return "2stG"
            
        case .match57: return "W50"
        case .match58: return "W54"
        case .match59: return "W52"
        case .match60: return "W56"
            
        case .match61: return "W58"
        case .match62: return "W60"
            
        case .match63: return "L62"
            
        case .match64: return "W62"
        }
    }
    
    var stadium: Int {
        switch self {
        case .match01: return 1
        case .match02: return 3
        case .match03: return 2
        case .match04: return 4
        case .match05: return 8
        case .match06: return 7
        case .match07: return 6
        case .match08: return 5
        case .match09: return 4
        case .match10: return 3
        case .match11: return 2
        case .match12: return 1
        case .match13: return 8
        case .match14: return 7
        case .match15: return 6
        case .match16: return 5
            
        case .match17: return 4
        case .match18: return 3
        case .match19: return 2
        case .match20: return 1
        case .match21: return 8
        case .match22: return 7
        case .match23: return 6
        case .match24: return 5
        case .match25: return 4
        case .match26: return 3
        case .match27: return 2
        case .match28: return 1
        case .match29: return 8
        case .match30: return 7
        case .match31: return 6
        case .match32: return 5
            
        case .match33: return 4
        case .match34: return 3
        case .match35: return 2
        case .match36: return 1
        case .match37: return 8
        case .match38: return 7
        case .match39: return 6
        case .match40: return 5
        case .match41: return 4
        case .match42: return 3
        case .match43: return 2
        case .match44: return 1
        case .match45: return 8
        case .match46: return 7
        case .match47: return 6
        case .match48: return 5
            
        case .match49: return 2
        case .match50: return 4
        case .match51: return 1
        case .match52: return 3
        case .match53: return 8
        case .match54: return 6
        case .match55: return 7
        case .match56: return 5
            
        case .match57: return 5
        case .match58: return 7
        case .match59: return 1
        case .match60: return 3
            
        case .match61: return 5
        case .match62: return 1
            
        case .match63: return 2
            
        case .match64: return 5
        }
    }
    
    var dateTime: String {
        switch self {
        case .match01: return "21/11/2022 19:00"
        case .match02: return "21/11/2022 13:00"
        case .match03: return "21/11/2022 16:00"
        case .match04: return "21/11/2022 22:00"
        case .match05: return "22/11/2022 22:00"
        case .match06: return "22/11/2022 16:00"
        case .match07: return "22/11/2022 19:00"
        case .match08: return "22/11/2022 13:00"
        case .match09: return "23/11/2022 22:00"
        case .match10: return "23/11/2022 19:00"
        case .match11: return "23/11/2022 16:00"
        case .match12: return "23/11/2022 13:00"
        case .match13: return "24/11/2022 13:00"
        case .match14: return "24/11/2022 16:00"
        case .match15: return "24/11/2022 19:00"
        case .match16: return "24/11/2022 22:00"
            
        case .match17: return "25/11/2022 13:00"
        case .match18: return "25/11/2022 16:00"
        case .match19: return "25/11/2022 19:00"
        case .match20: return "25/11/2022 22:00"
        case .match21: return "26/11/2022 13:00"
        case .match22: return "26/11/2022 16:00"
        case .match23: return "26/11/2022 19:00"
        case .match24: return "26/11/2022 22:00"
        case .match25: return "27/11/2022 13:00"
        case .match26: return "27/11/2022 16:00"
        case .match27: return "27/11/2022 19:00"
        case .match28: return "27/11/2022 22:00"
        case .match29: return "28/11/2022 13:00"
        case .match30: return "28/11/2022 16:00"
        case .match31: return "28/11/2022 19:00"
        case .match32: return "28/11/2022 22:00"
            
        case .match33: return "29/11/2022 22:00"
        case .match34: return "29/11/2022 22:00"
        case .match35: return "29/11/2022 18:00"
        case .match36: return "29/11/2022 18:00"
        case .match37: return "30/11/2022 18:00"
        case .match38: return "30/11/2022 18:00"
        case .match39: return "30/11/2022 22:00"
        case .match40: return "30/11/2022 22:00"
        case .match41: return "01/12/2022 18:00"
        case .match42: return "01/12/2022 18:00"
        case .match43: return "01/12/2022 22:00"
        case .match44: return "01/12/2022 22:00"
        case .match45: return "02/12/2022 18:00"
        case .match46: return "02/12/2022 18:00"
        case .match47: return "02/12/2022 22:00"
        case .match48: return "02/12/2022 22:00"
            //round of 16
        case .match49: return "03/12/2022 18:00"
        case .match50: return "03/12/2022 22:00"
        case .match51: return "04/12/2022 22:00"
        case .match52: return "04/12/2022 18:00"
        case .match53: return "05/12/2022 18:00"
        case .match54: return "05/12/2022 22:00"
        case .match55: return "06/12/2022 18:00"
        case .match56: return "06/12/2022 22:00"
            //round of 8
        case .match57: return "09/12/2022 22:00"
        case .match58: return "09/12/2022 18:00"
        case .match59: return "10/12/2022 22:00"
        case .match60: return "10/12/2022 18:00"
            //semifinals
        case .match61: return "13/12/2022 22:00"
        case .match62: return "14/12/2022 22:00"
            //3rd place
        case .match63: return "17/12/2022 18:00"
            //final
        case .match64: return "18/12/2022 18:00"
        }
    }
    
}
