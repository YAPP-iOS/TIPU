//
//  SecondTabViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit
import CoreData
import EventKit
import SnapKit
class SecondTabViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet var tableview: UITableView!
    
    var perform: [NSManagedObject] = []
    var refresh: UIRefreshControl!
    var eventStore: EKEventStore?
        let buttonBar = UIView()
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        print("Second VC viewdidload")
        super.viewDidLoad()
        
        tableview.delegate = self
        tableview.dataSource = self
        
        // 새로고침
        refresh = UIRefreshControl()
        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
        refresh.addTarget(self, action: #selector(refresher), for: .valueChanged)
        tableview.addSubview(refresh)
        
        // tableview backgrond
        tableview.backgroundColor = UIColor(red: CGFloat(242/255.0), green: CGFloat(242/255.0), blue: CGFloat(242/255.0), alpha: CGFloat(1.0))
        

    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        print("SecondTabViewCon : viewWillDisappear")
        super.viewWillDisappear(animated)
    }
    
    class Responder : NSObject { @objc func segmentedControlValueChanged ( _ sender : UISegmentedControl ) {} }
    
    @objc func refresher(_ sender: Any) {
        
        // 테이블 뷰 새로고침
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
        
        //정렬
        let sortDescriptor = NSSortDescriptor (key: "saveDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            perform = try context.fetch(fetchRequest)
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        self.tableview?.reloadData()
        
        refresh?.endRefreshing()
        print("refresh")
    }
    
    // View가 보여질 때 자료를 DB에서 가져오도록 한다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
        
        
        //정렬
        let sortDescriptor = NSSortDescriptor (key: "saveDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            perform = try context.fetch(fetchRequest)
            
            
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        self.tableview.reloadData()
        
        print("viewdidappear")
        
    }
    
    //테이블 뷰 업데이트~.~
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.beginUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch type {
        case .insert:
            print("데이터 들어옴")
            tableview.insertRows(at: [newIndexPath!], with: .fade)
        case .delete:
            tableview.deleteRows(at: [indexPath!], with: .fade)
        case .update:
            tableview.reloadRows(at: [indexPath!], with: .fade)
        case .move:
            tableview.moveRow(at: indexPath!, to: newIndexPath!)
        }
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableview.endUpdates()
    }
    //끝~~~~
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perform.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! ListTableViewCell
        
        // cell 스타일
        cell.cellView.snp.makeConstraints { (make) -> Void in
//            make.width.equalToSuperview().offset(-30)
//            make.left.equalToSuperview()
//            make.top.equalToSuperview().offset(2)
//            make.height.equalTo(40)
        }
        //티켓버튼
        cell.ticketBtn.snp.makeConstraints { (make) -> Void in
            make.width.height.equalTo(55)
            make.left.equalTo(20)
            make.top.equalToSuperview().offset(20)
        }
//
        //바
        cell.bar.snp.makeConstraints { (make) -> Void in
            make.width.equalTo(1)
            make.height.equalToSuperview()
            make.left.equalTo(cell.cellView).offset(90)
            make.top.equalToSuperview()
        }
        cell.titleText.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(20)
            make.left.equalTo(cell.bar).offset(20)
            make.width.equalToSuperview().offset(-30)
        }
        cell.deadlineText.snp.makeConstraints { (make) -> Void in
            make.top.equalToSuperview().offset(50)
            make.left.equalTo(cell.bar).offset(25)
            make.width.equalToSuperview().offset(-30)

        }
       
        cell.cellView.layer.cornerRadius = 7
        cell.backgroundColor = UIColor.gray
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let perform = self.perform[indexPath.row]
        var display: String = ""
        var sub:String = ""
        if let nameLabel = perform.value(forKey: "name") as? String {
            display = nameLabel
            
        }
        if let deadline = perform.value(forKey: "deadline") as? String {
            let text = deadline.components(separatedBy: " ")
            sub = "입금기한 | "+text[1]+" "+text[2]+" 까지"
            
        }
        
        // cell button image 설정
        if let image = perform.value(forKey: "deposit") as? Bool {
            if image == true {
                cell.ticketBtn?.setImage(UIImage(named: "paid"), for: .normal)
                cell.ticketBtn.tag = indexPath.row
            }
            else {
                cell.ticketBtn?.setImage(UIImage(named: "not_paid"), for: .normal)
                cell.ticketBtn.tag = indexPath.row
            }
        }
        let deviceType = UIDevice.current.deviceType
        
        switch deviceType {
            
        case .iPhone4_4S:
            cell.titleText.font = UIFont (name: "HelveticaNeue-Medium", size: 15)
            cell.deadlineText.font = UIFont (name: "AppleSDGothicNeo-Light", size: 10)
            
        case .iPhones_5_5s_5c_SE:
            cell.titleText.sizeToFit()
            cell.titleText.font = UIFont (name: "HelveticaNeue-Medium", size: 16.5)
            cell.deadlineText.font = UIFont (name: "AppleSDGothicNeo-Light", size: 12)
            
        case .iPhones_6_6s_7_8:
            cell.titleText.font = UIFont (name: "HelveticaNeue-Medium", size: 18.5)
            cell.deadlineText.font = UIFont (name: "AppleSDGothicNeo-Light", size: 13)
            
        case .iPhones_6Plus_6sPlus_7Plus_8Plus:
            cell.titleText.font = UIFont.systemFont(ofSize: 20.5)
            cell.deadlineText.font = UIFont.systemFont(ofSize: 14)
            
            cell.titleText.font = UIFont (name: "HelveticaNeue-Medium", size: 20.5)
            cell.deadlineText.font = UIFont (name: "AppleSDGothicNeo-Light", size: 14)
            
        case .iPhoneX:
            cell.titleText.font = UIFont (name: "HelveticaNeue-Medium", size: 20.5)
            cell.deadlineText.font = UIFont (name: "AppleSDGothicNeo-Light", size: 14)
            
        default:
            print("iPad or Unkown device")
            cell.titleText.font = UIFont (name: "HelveticaNeue-Medium", size: 18.5)
            cell.deadlineText.font = UIFont (name: "AppleSDGothicNeo-Light", size: 13)
            
        }
        
        cell.ticketBtn.addTarget(self, action: #selector(clickTicketImg), for: .touchUpInside)
        
        cell.titleText.text = display
        cell.deadlineText.text = sub
        
        
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Core Data 내의 해당 자료 삭제
            let context = getContext()
            context.delete(perform[indexPath.row])
            do {
                try context.save()
                print("deleted!")
            } catch let error as NSError {
                print("Could not delete \(error), \(error.userInfo)") }
            // 배열에서 해당 자료 삭제
            perform.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            
        }
    }
    
    //ticket button click 설정
    @IBAction func clickTicketImg(_ sender: UIButton) {
        let perform = self.perform[sender.tag]
        if var deposit = perform.value(forKey: "deposit") as? Bool {
            if deposit == true {
                deposit = false
            }
            else{
                deposit = true
            }
            perform.setValue(deposit, forKey: "deposit")
        }
        self.tableview.reloadData()
    }
    
    override func prepare (for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toDetailView" {
            if let destination = segue.destination as? DetailViewController {
                if let selectedIndex = self.tableview.indexPathsForSelectedRows?.first?.row {
                    destination.detailinfo = perform[selectedIndex]
                }
            }
            
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
extension UIDevice {
    
    enum DeviceType: String {
        case iPhone4_4S = "iPhone 4 or iPhone 4S"
        case iPhones_5_5s_5c_SE = "iPhone 5, iPhone 5s, iPhone 5c or iPhone SE"
        case iPhones_6_6s_7_8 = "iPhone 6, iPhone 6S, iPhone 7 or iPhone 8"
        case iPhones_6Plus_6sPlus_7Plus_8Plus = "iPhone 6 Plus, iPhone 6S Plus, iPhone 7 Plus or iPhone 8 Plus"
        case iPhoneX = "iPhone X"
        case unknown = "iPadOrUnknown"
    }
    
    var deviceType: DeviceType {
        switch UIScreen.main.nativeBounds.height {
        case 960:
            return .iPhone4_4S
        case 1136:
            return .iPhones_5_5s_5c_SE
        case 1334:
            return .iPhones_6_6s_7_8
        case 1920, 2208:
            return .iPhones_6Plus_6sPlus_7Plus_8Plus
        case 2436:
            return .iPhoneX
        default:
            return .unknown
        }
    }
}
