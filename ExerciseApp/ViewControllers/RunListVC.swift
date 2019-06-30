//
//  RunListVC.swift
//  ExerciseApp
//
//  Created by Jack on 6/29/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit
import RealmSwift

class RunListVC: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    private var itemsToken: NotificationToken?
    
    lazy var runDatas: Results<RunModel> = RunModel.all()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        setup()
        setupNavigation()
        observeRunData()
    }
    
    private func setup() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.register(UINib(nibName: "RunRecordCell", bundle: nil), forCellReuseIdentifier: "RunRecordCell")
        tableView.tableFooterView = UIView()
        tableView.separatorStyle = .none
    }
    
    private func setupNavigation() {
        navigationItem.title = "Running Record"
    }
    
    private func observeRunData() {
        itemsToken = runDatas.observe({ [weak tableView] changes in
            guard let tableView = tableView else { return }
            
            switch changes {
            case .initial:
                print("initial")
                tableView.reloadData()
            case .update(_, let deletions, let insertions, let updates):
                print("update")
                tableView.applyChanges(deletions: deletions, insertions: insertions, updates: updates)
            case .error: break
            }
        })
    }
}

extension RunListVC: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return runDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RunRecordCell") as! RunRecordCell
        cell.runRecord = runDatas[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let runData = runDatas[indexPath.row]
        
        runData.delete()
    }
}
