//
//  FirstTabViewController.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit
import JTAppleCalendar
import CoreData

class FirstTabViewController: UIViewController {
    
    // OUTLET
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var year: UILabel!
    @IBOutlet var month: UILabel!
    @IBOutlet var weekView: UIView!
    @IBOutlet var sun: UILabel!
    @IBOutlet var mon: UILabel!
    @IBOutlet var tue: UILabel!
    @IBOutlet var wed: UILabel!
    @IBOutlet var thu: UILabel!
    @IBOutlet var fri: UILabel!
    @IBOutlet var sat: UILabel!
    
    // VARIABLES
    let formatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    let todaysDate = Date()
    var willSendData : String?
    var datas: [NSManagedObject] = []
    
    // View did load
    override func viewDidLoad() {
        print("viewDidLoad")
        super.viewDidLoad()
        self.fetchDatas()
        self.setWeekColor()
        self.initCalendar()
    }
    
    // Appear
    override func viewWillAppear(_ animated: Bool) {
        print("FTC : viewWillAppear")
        super.viewWillAppear(animated)
//        self.fetchDatas()
//        self.setWeekColor()
        self.initCalendar()
    }
    
    // Disappear
    override func viewWillDisappear(_ animated: Bool) {
        print("viewWillDisappear")
        super.viewWillDisappear(animated)
    }
    
    // 데이터 가져오기 위한 설정
    func getContext () -> NSManagedObjectContext {
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    // 데이터 가져오기
    func fetchDatas(){
        
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
        do {
            datas = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("fetch fail \(error), \(error.userInfo)") }
    }
    
    // 일~토 색 설정
    func setWeekColor(){
        
        weekView.backgroundColor = UIColor(red: CGFloat(250/255.0), green: CGFloat(250/255.0), blue: CGFloat(250/255.0), alpha: CGFloat(1.0))
        sun.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
        mon.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
        tue.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
        wed.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
        thu.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
        fri.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
        sat.textColor = UIColor(red: CGFloat(156/255.0), green: CGFloat(156/255.0), blue: CGFloat(156/255.0), alpha: CGFloat(1.0))
    }
    
    // 스크롤, 뷰 설정
    func initCalendar(){
        calendarView.scrollToDate(todaysDate, animateScroll: false)
        calendarView.visibleDates{
            dateSegment in self.setupCalendarView(dateSegment : dateSegment)
        }
    }
    
    
    // 월, 연도
    func setupCalendarView(dateSegment : DateSegmentInfo){
        guard let date = dateSegment.monthDates.first?.date else{return}
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    // 셀 구성
    func configureCell(cell: JTAppleCell?, cellState: CellState){
        guard let myCustomCell = cell as? CustomCell else {return}
        handleCellTextColor(cell: myCustomCell, cellState: cellState)
        handleCellVisibility(cell: myCustomCell, cellState: cellState)
        handleCellSelection(cell: myCustomCell, cellState: cellState)
        handleCellEvents(cell: myCustomCell, cellState: cellState)
    }
    
    // 날짜 색깔
    func handleCellTextColor(cell: CustomCell, cellState: CellState){
        formatter.dateFormat = "yyyy MM dd"
        let todaysDateString = self.formatter.string(from : todaysDate)
        let monthDateString = self.formatter.string(from : cellState.date)
        
        // 오늘 날짜 : 빨간색, 오늘 아님 : 검정색
        if todaysDateString == monthDateString{
            cell.dateLabel.textColor =
                UIColor(red: CGFloat(252/255.0), green: CGFloat(82/255.0), blue: CGFloat(140/255.0), alpha: CGFloat(1.0))
        }else{
            cell.dateLabel.textColor = UIColor(red: CGFloat(45/255.0), green: CGFloat(45/255.0), blue: CGFloat(50/255.0), alpha: CGFloat(1.0))
        }
    }
    
    // 이번달에 해당하는 날짜만 보임
    func handleCellVisibility(cell: CustomCell, cellState: CellState){
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    // 날짜 누르면 동그라미가 생김
    func handleCellSelection(cell: CustomCell, cellState: CellState){
        formatter.dateFormat = "yyyy MM dd"
        let todaysDateString = self.formatter.string(from : todaysDate)
        let monthDateString = self.formatter.string(from : cellState.date)
        
        // 셀 선택하면
        if(cellState.isSelected){
            cell.selectedView.layer.cornerRadius = cell.selectedView.frame.size.width/2
            cell.selectedView.clipsToBounds = true
            
            if(todaysDateString == monthDateString){
                cell.selectedView.backgroundColor = UIColor(patternImage: UIImage(named: "pinkCircle.png")!)
            }else{
                cell.selectedView.backgroundColor = UIColor(patternImage: UIImage(named: "blackCircle.png")!)
            }
            cell.dateLabel.textColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
        }else{
            cell.selectedView.backgroundColor = UIColor.clear
        }
    }
    
    // 날짜에 해당 하는 티켓 정보 보여주기
    func handleCellEvents(cell: CustomCell, cellState: CellState){
        
        let date : String = formatter.string(from : cellState.date)
        let parsedDate : String = date.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil) //2018-04-23
        
        //현재 날짜의 티켓들
        var ticketsOfcurrenDate: [NSManagedObject] = []
        
        // dates : 디비에 저장된 데이터들
        for data in datas{
            if let deadline = data.value(forKey: "deadline") as? String {
                if(deadline.contains(parsedDate)){
                    ticketsOfcurrenDate.append(data)
                }
            }
        }
        
        // 이 셀의 날짜와 같은 티켓이, 디비에 없으면
        if(ticketsOfcurrenDate.count==0){
            cell.ticket.isHidden = true
            cell.dots.isHidden = true
        }else if(ticketsOfcurrenDate.count == 1){
            // 이 셀의 날짜와 같은 티켓이, 디비에 하나면
            
            // INFO
            let isFinished : Bool = (ticketsOfcurrenDate[0].value(forKey: "deposit") as? Bool)!
            cell.ticket.isHidden = false
            cell.ticket.textColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
            cell.dots.isHidden = true
            if let name = ticketsOfcurrenDate[0].value(forKey: "name") as? String {
                cell.ticket.text = name
                
            }
            
            if(cellState.date < todaysDate  ){
                // 지금 시간 기준으로 이전
                cell.ticket.backgroundColor = UIColor(red: CGFloat(187/255.0), green: CGFloat(186/255.0), blue: CGFloat(186/255.0), alpha: CGFloat(1.0))
            }else{
                // 지금 시간 기준으로 이후 - 입금 여부
                if(isFinished){
                    cell.ticket.backgroundColor = UIColor(red: CGFloat(187/255.0), green: CGFloat(186/255.0), blue: CGFloat(186/255.0), alpha: CGFloat(1.0))
                }else{
                    cell.ticket.backgroundColor = UIColor(red: CGFloat(252/255.0), green: CGFloat(82/255.0), blue: CGFloat(140/255.0), alpha: CGFloat(1.0))
                }
                
            }
        }else if(ticketsOfcurrenDate.count >= 2){
            // 이 셀의 날짜와 같은 티켓이 디비에 두 개 이상이면
            
            //하나라도 입금 안한 티켓이 있으면
            var depositFlag : Bool = true
            for ticket in ticketsOfcurrenDate{
                depositFlag = (ticket.value(forKey: "deposit") as? Bool)!
                if(depositFlag == false){
                    break
                }
            }
            
            // INFO
            cell.ticket.isHidden = false
            if let name = ticketsOfcurrenDate[0].value(forKey: "name") as? String {
                cell.ticket.text = name
            }
            cell.ticket.textColor = UIColor(red: CGFloat(255/255.0), green: CGFloat(255/255.0), blue: CGFloat(255/255.0), alpha: CGFloat(1.0))
            
            // 지금 시간 기준으로 이전
            if(cellState.date < todaysDate  ){
                cell.ticket.backgroundColor = UIColor(red: CGFloat(187/255.0), green: CGFloat(186/255.0), blue: CGFloat(186/255.0), alpha: CGFloat(1.0))
                cell.dots.isHidden = false
                cell.dots.image = UIImage(named: "grayDots")
            }else{
                // 지금 시간 기준으로 이후
                cell.dots.isHidden = false
                cell.dots.image = UIImage(named: "pinkDots")
                
                // 하나라도 입금 안한 티켓이 있으면
                if(depositFlag==false){
                    cell.ticket.backgroundColor = UIColor(red: CGFloat(252/255.0), green: CGFloat(82/255.0), blue: CGFloat(140/255.0), alpha: CGFloat(1.0))
                }else{
                    cell.ticket.backgroundColor = UIColor(red: CGFloat(187/255.0), green: CGFloat(186/255.0), blue: CGFloat(186/255.0), alpha: CGFloat(1.0))
                }
            }
        }
        
    }
    
    
    // 특정 날짜 선택하면 실행되는 메소드
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        
        // get data from DB
        let context = self.getContext()
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
        fetchRequest.predicate = NSPredicate(format: "deadline contains[c] %@", willSendData!)
        
        do {
            let count = try context.fetch(fetchRequest).count
            if(count==0){

                // 공연 없을 때
                let alert = UIAlertController(title: "알림", message: "예매된 공연이 없습니다.", preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "확인", style: .default, handler: nil))

                self.present(alert, animated: true)
                
            }
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
        
        
        
        
        // 공연 있을 때
        if segue.destination is CalendarListViewController{
            let vc = segue.destination as? CalendarListViewController
            vc?.curDate = willSendData!
        }
    }
}


// DataSource
extension FirstTabViewController: JTAppleCalendarViewDataSource {
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from : "2010 01 01")!
        let endDate = formatter.date(from : "2020 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate,   numberOfRows: 6)
        return parameters
    }
}


// Delegate
extension FirstTabViewController: JTAppleCalendarViewDelegate{
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        sharedFunctionToConfigureCell(cell: myCustomCell, cellState: cellState, date: date)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let myCustomCell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        sharedFunctionToConfigureCell(cell: myCustomCell, cellState: cellState, date: date)
        return myCustomCell
    }
    
    func sharedFunctionToConfigureCell(cell:  CustomCell, cellState: CellState, date: Date) {
        cell.dateLabel.text = cellState.text
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarView(dateSegment: visibleDates)
    }
    
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        
        // 선택한 cell 의 날짜
        let formatter : DateFormatter = {
            let dateFormatter = DateFormatter()
            dateFormatter.timeZone = Calendar.current.timeZone
            dateFormatter.locale = Calendar.current.locale
            dateFormatter.dateFormat = "yyyy MM dd"
            return dateFormatter
        }()
        let date : String = formatter.string(from : cellState.date)
        let parsedDate : String = date.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil) //2018-04-23
        willSendData = parsedDate
        
        // 셀의 날짜가 이번달이면
        if cellState.dateBelongsTo == .thisMonth {
            return true
        } else {
            return false
        }
    }
}

extension UIView {
    func bounce() {
        self.transform = CGAffineTransform(scaleX: 0.5 , y:0.5)
        UIView.animate(
            withDuration: 0.5,
            delay: 0, usingSpringWithDamping: 0.3,
            initialSpringVelocity: 0.1,
            options: UIViewAnimationOptions.beginFromCurrentState,
            animations: {
                self.transform = CGAffineTransform(scaleX: 1 , y:1)
        })
    }
}
