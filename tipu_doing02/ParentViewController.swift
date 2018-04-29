//
//  ParentViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit

class ParentViewController: UIViewController {
    
    //탭의 인덱스
    enum TabIndex : Int {
        case firstChildTab = 0
        case secondChildTab = 1
    }
    
    // OUTLET
    @IBOutlet var animatedLine: UIView!
    @IBOutlet weak var segmentedControl: SegmentedControl!
    @IBOutlet weak var contentView: UIView!
    
    //변수
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
    
    
    //세그먼트 에니메이션
    func moveRight(view: UIView) {
        view.center.x += 130
    }
    
    func moveLeft(view: UIView) {
        view.center.x -= 130
    }
    
    
    //Did
    override func viewDidLoad() {
        super.viewDidLoad()
        segmentedControl.setupFonts()
        segmentedControl.selectedSegmentIndex = 0
        displayCurrentTab(0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        flag = 0
    }
    
    //Will
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if let currentViewController = currentViewController {
            currentViewController.viewWillDisappear(animated)
        }
    }
    
    // 세그먼트 컨트롤의 탭 이동
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
    
    // 현재 탭을 화면에 보여준다
    func displayCurrentTab(_ tabIndex: Int){
        
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
        }
    }
    
    // 세그먼트의 인덱스에 맞는 뷰컨트롤러를 가져온다
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
