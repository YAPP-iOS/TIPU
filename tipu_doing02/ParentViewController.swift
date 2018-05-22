//
//  ParentViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit
import SnapKit

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
    
    // 변수
    var currentViewController: UIViewController?
    var flag:Int? = 0
    
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
        view.center.x += segmentedControl.frame.width / 2
    }
    
    func moveLeft(view: UIView) {
        view.center.x -= segmentedControl.frame.width / 2
    }
    
    //viewDidLoad
    override func viewDidLoad() {
        print("parentVC : viewDidLoad")
        super.viewDidLoad()
        
        segmentedControl.setupFonts()
        segmentedControl.selectedSegmentIndex = 0
        displayCurrentTab(0)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        //set location animate line
        self.animatedLine.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(64)
            make.height.equalTo(2)
            make.centerX.equalTo(segmentedControl.frame.width/4)
        }
        
        //네비게이션 백 버튼 검정색으로
        self.navigationController?.navigationBar.tintColor = UIColor.black
        
    }
    
    // Appear
    override func viewWillAppear(_ animated: Bool) {
        print("parentVC : viewWillAppear")
        super.viewWillAppear(animated)
    }
    
    
    // 세그먼트 컨트롤의 탭 이동
    @IBAction func switchTabs(_ sender: UISegmentedControl) {
        print("parentVC : switchTabs")
        
        let duration: Double = 0.45
        
        //에니메이션
        if(sender.selectedSegmentIndex==0 && flag == 1){
            
            UIView.animate(withDuration: duration, animations: {
                self.moveLeft(view: self.animatedLine)
                print("move left")
            })
            flag = 0
            
        
        }else if(sender.selectedSegmentIndex==1 && flag == 0){
            
            
            //오른쪽으로
            UIView.animate(withDuration: duration) {
                self.moveRight(view: self.animatedLine)
                print("move right")
            }
            flag = 1
        }
        
        self.currentViewController!.removeFromParentViewController()
        displayCurrentTab(sender.selectedSegmentIndex)
    }
    
    // 현재 탭을 화면에 보여준다
    func displayCurrentTab(_ tabIndex: Int){
        
        print("parentVC : displayCurrentTab")
        
        if let vc = viewControllerForSelectedSegmentIndex(tabIndex) {
            
            self.addChildViewController(vc)
            vc.didMove(toParentViewController: self)
            vc.view.frame = self.contentView.bounds
            self.contentView.addSubview(vc.view)
            self.currentViewController = vc
            
            if(tabIndex==0){
                let first = firstChildTabVC as! FirstTabViewController
                first.refresher(self)
                
            }
        }
    }
    
    // 세그먼트의 인덱스에 맞는 뷰컨트롤러를 가져온다
    func viewControllerForSelectedSegmentIndex(_ index: Int) -> UIViewController? {
        print("parentVC : viewControllerForSelectedSegmentIndex")
        var vc: UIViewController?
        switch index {

        case TabIndex.firstChildTab.rawValue :
            vc = firstChildTabVC
        case TabIndex.secondChildTab.rawValue :
            vc = secondChildTabVC
            
            let second = vc as! SecondTabViewController
            second.refresher((Any).self)

        default:
            return nil
        }
        
        return vc
    }
}
