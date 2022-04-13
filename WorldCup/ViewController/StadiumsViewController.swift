//
//  StadiumsViewController.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

import UIKit

class StadiumsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: StadiumsViewModel!
    
    required init() {
        super.init(nibName: String(describing: StadiumsViewController.self), bundle: nil)
        self.viewModel = StadiumsViewModel(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Stadium"
        self.fetch(cloud: true)
    }
    
    func fetch(cloud: Bool) {
        if cloud {
            if #available(iOS 15.0, *) {
                CKStadium.fetch { result in
                    switch result {
                    case .success(let itens):
                        for item in itens {
                            print(item)
                        }
                    case .failure(let error):
                        print(error.localizedDescription)
                    }
                }
            }
        } else {
            self.viewModel.fetchData()
        }
    }
    
}

extension StadiumsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.fetchedResulsController?.fetchedObjects?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        //guard let cell = tableView.dequeueReusableCell(withIdentifier: LocationTableViewCell.identifier,
        //                                               for: indexPath) as? LocationTableViewCell else {
        //    return UITableViewCell()
        //}
        //let location = self.viewModel.locations[indexPath.row]
        //cell.setup(location: location)
        //return cell
        
        let cell = UITableViewCell()
        guard let stadiums = self.viewModel.fetchedResulsController?.fetchedObjects else { return cell }
        let item = stadiums[indexPath.row]
        guard let name = item.name else { return cell }
        cell.textLabel?.text = "\(name) - \(item.capacity)"
        return cell
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        self.viewModel.deleteData(at: indexPath)
    }
    
}

extension StadiumsViewController: UITableViewDelegate {
 
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.editData(at: indexPath)
    }
    
}

extension StadiumsViewController: StadiumsViewModelDelegate {
    
    func dataDidUpdate() {
        self.tableView.reloadData()
    }
    
}
