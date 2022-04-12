//
//  GroupDetailViewModel.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

//import Foundation
//
//final class GroupDetailViewModel {
//
//    private var coreData = CoreDataManager.shared
//
//    var onUpdate = {}
//    var onErrorHandling: ((WCError) -> Void) = { _ in }
//
//    var name: String?
//    var id: Int64
//
//    init(name: String?, id: Int64) {
//        self.name = name
//        self.id = id
//    }
//
//    var teams: [TeamEntity] = [] {
//        didSet {
//            self.onUpdate()
//        }
//    }
//
//    func getTeams() {
//        let result = self.coreData.getTeamsByGroup(by: self.id)
//        switch result {
//        case .success(let item):
//            self.teams = item
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
//
//}

import Foundation
import CoreData

protocol GroupDetailViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

final class GroupDetailViewModel: NSObject {
    
    private var coreData = CoreDataManager.shared
    var fetchedResulsController: NSFetchedResultsController<TeamEntity>?
    weak var delegate: GroupDetailViewModelDelegate?
    
    init(delegate: GroupDetailViewModelDelegate, groupIndex: Int64) {
        super.init()
        self.delegate = delegate
        self.setFetchedResultsController(by: groupIndex)
    }
    
    private func setFetchedResultsController(by groupIndex: Int64) {
        let request = NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TeamEntity.groupIndex), ascending: true)]
        let predicate = NSPredicate(format: "%K == %i", #keyPath(TeamEntity.group.index), groupIndex)
        request.predicate = predicate
        self.fetchedResulsController = NSFetchedResultsController(fetchRequest: request,
                                                                  managedObjectContext: self.coreData.viewContext,
                                                                  sectionNameKeyPath: nil,
                                                                  cacheName: nil)
        self.fetchedResulsController?.delegate = self
    }
    
    func fetchData() {
        do {
            try self.fetchedResulsController?.performFetch()
        } catch {
            print("Erro fetching")
        }
    }
    
    func editData(at indexPath: IndexPath) {
        guard let item = self.fetchedResulsController?.object(at: indexPath) else { return }
        item.name = "**edited**"
        _ = self.coreData.saveContext()
    }
    
    func deleteData(at indexPath: IndexPath) {
        guard let item = self.fetchedResulsController?.object(at: indexPath) else { return }
        self.coreData.viewContext.delete(item)
        _ = self.coreData.saveContext()
    }
    
}

extension GroupDetailViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.dataDidUpdate()
    }
    
}
