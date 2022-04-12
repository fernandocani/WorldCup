//
//  GroupDetailViewController.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

import UIKit

class GroupDetailViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: GroupDetailViewModel!
    
    required init(groupIndex: Int64) {
        super.init(nibName: String(describing: GroupDetailViewController.self), bundle: nil)
        self.viewModel = GroupDetailViewModel(delegate: self, groupIndex: groupIndex)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //self.title = self.viewModel.name
        self.fetch()
    }
    
    func fetch() {
        self.viewModel.fetchData()
    }

}

extension GroupDetailViewController: UITableViewDataSource {
    
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
        guard let teams = self.viewModel.fetchedResulsController?.fetchedObjects else { return cell }
        let team = teams[indexPath.row]
        guard let name = team.name else { return cell }
        cell.textLabel?.text = "\(name)"
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

extension GroupDetailViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.viewModel.editData(at: indexPath)
    }
    
}

extension GroupDetailViewController: GroupDetailViewModelDelegate {
    
    func dataDidUpdate() {
        self.tableView.reloadData()
    }
    
}
