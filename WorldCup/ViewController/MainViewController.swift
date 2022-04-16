//
//  MainViewController.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import UIKit

class MainViewController: UIViewController {

    @IBOutlet weak var lblCountdown: UILabel!
    @IBOutlet weak var stackView: UIStackView!
    @IBOutlet weak var progress: UIActivityIndicatorView!
    
    let viewModel: MainViewModel!
    lazy var startDate: Date = {
        guard let start: Date = "21/11/2022 19:00".toDate() else { return Date() }
        return start
    }()
    
    required init() {
        self.viewModel = MainViewModel()
        super.init(nibName: String(describing: MainViewController.self), bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "MainVC"
        self.lblCountdown.text = self.getDiff()
        self.setupCountdown()
        self.setupBarButtonItem()
        self.setupAddtitionalButtons()
        
        //for i in 1...64 {
        //    print("case match\(i)")
        //}
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.buildMacToolbar()
    }
    
    private func setupBarButtonItem() {
        let itemNewCode = UIBarButtonItem(barButtonSystemItem: .refresh,
                                          target: self,
                                          action: #selector(self.btnOptions))
        self.navigationItem.rightBarButtonItem = itemNewCode
    }
    
    private func setupAddtitionalButtons() {
        if #available(iOS 15.0, *) {
            self.stackView.addArrangedSubview(stackViewAll())
            self.stackView.addArrangedSubview(stackViewGroups())
            self.stackView.addArrangedSubview(stackViewTeams())
            self.stackView.addArrangedSubview(stackViewStadiums())
            self.stackView.addArrangedSubview(stackViewTables())
        }
    }
    
    @available(iOS 15.0, *)
    func stackViewAll() -> UIStackView {
        let stackView1 = UIStackView()
        stackView1.spacing = 4
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        
        let buttom1 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            self.setProgress(animated: true)
            CKManager.shared.publishFromScratch { result in
                self.setProgress(animated: false)
                switch result {
                case .success(_):
                    print("Success -publishFromScratch")
                    self.createAlert(title: "publishFromScratch", message: "success")
                case .failure(let error):
                    fatalError(error.localizedDescription)
                }
            }
        }))
        let buttom2 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            self.setProgress(animated: true)
            Task {
                let groups = await CKManager.shared.fetchGroups()
                let teams = await CKManager.shared.fetchTeams()
                let stadiums = await CKManager.shared.fetchStadiums()
                let tables = await CKManager.shared.fetchTables()
                self.setProgress(animated: false)
                self.createAlert(title: "Fetch All", message: """
                            Groups: \(groups.count)
                            Teams: \(teams.count)
                            Stadiums: \(stadiums.count)
                            Tables: \(tables.count)
                            """)
            }
        }))
        let buttom3 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            self.setProgress(animated: true)
            Task {
                let groups = await CKManager.shared.fetchGroups()
                let teams = await CKManager.shared.fetchTeams()
                let stadiums = await CKManager.shared.fetchStadiums()
                let tables = await CKManager.shared.fetchTables()
                
                let groupIDS = groups.map({ $0.recordID! })
                let teamsIDS = teams.map({ $0.recordID! })
                let stadiumsIDS = stadiums.map({ $0.recordID! })
                let tablesIDS = tables.map({ $0.recordID! })
                
                let boolGroups = await CKManager.shared.removeGroups(by: groupIDS)
                let boolTeams = await CKManager.shared.removeGroups(by: teamsIDS)
                let boolStadiums = await CKManager.shared.removeGroups(by: stadiumsIDS)
                let boolTables = await CKManager.shared.removeGroups(by: tablesIDS)
                
                self.setProgress(animated: false)
                self.createAlert(title: "remove All",
                                 message: """
                                            Groups: \(boolGroups)
                                            Teams: \(boolTeams)
                                            Stadiums: \(boolStadiums)
                                            Tables: \(boolTables)
                                            """)
            }
        }))
        
        buttom1.setTitle("🔼 All", for: .normal)
        buttom2.setTitle("⏬ All", for: .normal)
        buttom3.setTitle("❌ All", for: .normal)
        stackView1.addArrangedSubview(buttom1)
        stackView1.addArrangedSubview(buttom2)
        stackView1.addArrangedSubview(buttom3)
        return stackView1
    }
    
    @available(iOS 15.0, *)
    func stackViewGroups() -> UIStackView {
        let stackView1 = UIStackView()
        stackView1.spacing = 4
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        
        let buttom1 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            //CKManager.shared.publishGroups() { result in
            //
            //}
        }))
        let buttom2 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchGroups()
                self.setProgress(animated: false)
                self.createAlert(title: "Fetch Groups", message: "\(itens.count) groups")
            }
        }))
        let buttom3 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchGroups()
                let bool = await CKManager.shared.removeGroups(by: itens.map({ $0.recordID! }))
                self.setProgress(animated: false)
                self.createAlert(title: "removeGroups", message: "\(bool)")
            }
        }))
        
        buttom1.setTitle("🔼 Groups", for: .normal)
        buttom2.setTitle("⏬ Groups", for: .normal)
        buttom3.setTitle("❌ Groups", for: .normal)
        //stackView1.addArrangedSubview(buttom1)
        stackView1.addArrangedSubview(buttom2)
        stackView1.addArrangedSubview(buttom3)
        return stackView1
    }
    
    @available(iOS 15.0, *)
    func stackViewTeams() -> UIStackView {
        let stackView1 = UIStackView()
        stackView1.spacing = 4
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        
        let buttom1 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            //CKManager.shared.publishTeams() { result in
            //
            //}
        }))
        let buttom2 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchTeams()
                self.setProgress(animated: false)
                self.createAlert(title: "Fetch Teams", message: "\(itens.count) teams")
            }
        }))
        let buttom3 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchTeams()
                let bool = await CKManager.shared.removeTeams(by: itens.map({ $0.recordID! }))
                self.setProgress(animated: false)
                self.createAlert(title: "removeTeams", message: "\(bool)")
            }
        }))
        
        buttom1.setTitle("🔼 Teams", for: .normal)
        buttom2.setTitle("⏬ Teams", for: .normal)
        buttom3.setTitle("❌ Teams", for: .normal)
        //stackView1.addArrangedSubview(buttom1)
        stackView1.addArrangedSubview(buttom2)
        stackView1.addArrangedSubview(buttom3)
        return stackView1
    }
    
    @available(iOS 15.0, *)
    func stackViewStadiums() -> UIStackView {
        let stackView1 = UIStackView()
        stackView1.spacing = 4
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        
        let buttom1 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            //self.setProgress(animated: true)
            //CKManager.shared.publishStadiums(CKManager.shared.convertEntityToCK(originals: CKManager.shared.createStadiums())) { result in
            //    self.setProgress(animated: false)
            //    self.createAlert(title: "publishStadiums", message: "\(result)")
            //}
        }))
        let buttom2 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchStadiums()
                self.setProgress(animated: false)
                self.createAlert(title: "Fetch Stadiums", message: "\(itens.count) stadiums")
            }
        }))
        let buttom3 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchStadiums()
                let bool = await CKManager.shared.removeStadiums(by: itens.map({ $0.recordID! }))
                self.setProgress(animated: false)
                self.createAlert(title: "removeStadiums", message: "\(bool)")
            }
        }))
        buttom1.setTitle("🔼  Stad", for: .normal)
        buttom2.setTitle("⏬  Stad", for: .normal)
        buttom3.setTitle("❌  Stad", for: .normal)
        //stackView1.addArrangedSubview(buttom1)
        stackView1.addArrangedSubview(buttom2)
        stackView1.addArrangedSubview(buttom3)
        return stackView1
    }
    
    @available(iOS 15.0, *)
    func stackViewTables() -> UIStackView {
        let stackView1 = UIStackView()
        stackView1.spacing = 4
        stackView1.axis = .horizontal
        stackView1.distribution = .fillEqually
        
        let buttom1 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            //CKManager.shared.publishStadiums() { result in
            //
            //}
        }))
        let buttom2 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchTables()
                self.setProgress(animated: false)
                self.createAlert(title: "Fetch Tables", message: "\(itens.count) tables")
            }
        }))
        let buttom3 = UIButton(configuration: .filled(), primaryAction: UIAction(handler: { _ in
            Task {
                self.setProgress(animated: true)
                let itens = await CKManager.shared.fetchTables()
                let bool = await CKManager.shared.removeTables(by: itens.map({ $0.recordID! }))
                self.setProgress(animated: false)
                self.createAlert(title: "removeTables", message: "\(bool)")
            }
        }))
        
        buttom1.setTitle("🔼  Tables", for: .normal)
        buttom2.setTitle("⏬  Tables", for: .normal)
        buttom3.setTitle("❌  Tables", for: .normal)
        //stackView1.addArrangedSubview(buttom1)
        stackView1.addArrangedSubview(buttom2)
        stackView1.addArrangedSubview(buttom3)
        return stackView1
    }
    
    
#if targetEnvironment(macCatalyst)
    //code to run on macOS
    @objc
    func btnOptions() {
        let alert = UIAlertController(title: "Options",
                                      message: nil,
                                      preferredStyle: .alert)
        let actionCreate = UIAlertAction(title: "Create DB", style: .default) { [weak self] _ in
            self?.createDB()
        }
        let actionDelete = UIAlertAction(title: "Delete All", style: .destructive) { [weak self] _ in
            self?.viewModel.deleteAll()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionCreate)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
#else
    //code to run on iOS
    @objc
    func btnOptions() {
        let alert = UIAlertController(title: "Options",
                                      message: nil,
                                      preferredStyle: .actionSheet)
        let actionCreate = UIAlertAction(title: "Create DB", style: .default) { [weak self] _ in
            self?.createDB()
        }
        let actionDelete = UIAlertAction(title: "Delete All", style: .destructive) { [weak self] _ in
            self?.clearDB()
        }
        let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
        alert.addAction(actionCreate)
        alert.addAction(actionDelete)
        alert.addAction(actionCancel)
        self.present(alert, animated: true, completion: nil)
    }
#endif
    
    @objc
    func createDB() {
        self.viewModel.setDB()
    }
    
    @objc
    func clearDB() {
        self.viewModel.deleteAll()
    }

    
    @IBAction func btnGoToTeams() {
        self.navigationController?.pushViewController(TeamsViewController(),
                                                      animated: true)
    }
    
    @IBAction func btnGoToGroups() {
        self.navigationController?.pushViewController(GroupsViewController(),
                                                      animated: true)
    }
    
    @IBAction func btnGoToStadiums() {
        self.navigationController?.pushViewController(StadiumsViewController(),
                                                      animated: true)
    }
    
}

extension MainViewController {
    
    private func setupCountdown() {
        _ = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(updateTime),
                                 userInfo: nil,
                                 repeats: true)
        
    }
    
    @objc
    private func updateTime() {
        self.lblCountdown.text = self.getDiff()
    }
    
    private func getDiff() -> String {
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second],
                                                         from: currentDate,
                                                         to: self.startDate)
        
        let countdown = "\(diffDateComponents.day ?? 0) d, \(diffDateComponents.hour ?? 0) h, \(diffDateComponents.minute ?? 0) m, \(diffDateComponents.second ?? 0) s"
        return countdown
    }
    
    private func createAlert(title: String? = nil, message: String? = nil) {
        DispatchQueue.main.async {
            let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
}

extension MainViewController {
 
    func setProgress(animated: Bool) {
        DispatchQueue.main.async {
            switch animated {
            case true: self.progress.startAnimating()
            case false: self.progress.stopAnimating()
            }
        }
    }
    
}
