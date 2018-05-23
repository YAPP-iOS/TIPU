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
import SnapKit
import Toaster
class DetailViewController: UIViewController {
    
    var perform: [NSManagedObject] = []
    var detailinfo: NSManagedObject?
    var deposit :Bool?
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    @IBOutlet var line_one: UIView!
    @IBOutlet var line_two: UIView!
    @IBOutlet var line_three: UIView!
    
    
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
        
        
        //기기에 따라 폰트 크기 다르게.
        let deviceType = UIDevice.current.deviceType

        switch deviceType {
            
        case .iPhone4_4S:
            titlelabel.font = UIFont (name: "HelveticaNeue-Bold", size: 30)
            deadlinelabel.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            text1.font = UIFont (name: "HelveticaNeue", size: 10)
            text2_account.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 10)
            text3_accountholder.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 10)
            text4_money.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 10)
            accountlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 11)
            accountholderlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 11)
            moneylabel.font = UIFont (name: "HelveticaNeue-Medium", size: 11)
            
        case .iPhones_5_5s_5c_SE:
            titlelabel.font = UIFont (name: "HelveticaNeue-Bold", size: 32)
            deadlinelabel.font = UIFont (name: "HelveticaNeue-Medium", size: 18)
            text1.font = UIFont (name: "HelveticaNeue", size: 12)
            text2_account.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 12)
            text3_accountholder.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 12)
            text4_money.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 12)
            accountlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 13)
            accountholderlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 13)
            moneylabel.font = UIFont (name: "HelveticaNeue-Medium", size: 13)
            
            
        case .iPhones_6_6s_7_8:
            titlelabel.font = UIFont (name: "HelveticaNeue-Bold", size: 36)
            deadlinelabel.font = UIFont (name: "HelveticaNeue-Medium", size: 22)
            text1.font = UIFont (name: "HelveticaNeue", size: 16)
            text2_account.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 14)
            text3_accountholder.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 14)
            text4_money.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 14)
            accountlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            accountholderlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            moneylabel.font = UIFont (name: "HelveticaNeue-Medium", size: 16)
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            titlelabel.font = UIFont (name: "HelveticaNeue-Bold", size: 38)
            deadlinelabel.font = UIFont (name: "HelveticaNeue-Medium", size: 23)
            text1.font = UIFont (name: "HelveticaNeue", size: 18)
            text2_account.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            text3_accountholder.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            text4_money.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            accountlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            accountholderlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            moneylabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            
        case .iPhoneX:
            titlelabel.font = UIFont (name: "HelveticaNeue-Bold", size: 38)
            deadlinelabel.font = UIFont (name: "HelveticaNeue-Medium", size: 23)
            text1.font = UIFont (name: "HelveticaNeue", size: 18)
            text2_account.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            text3_accountholder.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            text4_money.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            accountlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            accountholderlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            moneylabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            
        default:
            print("iPad or Unkown device")
            titlelabel.font = UIFont (name: "HelveticaNeue-Bold", size: 36)
            deadlinelabel.font = UIFont (name: "HelveticaNeue-Medium", size: 22)
            text1.font = UIFont (name: "HelveticaNeue", size: 16)
            text2_account.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            text3_accountholder.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            text4_money.font = UIFont (name: "AppleSDGothicNeo-Regular", size: 15)
            accountlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            accountholderlabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            moneylabel.font = UIFont (name: "HelveticaNeue-Medium", size: 17)
            
        }
        titlelabel.adjustsFontSizeToFitWidth = true
        deadlinelabel.adjustsFontSizeToFitWidth = true
        accountlabel.adjustsFontSizeToFitWidth = true
        accountholderlabel.adjustsFontSizeToFitWidth = true
        moneylabel.adjustsFontSizeToFitWidth = true
        
        
        //snapkit
        let superView = self.view
        
        //티켓 이미지
        self.ticketimage.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(67)
            make.top.equalTo(30)
            make.left.equalTo(30)
        }
        // 티켓 제목 길이가 길어지면 넘어가는 문제
        self.titlelabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(120)
            make.height.equalTo(30)
            make.left.right.equalTo(25)
            make.width.equalTo(superView!)
            
        }
        // 입금 기한
        self.deadlinelabel.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(170)
            make.height.equalTo(25)
            make.left.right.equalTo(35)
        }
        //메세지
        self.text1.snp.makeConstraints { (make) -> Void in
            make.top.equalTo(205)
            make.height.equalTo(10)
            make.left.right.equalTo(35)
        }
        //아래 상세 뷰
        self.infoView.snp.makeConstraints { (make) -> Void in
            switch deviceType {
            case .iPhones_5_5s_5c_SE:
                make.top.lessThanOrEqualTo(250)
            case .iPhone4_4S:
                make.top.lessThanOrEqualTo(200)
            case .iPhones_6_6s_7_8:
                make.top.lessThanOrEqualTo(330)
            case .iPhones_6Plus_6sPlus_7Plus_8Plus:
                make.top.lessThanOrEqualTo(400)
            case .iPhoneX:
                make.top.lessThanOrEqualTo(430)
            case .unknown:
                make.top.lessThanOrEqualTo(350)
            }
            
            make.width.lessThanOrEqualTo((superView?.layoutMarginsGuide)!).offset(-30)
            make.left.equalTo((superView?.layoutMarginsGuide)!)
            make.right.equalTo((superView?.layoutMarginsGuide)!).offset(-30)
        }
        
        
        // 상세 뷰 내용
        //막대기들
        self.line_one.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.width.equalTo(self.infoView).offset(-10)
            make.left.equalTo(self.text2_account)
            make.top.equalTo(self.text2_account).offset(40)
        }
        self.line_two.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.width.equalTo(self.infoView).offset(-10)
            make.left.equalTo(self.text3_accountholder)
            make.top.equalTo(self.text3_accountholder).offset(40)
        }
        self.line_three.snp.makeConstraints { (make) -> Void in
            make.height.equalTo(1)
            make.width.equalTo(self.infoView).offset(-10)
            make.left.equalTo(self.text4_money)
            make.top.equalTo(self.text4_money).offset(40)
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
            print("복사했음")
            Toast(text: "계좌번호를 복사했습니다!").show()
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
                self.view.backgroundColor = UIColor(red: CGFloat(44/255.0), green: CGFloat(45/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0))
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
                depositbutton.setTitle("입금 취소하기", for: UIControlState.normal)
                
                
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
                depositbutton.setTitle("입금 취소하기", for: UIControlState.normal)
                ticketimage.image = UIImage(named:"detail_paid")
                
                self.view.backgroundColor = UIColor(red: CGFloat(44/255.0), green: CGFloat(45/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0))
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

