//
//  MainViewController.swift
//  WorldCup
//
//  Created by Fernando Cani on 02/04/22.
//

import UIKit
import TestFramework

class MainViewController: UIViewController {

    @IBOutlet weak var lblCountdown: UILabel!
    
    let viewModel: MainViewModel!
    
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
        self.setupCountdown()
        self.setupBarButtonItem()
//        self.viewModel.onUpdate = {
//            print("success")
//        }
//        self.viewModel.onErrorHandling = { [weak self] error in
//            var message = String()
//            switch error {
//            case WCError.ApiError(let string):
//                message = string
//            default:
//                message = error.localizedDescription
//            }
//            let alert = UIAlertController(title: "Error",
//                                          message: message,
//                                          preferredStyle: .alert)
//            let actionCancel = UIAlertAction(title: "Cancel", style: .cancel)
//            let actionTryAgain = UIAlertAction(title: "Try Again", style: .default) { [weak self] _ in
//                self?.createDB()
//            }
//            alert.addAction(actionTryAgain)
//            alert.addAction(actionCancel)
//            DispatchQueue.main.async {
//                self?.present(alert, animated: true, completion: nil)
//            }
//        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.buildMacToolbar()
    }
    
    private func setupCountdown() {
        guard let start: Date = "21/11/2022 19:00".toDate() else { return }
        print(start)
//        // Anchor time
//        let startTime: Date = start
//        // The total amount of time to wait
//        let duration: TimeInterval = 200 * 60 // 200 minutes
//
//        let formatter = DateComponentsFormatter()
//        formatter.allowedUnits = [.day, .hour, .minute, .second]
//        formatter.zeroFormattingBehavior = .dropLeading
//        formatter.unitsStyle = .short
//        // The amount of time which has past since we started
//        var runningTime: TimeInterval = 0
//
//        // This is just so I can atrificially update the time
//        var time: Date = Date()
//        let cal: Calendar = Calendar.current
////        repeat {
////            // Simulate the passing of time, by the minute
////            // If this was been called from a timer, then you'd
////            // simply use the current time
////            time = cal.date(byAdding: .minute, value: 1, to: time)!
////
////            // How long have we been running for?
////            runningTime = time.timeIntervalSince(startTime)
////            // Have we run out of time?
////            if runningTime < duration {
////                // Print the amount of time remaining
////                print(formatter.string(from: duration - runningTime)!)
////            }
////        } while runningTime < duration
        
        _ = Timer.scheduledTimer(timeInterval: 1,
                                 target: self,
                                 selector: #selector(updateTime),
                                 userInfo: nil,
                                 repeats: true)
        
    }
    
    @objc func updateTime() {
        guard let start: Date = "21/11/2022 19:00".toDate() else { return }
        let currentDate = Date()
        let calendar = Calendar.current
        let diffDateComponents = calendar.dateComponents([.day, .hour, .minute, .second],
                                                         from: currentDate,
                                                         to: start)
        
        let countdown = "\(diffDateComponents.day ?? 0) d, \(diffDateComponents.hour ?? 0) h, \(diffDateComponents.minute ?? 0) m, \(diffDateComponents.second ?? 0) s"
        //print(countdown)
        self.lblCountdown.text = countdown
    }
    
    private func setupBarButtonItem() {
        let itemNewCode = UIBarButtonItem(barButtonSystemItem: .refresh,
                                          target: self,
                                          action: #selector(self.btnOptions))
        self.navigationItem.rightBarButtonItem = itemNewCode
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
        Coordinator.showModule(parent: self, delegate: self)
        //self.navigationController?.pushViewController(TeamsViewController(),
        //                                              animated: true)
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

extension MainViewController: CoordinatorDelegate {
    
    func didFinish() {
        print("didFinish")
    }
    
}
