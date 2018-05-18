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
        self.tableview.reloadData()
        
        
        // 이 앱을 통해 저장한 이전의 모든 알림 삭제
        refresh.endRefreshing()
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
        
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return perform.count
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
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
            
        }
        if let deadline = perform.value(forKey: "deadline") as? String {
            let text = deadline.components(separatedBy: " ")
            sub = text[1]+" "+text[2]+" 까지"
            
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
