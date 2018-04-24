//
//  CalendarListViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit
import CoreData
import EventKit

class CalendarListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet var tableview: UITableView!
    @IBOutlet var cell_counter: UILabel!
    @IBOutlet var date_mmdd: UILabel!
    
    
    var curDate:String = ""
    var dateyymmdd: String?
    
    var perform: [NSManagedObject] = []
    var refresh: UIRefreshControl!
    var eventStore: EKEventStore?
    
    var receivedData: String = ""
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        //        print("get context완료")
        return appDelegate.persistentContainer.viewContext
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //print(receivedData)
        // Do any additional setup after loading the view.
        tableview.delegate = self
        tableview.dataSource = self
        print("###############")
        print(curDate)
        
        // 새로고침
//        refresh = UIRefreshControl()
//        refresh.attributedTitle = NSAttributedString(string: "Pull to refresh")
//        refresh.addTarget(self, action: #selector(refresher), for: .valueChanged)
//        tableview.addSubview(refresh)
        date_mmdd.text = dateyymmdd
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        cell_counter.text = "총 \(self.perform.count)개"
        return perform.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
//    @objc func refresher(_ sender: Any) {
//
//        // 테이블 뷰 새로고침
//        let context = self.getContext()
//        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
//        fetchRequest.predicate = NSPredicate(format: "deadline contains[c] %@", dateyymmdd!)
//
//        //정렬
//        let sortDescriptor = NSSortDescriptor (key: "saveDate", ascending: false)
//        fetchRequest.sortDescriptors = [sortDescriptor]
//
//        do {
//            perform = try context.fetch(fetchRequest)
//            print("fetch")
//        } catch let error as NSError {
//            print("Could not fetch. \(error), \(error.userInfo)") }
//        self.tableview.reloadData()
//
//
//        // 이 앱을 통해 저장한 이전의 모든 알림 삭제
//
//        refresh.endRefreshing()
//    }
    
    // View가 보여질 때 자료를 DB에서 가져오도록 한다
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        print(receivedData)
        let context = self.getContext()
        
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
        //날짜에 맞는 값 가져오기
        print("recive\(receivedData)")
        fetchRequest.predicate = NSPredicate(format: "deadline contains[c] %@", receivedData)
        
            
        //정렬
        let sortDescriptor = NSSortDescriptor (key: "saveDate", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        do {
            perform = try context.fetch(fetchRequest)
            print("fetch")
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)") }
        
        cell_counter.text = "총 \(self.perform.count)개"
        self.tableview.reloadData()
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! ListTableViewCell
        
        // cell 스타일
        cell.cellView.layer.cornerRadius = 7
        cell.backgroundColor = UIColor.gray
        tableView.separatorStyle = UITableViewCellSeparatorStyle.none
        
        let perform = self.perform[indexPath.row]
        var display: String = ""
        var sub:String = ""
        if let nameLabel = perform.value(forKey: "name") as? String {
            display = nameLabel
            print(nameLabel)
        }
        if let deadline = perform.value(forKey: "deadline") as? String {
            let text = deadline.components(separatedBy: " ")
            sub = text[1]+" "+text[2]+" 까지"
        }
        
        // cell 이미지 변경
        if let image = perform.value(forKey: "deposit") as? Bool {
            if image == true {
                cell.ticketImage?.image = UIImage(named:"paid")
            }
            else {
                cell.ticketImage.image = UIImage(named:"not_paid")
            }
        }
        
        cell.titleText.text = display
        cell.deadlineText.text = sub
        
        return cell
    }
    
    //왼쪽 swipe 입금 전 입금완료
    func tableView(_ tableView: UITableView, leadingSwipeActionsConfigurationForRowAt indexPath: IndexPath)
        ->   UISwipeActionsConfiguration? {
            let cell = tableView.dequeueReusableCell(withIdentifier: "List Cell") as! ListTableViewCell
            let perform = self.perform[indexPath.row]
            guard var deposit = perform.value(forKey: "deposit") as? Bool else {
                return nil
            }
            
            let title: String = deposit ? "입금 전" : "입금완료"
            let action = UIContextualAction(style: .normal, title: title) { action, view, completionHandler in
                if deposit == false {
                    deposit = true
                    cell.ticketImage?.image = UIImage(named:"paid")
                } else {
                    deposit = false
                    cell.ticketImage?.image = UIImage(named:"not_paid")
                }
                perform.setValue(deposit, forKey: "deposit")
                completionHandler(true)
                self.tableview.reloadData()
                
            }
            action.backgroundColor = deposit ? .red : .blue
            let configuration = UISwipeActionsConfiguration(actions: [action])
            configuration.performsFirstActionWithFullSwipe = false
            return configuration
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
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

    

