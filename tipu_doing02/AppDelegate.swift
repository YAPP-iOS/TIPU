//
//  AppDelegate.swift
//  tipu_doing02
//
//  Created by JunHee on 01/04/2018.
//  Copyright © 2018 JunHee. All rights reserved.
//

import UIKit
import CoreData
import EventKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    
    func getContext () -> NSManagedObjectContext {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    var window: UIWindow?
    var first: FirstTabViewController?
    var second: SecondTabViewController?
    var eventStore: EKEventStore?
    
    var arr:[String] = []
    
    var year:Int?
    var month:Int?
    var day:Int?
    
    // 입금 기한
    func getCalcDate(year: Int, month: Int, day: Int, hour: Int, min: Int, sec: Int) -> Date {
        
        let formatter = DateFormatter()
        formatter.locale = NSLocale(localeIdentifier: "ko_KR") as Locale
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        var components = DateComponents()
        components.setValue(year, for: Calendar.Component.year)
        components.setValue(month, for: Calendar.Component.month)
        components.setValue(day, for: Calendar.Component.day)
        components.setValue(hour, for: Calendar.Component.hour)
        components.setValue(min, for: Calendar.Component.minute)
        components.setValue(sec, for: Calendar.Component.second)
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        
        return calendar.date(from: components)!
        
    }
    
    
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        //To change Navigation Bar Background Color
        UINavigationBar.appearance().barTintColor = .white
        
        //To change Back button title & icon color
        //UINavigationBar.appearance().tintColor = .black
        
        //To change Navigation Bar Title Color
        UINavigationBar.appearance().titleTextAttributes = [NSAttributedStringKey.foregroundColor: UIColor(red: CGFloat(247/255.0), green: CGFloat(82/255.0), blue: CGFloat(135/255.0), alpha: CGFloat(1.0))]
        UINavigationBar.appearance().isTranslucent = false
        
        
        
        // 앱이 처음 시작될 때 실행
        if let theString = UIPasteboard.general.string {
            arr = theString.components(separatedBy: "\n")
            
            // 복사한 문자 분석 후 추가
            if (arr[0] == "[인터파크_입금요청]") {
                
                let context = self.getContext()
                let entity = NSEntityDescription.entity(forEntityName: "Perform", in: context)
                
                
                //=========================================기존 코어데이터 디비
                var datas: [NSManagedObject] = []
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
                do {
                    datas = try context.fetch(fetchRequest)
                } catch let error as NSError {
                    print("fetch fail \(error), \(error.userInfo)") }
                
                
                // ============================ㄱ{좌 중복 체크
                var accountFlag: Bool = true
                
                var c = arr[9].components(separatedBy: ["▶",":"])
                for data in datas{
                    if let account = data.value(forKey: "account") as? String {
                        if(account.contains(c[2] + " | " + arr[10])){
                            accountFlag = false
                            break
                        }
                    }
                }
                
                // 가상계좌가 중복안되면
                if(accountFlag){
                    // perform record를 새로 생성함
                    let object = NSManagedObject(entity: entity!, insertInto: context)
                    
                    object.setValue(Date(), forKey: "saveDate")
                    object.setValue(false, forKey: "deposit")
                    
                    var a = arr[5].components(separatedBy: ["▶",":"])
                    let title = a[2]
                    object.setValue(title, forKey: "name")
                    
                    var b = arr[7].components(separatedBy: ["▶",":"])
                    let deadline = b[2]
                    object.setValue(deadline, forKey: "deadline")
                    
                    var alarmtime = b[2].components(separatedBy: [" ","-","시","분"])
                    year = Int(alarmtime[1])
                    month = Int(alarmtime[2])
                    day = Int(alarmtime[3])
                    
                    //                var c = arr[9].components(separatedBy: ["▶",":"])
                    let account = c[2] + " | " + arr[10]
                    object.setValue(account, forKey: "account")
                    
                    
                    var d = arr[11].components(separatedBy: ["▶",":"])
                    let accountholder = d[2]
                    object.setValue(accountholder, forKey: "accountholder")
                    
                    var e = arr[12].components(separatedBy: ["▶",":"])
                    let money = e[2]
                    object.setValue(money, forKey: "money")
                    
                    // 클립보드 초기화
                    UIPasteboard.general.string = ""
                    
                    
                    // 테이블뷰 자동 새로고침
                    let root = self.window?.rootViewController as! UINavigationController
                    let parent = root.viewControllers.first as! ParentViewController
                    let first = parent.firstChildTabVC as! FirstTabViewController
                    let second = parent.secondChildTabVC as! SecondTabViewController
                    first.refresher((Any).self)
                    second.refresher((Any).self)
                    
                    // 새로운 항목 토스트
                    let toastLabel = UILabel(frame: CGRect(x: (self.window?.rootViewController?.view.frame.size.width)!/2 - 110, y: (self.window?.rootViewController?.view.frame.size.height)!-100, width: 230, height: 35))
                    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = .center;
                    toastLabel.font = UIFont(name:"", size: 10.0)
                    toastLabel.text = "새로운 티켓이 추가되었습니다"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10;
                    toastLabel.clipsToBounds  =  true
                    self.window?.rootViewController?.view.addSubview(toastLabel)
                    UIView.animate(withDuration: 4.0, delay: 0.05, options: .curveEaseOut, animations: {
                        toastLabel.alpha = 0.0
                    }, completion: {(isCompleted) in
                        toastLabel.removeFromSuperview()
                    })
                    
                    
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    // 미리 알림 설정
                    if self.eventStore == nil {
                        self.eventStore = EKEventStore()
                        self.eventStore!.requestAccess(to: EKEntityType.reminder, completion:
                            {(isAccessible,errors) in })
                    }
                    
                    
                    let reminder = EKReminder(eventStore: self.eventStore!)
                    reminder.title = "\(title) 입금을 완료해 주세요."
                    reminder.calendar = self.eventStore!.defaultCalendarForNewReminders()
                    
                    let alarm = EKAlarm(absoluteDate: getCalcDate(year: year!, month: month!, day: day!, hour: 21, min: 00, sec: 00))
                    reminder.addAlarm(alarm)
                    
                    do {
                        try self.eventStore!.save(reminder, commit: true)
                    } catch {
                        NSLog("알람 설정 실패")
                    }
                    
                }else{
                    print("가상 계좌 중복")
                }
                
                
            }
        }
        
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // 앱이 active 에서 inactive로 이동될 때 실행
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // 앱이 background 상태일 때 실행
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // 앱이 background에서 foreground로 이동 될때 실행 (아직 foreground에서 실행중이진 않음)
        
        
        //        first?.calendarView.reloadData()
        
        
        if let theString = UIPasteboard.general.string {
            arr = theString.components(separatedBy: "\n")
            
            // 복사한 문자 분석 후 추가
            if (arr[0] == "[인터파크_입금요청]") {
                
                let context = self.getContext()
                let entity = NSEntityDescription.entity(forEntityName: "Perform", in: context)
                
                
                //=========================================기존 코어데이터 디비
                var datas: [NSManagedObject] = []
                let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Perform")
                do {
                    datas = try context.fetch(fetchRequest)
                } catch let error as NSError {
                    print("fetch fail \(error), \(error.userInfo)") }

                
                
                // ============================계좌 중복 체크
                var accountFlag: Bool = true
                
                var c = arr[9].components(separatedBy: ["▶",":"])
                for data in datas{
                    if let account = data.value(forKey: "account") as? String {
                        if(account.contains(c[2] + " | " + arr[10])){
                            accountFlag = false
                            break
                        }
                    }
                }
                
                // 가상계좌가 중복안되면
                if(accountFlag){
                    // perform record를 새로 생성함
                    let object = NSManagedObject(entity: entity!, insertInto: context)
                    
                    object.setValue(Date(), forKey: "saveDate")
                    object.setValue(false, forKey: "deposit")
                    
                    var a = arr[5].components(separatedBy: ["▶",":"])
                    let title = a[2]
                    object.setValue(title, forKey: "name")
                    
                    var b = arr[7].components(separatedBy: ["▶",":"])
                    let deadline = b[2]
                    object.setValue(deadline, forKey: "deadline")
                    
                    var alarmtime = b[2].components(separatedBy: [" ","-","시","분"])
                    year = Int(alarmtime[1])
                    month = Int(alarmtime[2])
                    day = Int(alarmtime[3])
                    
                    //                var c = arr[9].components(separatedBy: ["▶",":"])
                    let account = c[2] + " | " + arr[10]
                    object.setValue(account, forKey: "account")
                    
                    
                    var d = arr[11].components(separatedBy: ["▶",":"])
                    let accountholder = d[2]
                    object.setValue(accountholder, forKey: "accountholder")
                    
                    var e = arr[12].components(separatedBy: ["▶",":"])
                    let money = e[2]
                    object.setValue(money, forKey: "money")
                    
                    // 클립보드 초기화
                    UIPasteboard.general.string = ""
                    
                    
                    // 테이블뷰 자동 새로고침
                    let root = self.window?.rootViewController as! UINavigationController
                    let parent = root.viewControllers.first as! ParentViewController
                    let first = parent.firstChildTabVC as! FirstTabViewController
                    let second = parent.secondChildTabVC as! SecondTabViewController
                    first.refresher((Any).self)
                    second.refresher((Any).self)
                    
                    // 새로운 항목 토스트
                    let toastLabel = UILabel(frame: CGRect(x: (self.window?.rootViewController?.view.frame.size.width)!/2 - 110, y: (self.window?.rootViewController?.view.frame.size.height)!-100, width: 230, height: 35))
                    toastLabel.backgroundColor = UIColor.black.withAlphaComponent(0.6)
                    toastLabel.textColor = UIColor.white
                    toastLabel.textAlignment = .center;
                    toastLabel.font = UIFont(name:"", size: 10.0)
                    toastLabel.text = "새로운 티켓이 추가되었습니다"
                    toastLabel.alpha = 1.0
                    toastLabel.layer.cornerRadius = 10;
                    toastLabel.clipsToBounds  =  true
                    self.window?.rootViewController?.view.addSubview(toastLabel)
                    UIView.animate(withDuration: 4.0, delay: 0.05, options: .curveEaseOut, animations: {
                        toastLabel.alpha = 0.0
                    }, completion: {(isCompleted) in
                        toastLabel.removeFromSuperview()
                    })
                    
                    
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("Could not save \(error), \(error.userInfo)")
                    }
                    
                    // 미리 알림 설정
                    if self.eventStore == nil {
                        self.eventStore = EKEventStore()
                        self.eventStore!.requestAccess(to: EKEntityType.reminder, completion:
                            {(isAccessible,errors) in })
                    }
                    
                    
                    let reminder = EKReminder(eventStore: self.eventStore!)
                    reminder.title = "\(title) 입금을 완료해 주세요."
                    reminder.calendar = self.eventStore!.defaultCalendarForNewReminders()
                    
                    let alarm = EKAlarm(absoluteDate: getCalcDate(year: year!, month: month!, day: day!, hour: 21, min: 00, sec: 00))
                    reminder.addAlarm(alarm)
                    
                    do {
                        try self.eventStore!.save(reminder, commit: true)
                    } catch {
                        NSLog("알람 설정 실패")
                    }
                    
                }else{
                    print("가상 계좌 중복")
                }

                
            }
        }
        
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // 앱이 active 상태가 되어 실행 중일 때
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // 앱이 종료될 때 실행
        self.saveContext()
    }
    
    // MARK: - Core Data stack
    
    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
         */
        let container = NSPersistentContainer(name: "ListDesign")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    // MARK: - Core Data Saving support
    
    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
}


