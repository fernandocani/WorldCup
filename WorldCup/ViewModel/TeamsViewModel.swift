//
//  TeamsViewModel.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

import Foundation
import CoreData

protocol TeamsViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

final class TeamsViewModel: NSObject {
    
    private var coreData = CoreDataManager.shared
    var fetchedResulsController: NSFetchedResultsController<TeamEntity>?
    weak var delegate: TeamsViewModelDelegate?
    
    init(delegate: TeamsViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.setFetchedResultsController()
    }
    
    private func setFetchedResultsController() {
        let request = NSFetchRequest<TeamEntity>(entityName: "TeamEntity")
        request.sortDescriptors = [NSSortDescriptor(key: #keyPath(TeamEntity.rank), ascending: true),
                                   NSSortDescriptor(key: #keyPath(TeamEntity.groupIndex), ascending: true)]
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
        guard let team = self.fetchedResulsController?.object(at: indexPath) else { return }
        team.name = "**edited**"
        _ = self.coreData.saveContext()
    }
    
    func deleteData(at indexPath: IndexPath) {
        guard let team = self.fetchedResulsController?.object(at: indexPath) else { return }
        self.coreData.viewContext.delete(team)
        _ = self.coreData.saveContext()
    }
    
}

extension TeamsViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.dataDidUpdate()
    }
    
}
