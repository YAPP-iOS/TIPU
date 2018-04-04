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

class TicketInfo {
    var name : String = ""
    var isFinished: Bool = false
}

class FirstTabViewController: UIViewController {
    
    // OUTLET
    @IBOutlet var calendarView: JTAppleCalendarView!
    @IBOutlet var year: UILabel!
    @IBOutlet var month: UILabel!
    var perform: [NSManagedObject] = []
    var arrayObjects: [Date : [TicketInfo]] = [:]
    
    var ticket01 = TicketInfo()
    var ticket02 = TicketInfo()
    var ticket03 = TicketInfo()
    var ticket04 = TicketInfo()
    var ticket05 = TicketInfo()
    
    // VARIABLES
    let formatter : DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        dateFormatter.dateFormat = "yyyy MM dd"
        return dateFormatter
    }()
    let todaysDate = Date()
    var eventsFromTheServer : [String : Array<TicketInfo>] = [:]
    var willSendData : String?
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("First VC will appear")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        print("First VC will disappear")
    }
    
    
    
    /* VIEWDIDLOAD */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //from server
        DispatchQueue.global().asyncAfter(deadline: .now()+2) {
            let serverObjects = self.getServerEvenets()
            for(date, tickets ) in serverObjects {
                let stringDate = self.formatter.string(from : date)
                self.eventsFromTheServer[stringDate] = tickets
            }
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
        
        calendarView.scrollToDate(todaysDate, animateScroll: false)
        calendarView.visibleDates{ dateSegment in
            self.setupCalendarView(dateSegment : dateSegment)
        }
        
        ticket01.name = "Wow"
        ticket01.isFinished = false
        ticket02.name = "졸려"
        ticket02.isFinished = true
        ticket03.name = "치킨"
        ticket03.isFinished = false
    }
    
    
    
    /* SET UP CALENDAR VIEW */
    func setupCalendarView(dateSegment : DateSegmentInfo){
        print("setupCalendarView called")
        guard let date = dateSegment.monthDates.first?.date else{return}
        self.formatter.dateFormat = "yyyy"
        self.year.text = self.formatter.string(from: date)
        
        self.formatter.dateFormat = "MMMM"
        self.month.text = self.formatter.string(from: date)
    }
    
    /* CELL CONFIGURATION FUNCTIONS */
    func configureCell(cell: JTAppleCell?, cellState: CellState){
        guard let myCustomCell = cell as? CustomCell else {return}
        handleCellTextColor(cell: myCustomCell, cellState: cellState)
        handleCellVisibility(cell: myCustomCell, cellState: cellState)
        handleCellSelection(cell: myCustomCell, cellState: cellState)
        handleCellEvents(cell: myCustomCell, cellState: cellState)
    }
    
    /* CELL TEXT COLOR */
    func handleCellTextColor(cell: CustomCell, cellState: CellState){
        formatter.dateFormat = "yyyy MM dd"
        let todaysDateString = self.formatter.string(from : todaysDate)
        let monthDateString = self.formatter.string(from : cellState.date)
        
        if todaysDateString == monthDateString{
            cell.dateLabel.textColor = UIColor.red
        }else{
            cell.dateLabel.textColor = cellState.isSelected ? UIColor.white : UIColor.black
        }
    }
    
    /* CELL VISIBILITY */
    func handleCellVisibility(cell: CustomCell, cellState: CellState){
        cell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
    }
    
    /* CELL SELECTION */
    //    let listManager = ListManager()
    func handleCellSelection(cell: CustomCell, cellState: CellState){
        cell.selectedView.isHidden = cellState.isSelected ? false : true
        if(cellState.isSelected){
            let date : String = formatter.string(from : cellState.date)
            willSendData = date.replacingOccurrences(of: " ", with: "-", options: .literal, range: nil)
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let next = storyboard.instantiateViewController(withIdentifier: "CalendarListViewController") as! CalendarListViewController
            if let sendData = willSendData{
                next.receivedData = sendData
            }
            present(next, animated: true, completion: nil)
            //보내면 됨++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++
            
        }
        
    }
    
    /* CELL EVENTS */
    func handleCellEvents(cell: CustomCell, cellState: CellState){
        
        // 디비에 저장된 날짜와 이 셀의 날짜가 같으면
        if(eventsFromTheServer.contains{ $0.key == formatter.string(from : cellState.date)}){
            
            let filterRes : [String : Array<TicketInfo>] = eventsFromTheServer.filter{$0.key == formatter.string(from : cellState.date)}
            
            //티켓 명
            let ticketName : String = filterRes[formatter.string(from : cellState.date)]![0].name
            
            //티켓 개수 == 1
            if(filterRes[formatter.string(from : cellState.date)]?.count == 1){
                
                // 지금 시간 기준으로 이전
                if(cellState.date < todaysDate  ){
                    
                    //티켓 이름
                    cell.ticket.isHidden = false
                    cell.ticket.text = ticketName
                    cell.ticket.backgroundColor = UIColor.gray
                    cell.ticket.textColor = UIColor.white
                    
                    //...
                    cell.pinkDots.isHidden = true
                    cell.grayDots.isHidden = true
                    
                }
                    
                // 지금 시간 기준으로 이후
                else{
                    
                    let isFinished = filterRes[formatter.string(from : cellState.date)]![0].isFinished
                    // 입금 완료
                    if(isFinished){
                        //티켓 이름
                        cell.ticket.isHidden = false
                        cell.ticket.text = ticketName
                        cell.ticket.backgroundColor = UIColor.gray
                        cell.ticket.textColor = UIColor.white
                    }
                        // 미입금
                    else{
                        cell.ticket.isHidden = false
                        cell.ticket.text = ticketName
                        cell.ticket.backgroundColor = UIColor.purple
                        cell.ticket.textColor = UIColor.white
                    }
                    
                    
                    //...
                    cell.pinkDots.isHidden = true
                    cell.grayDots.isHidden = true
                }
            }
                
                // 티켓 개수 >=2
            else{
                
                var isFinished : Bool = true
                for ticketInfo in filterRes[formatter.string(from : cellState.date)]! {
                    if(ticketInfo.isFinished==false){
                        isFinished = false
                        break
                    }
                }
                
                
                //모든 티켓 입금 완료
                if(isFinished){
                    // 지금 시간 기준으로 이전
                    if(cellState.date < todaysDate  ){
                        
                        //티켓 이름
                        cell.ticket.isHidden = false
                        cell.ticket.text = ticketName
                        cell.ticket.backgroundColor = UIColor.gray
                        cell.ticket.textColor = UIColor.white
                        
                        //...
                        cell.pinkDots.isHidden = true
                        cell.grayDots.isHidden = false
                    }
                        
                        // 지금 시간 기준으로 이후
                    else{
                        
                        //티켓 이름
                        cell.ticket.isHidden = false
                        cell.ticket.text = ticketName
                        cell.ticket.backgroundColor = UIColor.gray
                        cell.ticket.textColor = UIColor.white
                        
                        //...
                        cell.pinkDots.isHidden = true
                        cell.grayDots.isHidden = false
                    }
                }
                    //하나라도 미입금
                else{
                    // 지금 시간 기준으로 이전
                    if(cellState.date < todaysDate  ){
                        
                        //티켓 이름
                        cell.ticket.isHidden = false
                        cell.ticket.text = ticketName
                        cell.ticket.backgroundColor = UIColor.gray
                        cell.ticket.textColor = UIColor.white
                        
                        //...
                        cell.pinkDots.isHidden = true
                        cell.grayDots.isHidden = false
                    }
                        
                        // 지금 시간 기준으로 이후
                    else{
                        
                        //티켓 이름
                        cell.ticket.isHidden = false
                        cell.ticket.text = ticketName
                        cell.ticket.backgroundColor = UIColor.purple
                        cell.ticket.textColor = UIColor.white
                        
                        //...
                        cell.pinkDots.isHidden = false
                        cell.grayDots.isHidden = true
                    }
                }
                
                
                
            }
            
        }
            // 이 셀의 날짜가 디비에 저장된 날짜가 아니면
        else{
            cell.pinkDots.isHidden = true
            cell.grayDots.isHidden = true
            cell.ticket.isHidden = true
        }
    }
    
}


// DataSource
extension FirstTabViewController: JTAppleCalendarViewDataSource {
    
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        let startDate = formatter.date(from : "2017 01 01")!
        let endDate = formatter.date(from : "2030 12 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate,   numberOfRows: 6)
        return parameters
    }
}


// VIEWCONTROLLER
extension FirstTabViewController {
    
    
    func getServerEvenets() -> [Date: Array<TicketInfo>]{
        formatter.dateFormat = "yyyy MM dd"
        
        return [
            formatter.date(from: "2018 04 01")! : [ticket01],
            formatter.date(from: "2018 04 22")! : [ticket02, ticket03],
            formatter.date(from: "2018 04 29")! : [ticket04, ticket05],
        ]
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
    
    /* DID SELECT DATE */
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
        //        cell?.bounce()
    }
    
    /* DID DESELECT DATE */
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
        configureCell(cell: cell, cellState: cellState)
    }
    
    /* SCROLL */
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
        setupCalendarView(dateSegment: visibleDates)
    }
    
    /* SHOULD SELECT DATE */
    func calendar(_ calendar: JTAppleCalendarView, shouldSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) -> Bool {
        if cellState.dateBelongsTo == .thisMonth {
            return true
        } else {
            return false
        }
    }
}



//// UIVIEW
//extension UIView {
//    func bounce() {
//        self.transform = CGAffineTransform(scaleX: 0.5 , y:0.5)
//        UIView.animate(
//            withDuration: 0.5,
//            delay: 0, usingSpringWithDamping: 0.3,
//            initialSpringVelocity: 0.1,
//            options: UIViewAnimationOptions.beginFromCurrentState,
//            animations: {
//                self.transform = CGAffineTransform(scaleX: 1 , y:1)
//        })
//    }
//}
