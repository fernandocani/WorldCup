//
//  MainViewModel.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import Foundation

final class MainViewModel {
    
    private var coreData = CoreDataManager.shared
    
    var onUpdate = {}
    var onErrorHandling: ((WCError) -> Void) = { _ in }
    
    func setDB() {
        self.coreData.createFirstDB()
        //if self.coreData.createFirstDB() {
        //    print("createFirstDB success")
        //    //self.getDB()
        //}
    }
    
    /// Clear DB to help debugging
    func deleteAll() {
        if self.coreData.deleteAllRecords() {
            //self.teams.removeAll()
            //self.groups.removeAll()
            //self.stadiums.removeAll()
            print("####################")
            print("removido com sucesso")
            print("####################")
        }
        //self.locations.removeAll()
    }
    
}

extension String {
    
    func toDate(dateFormat: String = "dd/MM/yyyy HH:mm") -> Date? {
        ///print(TimeZone.knownTimeZoneIdentifiers)
        let timeZone = TimeZone(identifier: "Asia/Qatar")
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat
        formatter.timeZone = timeZone
        formatter.locale = Locale(identifier: "pt_BR")
        return formatter.date(from: self)
    }
    
}

extension Int {
    
    func getGroupID() -> String? {
        switch self {
        case 1: return "A"
        case 2: return "B"
        case 3: return "C"
        case 4: return "D"
        case 5: return "E"
        case 6: return "F"
        case 7: return "G"
        case 8: return "H"
        default: return nil
        }
    }
    
}
