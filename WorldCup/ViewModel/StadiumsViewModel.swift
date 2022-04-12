//
//  StadiumsViewModel.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

import Foundation
import CoreData

protocol StadiumsViewModelDelegate: AnyObject {
    func dataDidUpdate()
}

final class StadiumsViewModel: NSObject {
    
    private var coreData = CoreDataManager.shared
    var fetchedResulsController: NSFetchedResultsController<StadiumEntity>?
    weak var delegate: StadiumsViewModelDelegate?
    
    init(delegate: StadiumsViewModelDelegate) {
        super.init()
        self.delegate = delegate
        self.setFetchedResultsController()
    }
    
    private func setFetchedResultsController() {
        let request = NSFetchRequest<StadiumEntity>(entityName: "StadiumEntity")
        let sort = NSSortDescriptor(key: #keyPath(StadiumEntity.capacity), ascending: true)
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

extension StadiumsViewModel: NSFetchedResultsControllerDelegate {
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        self.delegate?.dataDidUpdate()
    }
    
}
