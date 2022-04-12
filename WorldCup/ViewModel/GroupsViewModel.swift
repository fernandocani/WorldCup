//
//  GroupsViewModel.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

//final class GroupsViewModel {
//
//    private var coreData = CoreDataManager.shared
//
//    var onUpdate = {}
//    var onErrorHandling: ((WCError) -> Void) = { _ in }
//
//    var groups: [GroupEntity] = [] {
//        didSet {
//            self.onUpdate()
//        }
//    }
//
//    func getGroups() {
//        let result = self.coreData.getGroups()
//        switch result {
//        case .success(let item):
//            self.groups = item
//        case .failure(let error):
//            print(error.localizedDescription)
//        }
//    }
//
//}

import Foundation
import CoreData

protocol GroupsViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

final class GroupsViewModel: NSObject {
    
    private var coreData = CoreDataManager.shared
    var fetchedResulsController: NSFetchedResultsController<GroupEntity>?
    weak var delegate: GroupsViewModelDelegate?
    
    init(delegate: GroupsViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.setFetchedResultsController()
    }
    
    private func setFetchedResultsController() {
        let request = NSFetchRequest<GroupEntity>(entityName: "GroupEntity")
        let sort = NSSortDescriptor(key: #keyPath(GroupEntity.index), ascending: true)
        request.sortDescriptors = [sort]
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

extension GroupsViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.dataDidUpdate()
    }
    
}
