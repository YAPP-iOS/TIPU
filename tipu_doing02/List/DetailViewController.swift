//
//  DetailViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit

import UIKit
import CoreData
import PKHUD

class DetailViewController: UIViewController {
    
    var perform: [NSManagedObject] = []
    var detailinfo: NSManagedObject?
    var deposit :Bool?
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBOutlet var titlelabel: UILabel!
    @IBOutlet var deadlinelabel: UILabel!
    @IBOutlet var accountlabel: UILabel!
    @IBOutlet var accountholderlabel: UILabel!
    @IBOutlet var moneylabel: UILabel!
    
    @IBOutlet var infoView: UIView!
    @IBOutlet var ticketimage: UIImageView!
    
    @IBOutlet var text1: UILabel!
    @IBOutlet var text2_account: UILabel!
    @IBOutlet var text3_accountholder: UILabel!
    @IBOutlet var text4_money: UILabel!
    
    @IBOutlet var depositbutton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //계좌번호 long press시 copy되도록 함.
        let longPressGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressLabel(longPressGestureRecognizer:)))
        accountlabel.addGestureRecognizer(longPressGestureRecognizer)
        accountlabel.isUserInteractionEnabled = true
        
        //snapkit
        let superView = self.view
        //티켓 이미지
        self.ticketimage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(67)
            make.top.equalTo(30)
            make.left.equalTo(30)
        }
        // 티켓 제목 길이가 길어지면 넘어가는 문제;-; 우선 넘어가자  폰트를 키워야할듯
        self.titlelabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(120)
            make.height.equalTo(30)
            make.left.right.equalTo(25)
            
        }
        // 입금 기한
        self.deadlinelabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(160)
            make.height.equalTo(25)
            make.left.right.equalTo(35)
        }
        //메세지
        self.text1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(195)
            make.height.equalTo(10)
            make.left.right.equalTo(35)
        }
        //아래 상세 뷰
        self.infoView.snp.makeConstraints { (make) -> Void in
            make.top.greaterThanOrEqualTo(250)
            make.top.lessThanOrEqualTo(290)
            make.width.lessThanOrEqualTo((superView?.layoutMarginsGuide)!)
            make.center.equalTo((superView?.layoutMarginsGuide)!)
            make.left.equalTo((superView?.layoutMarginsGuide)!)
            make.right.equalTo((superView?.layoutMarginsGuide)!)
//            make.left.equalTo(0)
        }

        //입금상태 변경 버튼
        self.depositbutton.snp.makeConstraints { (make) -> Void in
            make.right.left.equalTo(superView!).offset(0)
            make.height.equalTo(60)
            make.bottom.equalTo(0)
        }
    }

    @objc private func longPressLabel (longPressGestureRecognizer: UILongPressGestureRecognizer) {
        if longPressGestureRecognizer.state == .began {
            let copy_accountNumber = accountlabel.text
            //계좌번호만 받기 위해서 자르기
            let array = copy_accountNumber?.components(separatedBy: " | ")
            UIPasteboard.general.string = array![1]
            HUD.flash(.success, delay: 1.0)
            print("복사했음")
//            Toast(text: "계좌번호를 복사했습니다!").show()
        } else if longPressGestureRecognizer.state == .ended {
        }
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        if let info = detailinfo {
            titlelabel.text = info.value(forKey: "name") as? String
            let aa = info.value(forKey: "deadline") as? String
            let ab = aa?.components(separatedBy: " ")
            if let text = ab {
                deadlinelabel.text = text[1]+" "+text[2]+"까지"
            }
            accountlabel.text = info.value(forKey: "account") as? String
            accountholderlabel.text = info.value(forKey: "accountholder") as? String
            moneylabel.text = info.value(forKey: "money") as? String
            
            
            deposit = info.value(forKey: "deposit") as? Bool
            
            if  deposit == true {
                // 입금 완료
                ticketimage.image = UIImage(named:"detail_paid")
                self.view.backgroundColor = UIColor.black
                depositbutton.backgroundColor = UIColor.white
                depositbutton.setTitleColor(UIColor.black, for: UIControlState.normal)
                
                titlelabel.textColor = UIColor.white
                deadlinelabel.textColor = UIColor.white
                accountlabel.textColor = UIColor.white
                accountholderlabel.textColor = UIColor.white
                moneylabel.textColor = UIColor.white
                text1.text = "입금이 완료되었습니다"
                text1.textColor = UIColor.white
                text2_account.textColor = UIColor.white
                text3_accountholder.textColor = UIColor.white
                text4_money.textColor = UIColor.white
                depositbutton.setTitle("입금을 완료하였습니다.", for: UIControlState.normal)
                
                
            }
            else {
                // 미입금
                ticketimage.image = UIImage(named:"detail_not_paid")
                self.view.backgroundColor = UIColor.white
                depositbutton.backgroundColor = UIColor(red:1, green:82/255, blue:140/255, alpha:1)
                depositbutton.setTitleColor(UIColor.white, for: UIControlState.normal)
                
                titlelabel.textColor = UIColor.black
                deadlinelabel.textColor = UIColor.black
                accountlabel.textColor = UIColor.black
                accountholderlabel.textColor = UIColor.black
                moneylabel.textColor = UIColor.black
                
                text1.textColor = UIColor.black
                text2_account.textColor = UIColor.black
                text3_accountholder.textColor = UIColor.black
                text4_money.textColor = UIColor.black
            }
        }
    }
    
    @IBAction func Buttonpressed(_ sender: UIButton) {
        
        if let info = detailinfo {
            //deposit = info.value(forKey: "deposit") as? Bool
            
            if  deposit == false {
                // 입금 완료
                print("입금 완료")
                depositbutton.setTitle("입금을 완료하였습니다.", for: UIControlState.normal)
                ticketimage.image = UIImage(named:"detail_paid")
                self.view.backgroundColor = UIColor.black
                depositbutton.backgroundColor = UIColor.white
                depositbutton.setTitleColor(UIColor.darkGray, for: UIControlState.normal)
                
                
                titlelabel.textColor = UIColor.white
                deadlinelabel.textColor = UIColor.white
                accountlabel.textColor = UIColor.white
                accountholderlabel.textColor = UIColor.white
                moneylabel.textColor = UIColor.white
                
                text1.textColor = UIColor.white
                text1.text = "입금이 완료되었습니다"
                text2_account.textColor = UIColor.white
                text3_accountholder.textColor = UIColor.white
                text4_money.textColor = UIColor.white
                
                info.setValue(true, forKey: "deposit")
                deposit = true
                
            }
            else {
                // 미입금
                print("미입금")
                depositbutton.setTitle("입금 완료하기", for: UIControlState.normal)
                ticketimage.image = UIImage(named:"detail_not_paid")
                self.view.backgroundColor = UIColor.white
                depositbutton.backgroundColor = UIColor(red:1, green:82/255, blue:140/255, alpha:1)
                depositbutton.setTitleColor(UIColor.white, for: UIControlState.normal)
                
                titlelabel.textColor = UIColor.black
                deadlinelabel.textColor = UIColor.black
                accountlabel.textColor = UIColor.black
                accountholderlabel.textColor = UIColor.black
                moneylabel.textColor = UIColor.black
                
                text1.textColor = UIColor.black
                text1.text = "입금을 완료해주세요"
                text2_account.textColor = UIColor.black
                text3_accountholder.textColor = UIColor.black
                text4_money.textColor = UIColor.black
                
                
                info.setValue(false, forKey: "deposit")
                deposit = false
            }
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

