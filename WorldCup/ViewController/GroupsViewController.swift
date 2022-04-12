//
//  GroupsViewController.swift
//  WorldCup
//
//  Created by Fernando Cani on 03/04/22.
//

import UIKit

class GroupsViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: GroupsViewModel!
    
    required init() {
        super.init(nibName: String(describing: GroupsViewController.self), bundle: nil)
        self.viewModel = GroupsViewModel(delegate: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Groups"
        self.fetch()
    }
    
    func fetch() {
        self.viewModel.fetchData()
    }

}

extension GroupsViewController: UITableViewDataSource {
    
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
        guard let groups = self.viewModel.fetchedResulsController?.fetchedObjects else { return cell }
        let item = groups[indexPath.row]
        guard let name = item.name,
              let teams = item.teams?.allObjects as? [TeamEntity] else { return cell }
        cell.textLabel?.text = "\(name) - \(teams.count)"
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

extension GroupsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let groups = self.viewModel.fetchedResulsController?.fetchedObjects else { return }
        let vc = GroupDetailViewController(groupIndex: groups[indexPath.row].index)
        self.navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension GroupsViewController: GroupsViewModelDelegate {
    
    func dataDidUpdate() {
        self.tableView.reloadData()
    }
    
}
