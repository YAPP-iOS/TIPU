//
//  ParentViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    @IBOutlet var animatedLine: UIView!
    @IBOutlet var TIPU: UILabel!
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    var currentViewController: UIViewController?
    var flag:Int?
    lazy var firstChildTabVC: UIViewController? = {
        let firstChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "FirstViewControllerId")
        return firstChildTabVC
    }()
    lazy var secondChildTabVC : UIViewController? = {
        let secondChildTabVC = self.storyboard?.instantiateViewController(withIdentifier: "SecondViewControllerId")
        
        return secondChildTabVC
    }()
    
    
    func moveRight(view: UIView) {
        view.center.x += 130
    }
    
    func moveLeft(view: UIView) {
        view.center.x -= 130
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.initUI()
        segmentedControl.selectedSegmentIndex = TabIndex.firstChildTab.rawValue
//        segmentedControl.selectItemAt(index: 2, animated: false)
        displayCurrentTab(TabIndex.firstChildTab.rawValue)
        
//        TIPU.textColor =
//            UIColor(red: CGFloat(247/255.0), green: CGFloat(82/255.0), blue: CGFloat(135/255.0), alpha: CGFloat(1.0))
        
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
 
        
        flag = 0
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // MARK: - Switching Tabs Functions
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        
        let duration: Double = 0.5
        //왼쪽으로
        if(sender.selectedSegmentIndex==0 && flag == 1){
            UIView.animate(withDuration: duration, animations: {
                self.moveLeft(view: self.animatedLine)
            })
            flag = 0
        }else if(sender.selectedSegmentIndex==1 && flag == 0){
            
            //오른쪽으로
            UIView.animate(withDuration: duration) {
                self.moveRight(view: self.animatedLine)
            }
            flag = 1
        }
        
        
        self.currentViewController!.view.removeFromSuperview()
        self.currentViewController!.removeFromParentViewController()
        
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    func displayCurrentTab(_ tabIndex: Int){
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
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
}
