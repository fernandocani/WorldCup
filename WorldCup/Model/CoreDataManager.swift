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
//        for value in EnumCountries.allCases {
//            if value.groupIndex != 99 {
//                let table: TableEntity = TableEntity(context: self.viewContext)
//
//                let team: TeamEntity = TeamEntity(context: self.viewContext)
//                team.name = value.name
//                team.rank = Int64(value.fifaRank)
//                team.table = table
//                team.groupIndex = Int64(value.groupIndex)
//
//                switch value {
//                case .qatar:        team.group = gA
//                case .ecuador:      team.group = gA
//                case .senegal:      team.group = gA
//                case .netherlands:  team.group = gA
//
//                case .englad:       team.group = gB
//                case .iran:         team.group = gB
//                case .usa:          team.group = gB
//                case .EUR:          team.group = gB
//
//                case .argentina:    team.group = gC
//                case .saudiArabia:  team.group = gC
//                case .mexico:       team.group = gC
//                case .poland:       team.group = gC
//
//                case .france:       team.group = gD
//                case .PL1:          team.group = gD
//                case .denmark:      team.group = gD
//                case .tunisia:      team.group = gD
//
//                case .spain:        team.group = gE
//                case .PL2:          team.group = gE
//                case .germany:      team.group = gE
//                case .japan:        team.group = gE
//
//                case .belgium:      team.group = gF
//                case .canada:       team.group = gF
//                case .morocco:      team.group = gF
//                case .croatia:      team.group = gF
//
//                case .brazil:       team.group = gG
//                case .serbia:       team.group = gG
//                case .switzerland:  team.group = gG
//                case .cameroon:     team.group = gG
//
//                case .portugal:     team.group = gH
//                case .ghana:        team.group = gH
//                case .uruguai:      team.group = gH
//                case .korea:        team.group = gH
//
//                default: break
//                }
//                self.viewContext.insert(team)
//            }
//        }
    }
    
    fileprivate func createStadiums() {
        // Create Stadiums
        //for value in EnumStadium.allCases {
        //    let item: StadiumEntity = StadiumEntity(context: self.viewContext)
        //    item.name = value.name
        //    item.capacity = Int64(value.capacity)
        //    item.city = value.location
        //    //self.viewContext.insert(item)
        //}
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

