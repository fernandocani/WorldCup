//
//  SidebarViewController.swift
//  WorldCup
//
//  Created by Fernando Cani on 15/04/22.
//

import UIKit

class SidebarViewController: UIViewController {

    required init() {
        super.init(nibName: String(describing: SidebarViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private enum SidebarSection: Int {
        case tables, settings
    }
    
    private enum SidebarRowType: Int {
        case header, row
    }
    
    private enum TablesRows: Int {
        case stadium = 1, players, teams, tables, matches, groups
    }
    
    private struct SidebarItem: Hashable {
        let title: String
        let imageName: String?
        let type: SidebarRowType
    }
    
    private var collectionView: UICollectionView!
    private var datasource: UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
        self.configureCollection()
        self.updateDatasource()
    }

}

extension SidebarViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let row = TablesRows(rawValue: indexPath.row) else { return }
        switch row {
        case .stadium:
            if let navBar = splitViewController?.viewController(for: .secondary) as? UINavigationController,
                let _ = navBar.viewControllers.last as? StadiumsViewController {
                return
            }
            let nv = splitViewController?.viewController(for: .secondary) as? UINavigationController
            nv?.popToRootViewController(animated: true)
            nv?.pushViewController(StadiumsViewController(), animated: true)
            //self.splitViewController?.setViewController(StadiumsViewController(), for: .secondary)
        case .players:
            if let navBar = splitViewController?.viewController(for: .secondary) as? UINavigationController,
                let _ = navBar.viewControllers.last as? StadiumsViewController {
                return
            }
            let nv = splitViewController?.viewController(for: .secondary) as? UINavigationController
            nv?.popToRootViewController(animated: true)
            nv?.pushViewController(StadiumsViewController(), animated: true)
        case .teams:
            if let navBar = splitViewController?.viewController(for: .secondary) as? UINavigationController,
                let _ = navBar.viewControllers.last as? TeamsViewController {
                return
            }
            let nv = splitViewController?.viewController(for: .secondary) as? UINavigationController
            nv?.popToRootViewController(animated: true)
            nv?.pushViewController(TeamsViewController(), animated: true)
        case .tables:
            if let navBar = splitViewController?.viewController(for: .secondary) as? UINavigationController,
                let _ = navBar.viewControllers.last as? StadiumsViewController {
                return
            }
            let nv = splitViewController?.viewController(for: .secondary) as? UINavigationController
            nv?.popToRootViewController(animated: true)
            nv?.pushViewController(StadiumsViewController(), animated: true)
        case .matches:
            if let navBar = splitViewController?.viewController(for: .secondary) as? UINavigationController,
                let _ = navBar.viewControllers.last as? StadiumsViewController {
                return
            }
            let nv = splitViewController?.viewController(for: .secondary) as? UINavigationController
            nv?.popToRootViewController(animated: true)
            nv?.pushViewController(StadiumsViewController(), animated: true)
        case .groups:
            if let navBar = splitViewController?.viewController(for: .secondary) as? UINavigationController,
                let _ = navBar.viewControllers.last as? GroupsViewController {
                return
            }
            let nv = splitViewController?.viewController(for: .secondary) as? UINavigationController
            nv?.popToRootViewController(animated: true)
            nv?.pushViewController(GroupsViewController(), animated: true)
        }
    }
    
}

private extension SidebarViewController {
    
    func configureView() {
        var configuration = UICollectionLayoutListConfiguration(appearance: .sidebar)
        configuration.headerMode = .firstItemInSection
        let layout = UICollectionViewCompositionalLayout.list(using: configuration)
        self.collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: layout)
        self.collectionView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        self.collectionView.backgroundColor = .systemBackground
        self.collectionView.delegate = self
        self.view.addSubview(self.collectionView)
    }
    
    func configureCollection() {
        let headerCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> { cell, indexPath, item in
            var configuration = UIListContentConfiguration.sidebarHeader()
            configuration.text = item.title
            cell.contentConfiguration = configuration
            cell.accessories = [.outlineDisclosure()]
        }
        let rowCellRegistration = UICollectionView.CellRegistration<UICollectionViewListCell, SidebarItem> { cell, indexPath, item in
            var configuration = UIListContentConfiguration.sidebarCell()
            configuration.text = item.title
            //configuration.image = item.image
            cell.contentConfiguration = configuration
        }
        self.datasource = UICollectionViewDiffableDataSource<SidebarSection, SidebarItem>(collectionView: self.collectionView) { collectionView, indexPath, item in
            switch item.type {
            case .header: return collectionView.dequeueConfiguredReusableCell(using: headerCellRegistration, for: indexPath, item: item)
            case .row: return collectionView.dequeueConfiguredReusableCell(using: rowCellRegistration, for: indexPath, item: item)
            }
        }
    }

    func updateDatasource() {
        self.datasource?.apply(browseSnapshot(), to: .tables, animatingDifferences: false)
    }
    
    private func browseSnapshot() -> NSDiffableDataSourceSectionSnapshot<SidebarItem> {
        var sectionSnapshot = NSDiffableDataSourceSectionSnapshot<SidebarItem>()
        let header = SidebarItem(title: "Browse", imageName: nil, type: .header)
        sectionSnapshot.append([header])
        //case stadium, players, teams, tables, matches, groups
        sectionSnapshot.append([SidebarItem(title: "Stadium", imageName: nil, type: .row),
                                SidebarItem(title: "Players", imageName: nil, type: .row),
                                SidebarItem(title: "Teams", imageName: nil, type: .row),
                                SidebarItem(title: "Tables", imageName: nil, type: .row),
                                SidebarItem(title: "Matches", imageName: nil, type: .row),
                                SidebarItem(title: "Groups", imageName: nil, type: .row)], to: header)
        sectionSnapshot.expand([header])
        return sectionSnapshot
    }
    
}
