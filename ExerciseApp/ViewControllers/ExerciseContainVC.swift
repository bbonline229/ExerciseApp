//
//  ExerciseContainVC.swift
//  ExerciseApp
//
//  Created by Jack on 6/28/19.
//  Copyright © 2019 Jack. All rights reserved.
//

import UIKit

class ExerciseContainVC: UIViewController {

    @IBOutlet weak var exerciseSegmentControl: UISegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    enum TabIndex: Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    var currentViewController: UIViewController?
    
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = PedometerVC()
        
        return firstChildTabVC
    }()
    
    lazy var secondChildTabVC: UIViewController? = {
        let secondChildTabVC = StartRunVC()
        return secondChildTabVC
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setup()
        segmentSetup()
    }

    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParent()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    private func setup() {
        navigationItem.title = "Exercise"
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "Icon_shoe"), style: .done, target: self, action: #selector(showRunningRecord))
        navigationController?.navigationBar.tintColor = .black
        navigationItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
    }
    
    private func segmentSetup() {
        exerciseSegmentControl.selectedSegmentIndex = 0
        exerciseSegmentControl.backgroundColor = .white
        exerciseSegmentControl.tintColor = .clear
        
        exerciseSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "PingFangTC-Medium", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.lightGray
            ], for: .normal)
        
        exerciseSegmentControl.setTitleTextAttributes([
            NSAttributedString.Key.font : UIFont(name: "PingFangTC-Medium", size: 18)!,
            NSAttributedString.Key.foregroundColor: UIColor.cerulean
            ], for: .selected)
        
        exerciseSegmentControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
    }
    
    private func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChild(vc)
            vc.didMove(toParent: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    private func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        var vc: UIViewController?
        switch index {
        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
        default:
            return nil
        }
        
        return vc
    }
    
    @objc private func showRunningRecord() {
        let vc = RunListVC()
        navigationController?.pushViewController(vc, animated: true)
    }
}
