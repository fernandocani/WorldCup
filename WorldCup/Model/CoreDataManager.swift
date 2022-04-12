//
//  CoreDataManager.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import Foundation
import UIKit
import CoreData

enum WCError: Error {
    case ApiError(String)
    case ConvertURL
    case DataNil(String)
    case ParseFailed
    case DBEmpty
}

extension WCError: LocalizedError {
    public var errorDescription: String? {
        switch self {
        case .ApiError(_):  return NSLocalizedString("*WCError: Network error",        comment: "ApiError")
        case .ConvertURL:   return NSLocalizedString("*WCError: URL cannot be parsed", comment: "ConvertURL")
        case .DataNil:      return NSLocalizedString("*WCError: Response is empty",    comment: "DataNil")
        case .ParseFailed:  return NSLocalizedString("*WCError: Parse has failed",     comment: "ParseFailed")
        case .DBEmpty:      return NSLocalizedString("*WCError: DB is empty",          comment: "DBEmpty")
        }
    }
}

final class CoreDataManager {
    
    static let shared = CoreDataManager()
    
    private lazy var persistentContainer: NSPersistentContainer = {
        return (UIApplication.shared.delegate as! AppDelegate).persistentContainer
    }()
    var viewContext: NSManagedObjectContext {
        let context = self.persistentContainer.viewContext
        context.automaticallyMergesChangesFromParent = true
        return context
    }
    private var persistentContainerQueue: OperationQueue = {
        let queue = OperationQueue()
        queue.maxConcurrentOperationCount = 1
        return queue
    }()
    
    private init() { }

    func saveContext() -> Bool {
        let context = self.persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
                return true
            } catch {
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
        return false
    }
    
    // MARK: - Create
    
    fileprivate func createTeams() {
        let gA = GroupEntity(context: self.viewContext)
        gA.name = "Group A"
        gA.index = 1
        let gB = GroupEntity(context: self.viewContext)
        gB.name = "Group B"
        gB.index = 2
        let gC = GroupEntity(context: self.viewContext)
        gC.name = "Group C"
        gC.index = 3
        let gD = GroupEntity(context: self.viewContext)
        gD.name = "Group D"
        gD.index = 4
        let gE = GroupEntity(context: self.viewContext)
        gE.name = "Group E"
        gE.index = 5
        let gF = GroupEntity(context: self.viewContext)
        gF.name = "Group F"
        gF.index = 6
        let gG = GroupEntity(context: self.viewContext)
        gG.name = "Group G"
        gG.index = 7
        let gH = GroupEntity(context: self.viewContext)
        gH.name = "Group H"
        gH.index = 8
        
        // Create Teams
        for value in EnumCountries.allCases {
            if value.groupIndex != 99 {
                let table: TableEntity = TableEntity(context: self.viewContext)
                
                let team: TeamEntity = TeamEntity(context: self.viewContext)
                team.name = value.name
                team.rank = Int64(value.fifaRank)
                team.table = table
                team.groupIndex = Int64(value.groupIndex)
                
                switch value {
                case .qatar:        team.group = gA
                case .ecuador:      team.group = gA
                case .senegal:      team.group = gA
                case .netherlands:  team.group = gA
                    
                case .englad:       team.group = gB
                case .iran:         team.group = gB
                case .usa:          team.group = gB
                case .EUR:          team.group = gB
                    
                case .argentina:    team.group = gC
                case .saudiArabia:  team.group = gC
                case .mexico:       team.group = gC
                case .poland:       team.group = gC
                    
                case .france:       team.group = gD
                case .PL1:          team.group = gD
                case .denmark:      team.group = gD
                case .tunisia:      team.group = gD
                    
                case .spain:        team.group = gE
                case .PL2:          team.group = gE
                case .germany:      team.group = gE
                case .japan:        team.group = gE
                    
                case .belgium:      team.group = gF
                case .canada:       team.group = gF
                case .morocco:      team.group = gF
                case .croatia:      team.group = gF
                    
                case .brazil:       team.group = gG
                case .serbia:       team.group = gG
                case .switzerland:  team.group = gG
                case .cameroon:     team.group = gG
                    
                case .portugal:     team.group = gH
                case .ghana:        team.group = gH
                case .uruguai:      team.group = gH
                case .korea:        team.group = gH
                    
                default: break
                }
                self.viewContext.insert(team)
            }
        }
    }
    
    fileprivate func createStadiums() {
        // Create Stadiums
        for value in EnumStadium.allCases {
            let item: StadiumEntity = StadiumEntity(context: self.viewContext)
            item.name = value.name
            item.capacity = Int64(value.capacity)
            item.city = value.location
            //self.viewContext.insert(item)
        }
    }
    
    //@discardableResult
    func createFirstDB() {
        createTeams()
        createStadiums()
        print(saveContext())
    }
    
    // MARK: - Get
    
    //func getTeams() -> Result<[TeamEntity], WCError> {
    //    do {
    //        let request = NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
    //        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TeamEntity.rank), ascending: true),
    //                                   NSSortDescriptor(key: #keyPath(TeamEntity.groupIndex), ascending: true)]
    //        let itens = try self.viewContext.fetch(request)
    //        if itens.count > 0 {
    //            return .success(itens)
    //        } else {
    //            return .failure(WCError.DBEmpty)
    //        }
    //    } catch let error {
    //        return .failure(WCError.ApiError(error.localizedDescription))
    //    }
    //}
    
    func getTeamsByGroup(by index: Int64) -> Result<[TeamEntity], WCError> {
        do {
            let request = NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TeamEntity.groupIndex), ascending: true)]
            let predicate = NSPredicate(format: "%K == %i", #keyPath(TeamEntity.group.index), index)
            request.predicate = predicate
            let itens = try self.viewContext.fetch(request)
            if itens.count > 0 {
                return .success(itens)
            } else {
                return .failure(WCError.DBEmpty)
            }
        } catch let error {
            return .failure(WCError.ApiError(error.localizedDescription))
        }
    }
    
    func getGroups() -> Result<[GroupEntity], WCError> {
        do {
            let request = NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
            let sort = NSSortDescriptor(key: #keyPath(GroupEntity.index), ascending: true)
            request.sortDescriptors = [sort]
            let itens = try self.viewContext.fetch(request)
            if itens.count > 0 {
                return .success(itens)
            } else {
                return .failure(WCError.DBEmpty)
            }
        } catch let error {
            return .failure(WCError.ApiError(error.localizedDescription))
        }
    }
    
    func getStadiums() -> Result<[StadiumEntity], WCError> {
        do {
            let request = NSFetchRequest<StadiumEntity>(entityName: "StadiumEntity")
            request.sortDescriptors = [NSSortDescriptor(key: #keyPath(StadiumEntity.name), ascending: true),
                                       NSSortDescriptor(key: #keyPath(StadiumEntity.capacity), ascending: true)]
            let itens = try self.viewContext.fetch(request)
            if itens.count > 0 {
                return .success(itens)
            } else {
                return .failure(WCError.DBEmpty)
            }
        } catch let error {
            return .failure(WCError.ApiError(error.localizedDescription))
        }
    }
    
    // MARK: - Delete
    
    func deleteTeam(team: TeamEntity) -> Bool {
        let entities = self.persistentContainer.managedObjectModel.entities
        for entity in entities {
            guard let entityName = entity.name else { return false }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try viewContext.execute(deleteRequest)
            } catch {
                return false
            }
        }
        return self.saveContext()
    }
    
    /// Clear DB
    func deleteAllRecords() -> Bool {
        let entities = self.persistentContainer.managedObjectModel.entities
        for entity in entities {
            guard let entityName = entity.name else { return false }
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: entityName)
            let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
            do {
                try viewContext.execute(deleteRequest)
            } catch {
                return false
            }
        }
        return self.saveContext()
    }
    
}

// MARK: - Extension

extension CoreDataManager {
    
    /// Function to search asynchronous
    private func enqueue(block: @escaping (_ context: NSManagedObjectContext) -> Void) {
        self.persistentContainerQueue.addOperation() {
            let context: NSManagedObjectContext = self.persistentContainer.newBackgroundContext()
            context.performAndWait{
                block(context)
                try? context.save()
            }
        }
    }
    
}

extension CoreDataManager {
    
    enum EnumCountries: CaseIterable {
        //https://www.fifa.com/fifa-world-ranking
        //https://www.fifa.com/tournaments/mens/worldcup/qatar2022
        case argentina
        case belgium
        case brazil
        case canada
        case cameroon
        case croatia
        case denmark
        case ecuador
        case englad
        case france
        case germany
        case ghana
        case iran
        case japan
        case korea
        case morocco
        case mexico
        case netherlands
        case poland
        case portugal
        case qatar
        case saudiArabia
        case spain
        case senegal
        case serbia
        case switzerland
        case tunisia
        case usa
        case uruguai
        case EUR
        case PL1
        case PL2
        case wales
        case scotland
        case ukraine
        case peru
        case australia
        case arabEmirates
        case costaRica
        case newZeland

        var name: String {
            switch self {
            case .argentina:    return "Argentina"
            case .belgium:      return "Belgium"
            case .brazil:       return "Brazil"
            case .canada:       return "Canada"
            case .cameroon:     return "Cameroon"
            case .croatia:      return "Croatia"
            case .denmark:      return "Denmark"
            case .ecuador:      return "Ecuador"
            case .englad:       return "England"
            case .france:       return "France"
            case .germany:      return "Germany"
            case .ghana:        return "Ghana"
            case .iran:         return "IR Iran"
            case .japan:        return "Japan"
            case .korea:        return "Korea Republic"
            case .morocco:      return "Morocco"
            case .mexico:       return "Mexico"
            case .netherlands:  return "Netherland"
            case .poland:       return "Poland"
            case .portugal:     return "Portugal"
            case .qatar:        return "Qatar"
            case .saudiArabia:  return "Saudi Arabia"
            case .spain:        return "Spain"
            case .senegal:      return "Senegal"
            case .serbia:       return "Serbia"
            case .switzerland:  return "Switzerland"
            case .tunisia:      return "Tunisia"
            case .usa:          return "USA"
            case .uruguai:      return "Uruguai"
            case .EUR:          return "EUR - Gales/Scotland/Ukraine"
            case .PL1:          return "PL1 - Peru/Australia/United Arab Emirates"
            case .PL2:          return "PL2 - Costa Rica/New Zeland"
            case .wales:        return "Wales"
            case .scotland:     return "Scotland"
            case .ukraine:      return "Ukraine"
            case .peru:         return "Peru"
            case .australia:    return "Australia"
            case .arabEmirates: return "United Arab Emirates"
            case .costaRica:    return "Costa Rica"
            case .newZeland:    return "New Zeland"
            }
        }

        var fifaRank: Int {
            switch self {
            case .argentina:    return 4
            case .belgium:      return 2
            case .brazil:       return 1
            case .canada:       return 38
            case .cameroon:     return 37
            case .croatia:      return 16
            case .denmark:      return 11
            case .ecuador:      return 46
            case .englad:       return 5
            case .france:       return 3
            case .germany:      return 12
            case .ghana:        return 60
            case .iran:         return 21
            case .japan:        return 23
            case .korea:        return 29
            case .morocco:      return 24
            case .mexico:       return 9
            case .netherlands:  return 10
            case .poland:       return 26
            case .portugal:     return 8
            case .qatar:        return 51
            case .spain:        return 7
            case .senegal:      return 20
            case .serbia:       return 25
            case .saudiArabia:  return 49
            case .switzerland:  return 14
            case .tunisia:      return 35
            case .usa:          return 15
            case .uruguai:      return 13
            case .EUR:          return 999//"Gales/Scotland/Ukraine"
            case .PL1:          return 999//"Peru/Australia/United Arab Emirates 68"
            case .PL2:          return 999//"Costa Rica/New Zeland"
            case .wales:        return 18
            case .scotland:     return 39
            case .ukraine:      return 27
            case .peru:         return 22
            case .australia:    return 42
            case .arabEmirates: return 68
            case .costaRica:    return 31
            case .newZeland:    return 101
            }
        }
        
        var groupIndex: Int {
            switch self {
            case .qatar:        return 1
            case .ecuador:      return 2
            case .senegal:      return 3
            case .netherlands:  return 4
                
            case .englad:       return 1
            case .iran:         return 2
            case .usa:          return 3
            case .EUR:          return 4
                
            case .argentina:    return 1
            case .saudiArabia:  return 2
            case .mexico:       return 3
            case .poland:       return 4
                
            case .france:       return 1
            case .PL1:          return 2
            case .denmark:      return 3
            case .tunisia:      return 4
                
            case .spain:        return 1
            case .PL2:          return 2
            case .germany:      return 3
            case .japan:        return 4

            case .belgium:      return 1
            case .canada:       return 2
            case .morocco:      return 3
            case .croatia:      return 4
                
            case .brazil:       return 1
            case .serbia:       return 2
            case .switzerland:  return 3
            case .cameroon:     return 4
                
            case .portugal:     return 1
            case .ghana:        return 2
            case .uruguai:      return 3
            case .korea:        return 4
                
            default:            return 99
            }
        }
        
    }
    
    enum EnumStadium: CaseIterable {
        case alBayt
        case khalifaInternational
        case alThumama
        case ahmadBinAli
        case lusail
        case stadium974
        case educationCity
        case alJanoub
        
        var name: String {
            switch self {
            case .alBayt:               return "Al Bayt Stadium"
            case .khalifaInternational: return "Khalifa International Stadium"
            case .alThumama:            return "Al Thumama Stadium"
            case .ahmadBinAli:          return "Ahmad Bin Ali Stadium"
            case .lusail:               return "Lusail Stadium"
            case .stadium974:           return "Stadium 974"
            case .educationCity:        return "Education City Stadium"
            case .alJanoub:             return "Al Janoub Stadium"
            }
        }
        
        var capacity: Int {
            switch self {
            case .alBayt:               return 60000
            case .khalifaInternational: return 45416
            case .alThumama:            return 40000
            case .ahmadBinAli:          return 40000
            case .lusail:               return 80000
            case .stadium974:           return 40000
            case .educationCity:        return 40000
            case .alJanoub:             return 40000
            }
        }
        
        var location: String {
            switch self {
            case .alBayt:               return "Al Khor"
            case .khalifaInternational: return "Doha"
            case .alThumama:            return "Doha"
            case .ahmadBinAli:          return "Al Rayyan"
            case .lusail:               return "Lusail"
            case .stadium974:           return "Doha"
            case .educationCity:        return "Al Rayyan"
            case .alJanoub:             return "Al Wakrah"
            }
        }
    }
    
}
