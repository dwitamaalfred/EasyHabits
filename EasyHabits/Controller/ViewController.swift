//
//  ViewController.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit
import UserNotifications
import CoreData
import Lottie

class ViewController: UIViewController {
    
    var counter = 1
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    let blurEffectView = BlurEffectView()
    let defaults = UserDefaults.standard
    var habits = [HabitsData?]()
    
    @IBOutlet weak var addHabitButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var habitTableView: UITableView!
    
    override func viewDidLoad() {
        
        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
        
        let center = UNUserNotificationCenter.current()

           center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
               if granted {
                   print("Yay!")
               } else {
                   print("D'oh")
               }
           }
        
        let content = UNMutableNotificationContent()
        content.title = "Daily Habit Reminder"
        content.body = "Have you done your habit today?"
        content.categoryIdentifier = "alarm"
        content.sound = UNNotificationSound.default

        var dateComponents = DateComponents()
        dateComponents.hour = 12
        dateComponents.minute = 0
        let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)

        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger)
        center.add(request)
        
        
        //
       
        //
        
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "E, d MMM yyyy"
        
        dateLabel.text = formatter.string(from: date)
        
        habitTableView.delegate = self
        habitTableView.dataSource = self
        
        habitTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
        habitTableView.rowHeight = 200
        
//        DispatchQueue.main.async {
//            UserDefaults.standard.set(date, forKey: "latestDay")
//        }
        
        
        
//        updateDate()
//        DispatchQueue.main.async {
            detectHowManyDayChanged()
            fetchCoreData()
            
//        }
        
        
        
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        self.habitTableView.reloadWithAnimation()
    }
    
 
    
    func detectHowManyDayChanged(){
        if let latestDay = UserDefaults.standard.object(forKey: "latestDay") as? Date {
            let df = DateFormatter()
            df.dateFormat = "dd/MM/yyyy HH:mm"
            let diff = Date().interval(ofComponent: .day, fromDate: latestDay)
            
            print(diff)
            if diff > 0 {
                for _ in 1...diff {
                    let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HabitsData")
                    habitLiveChecker(fetchRequest: request)
                    habitFailedUpdate(fetchRequest: request)
                    habitSuccessUpdate(fetchRequest: request)
                    habitWeekUpdate(fetchRequest: request)
                    
                    
                    let date = Date()
            //        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
                    let formatter = DateFormatter()
                    formatter.timeZone = .current
                    formatter.locale = .current
                    formatter.dateFormat = "E, d MMM yyyy"
                    
                    DispatchQueue.main.async {
                        self.dateLabel.text = formatter.string(from: date)
                        self.fetchCoreData()
                        self.habitTableView.reloadData()
                        
                    }
                    
                }
            }
            
        
        } else {
            print("nil")
//            UserDefaults.standard.set(Date(), forKey: "latestDay")
        }
        UserDefaults.standard.set(Date(), forKey: "latestDay")
    
    }
    
    @objc private func calendarDayDidChange(_ notification : NSNotification) {
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "HabitsData")
        habitLiveChecker(fetchRequest: request)
        habitFailedUpdate(fetchRequest: request)
        habitSuccessUpdate(fetchRequest: request)
        habitWeekUpdate(fetchRequest: request)
        
        
        let date = Date()
//        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "E, d MMM yyyy"
        
        DispatchQueue.main.async {
            UserDefaults.standard.set(Date(), forKey: "latestDay")
            self.dateLabel.text = formatter.string(from: date)
            self.fetchCoreData()
            self.habitTableView.reloadData()
            
        }
        
        
    }
    
   
    func fetchCoreData() {
//        habitTableView.deleteRows(at: [IndexPath], with: .automatic)
        let request = HabitsData.fetchRequest() as NSFetchRequest<HabitsData>
        let sort = NSSortDescriptor(key: "dateCreated", ascending: false)
        request.sortDescriptors = [sort]
        
        do {
            self.habits = try context.fetch(request)
            DispatchQueue.main.async {
                if self.habits.count == 0 {
//                    print("empty state")
                }
                self.habitTableView.reloadData()
            }
            
        }catch{
            
        }
        
    }

    
    
    @IBAction func addHabitButton(_ sender: Any) {
        
        
        
        let alertController = UIAlertController.init(title: "New Habit", message: "that will determine your future", preferredStyle: .alert)
//
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Enter new habit"
           }
//
        alertController.addAction(UIAlertAction(title: "add", style: .default, handler: { [self] (action: UIAlertAction!) in
            let habitName = alertController.textFields![0] as UITextField
            let newHabit = HabitsData(context: self.context)
            newHabit.name = habitName.text
            newHabit.modified = false
            newHabit.lives = 3
            newHabit.dateCreated = Date()
            newHabit.status = ["empty","empty","empty","empty","empty","empty","empty"] as NSObject
//            self.habits.insert(newHabit, at: 0)
            
            do {
                try self.context.save()
            }catch{
                print("failed to save data")
            }
            self.fetchCoreData()
            habitTableView.reloadData()
            self.blurEffectView.removeFromSuperview()
        }))
//
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.blurEffectView.removeFromSuperview()
         }))


        self.view.addSubview(blurEffectView)
        self.present(alertController, animated: true, completion: nil)
    }
//
//    func updateDate(){
//        let date = Date()
//        let formatter = DateFormatter()
//        formatter.timeZone = .current
//        formatter.locale = .current
//        formatter.dateFormat = "dd"
//        let day = formatter.string(from: date)
//        defaults.set(day, forKey: "latestDay")
//    }
    
    func restartButton(cell: CustomTableViewCell){
        cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
    }
    
    func habitLiveChecker(fetchRequest : NSFetchRequest<NSFetchRequestResult>){
        fetchRequest.predicate = NSPredicate(format: "lives = 1 AND modified == NO")
        
        
        do {
            
            let records = try context.fetch(fetchRequest)

               for record in records {
                   context.delete(record as! NSManagedObject)
               }
            try context.save()
            
//            self.fetchCoreData()
//            habitTableView.reloadData()
        } catch _ {
            // error handling
        }
    }
    
    func habitWeekUpdate(fetchRequest: NSFetchRequest<NSFetchRequestResult>) {
        let checkHabitWeek = fetchRequest
        checkHabitWeek.predicate = NSPredicate(format: "totalDays != 0")
        do {
            
            let records = try context.fetch(fetchRequest)

               for record in records {
                   let filteredRecord = record as! HabitsData
                   var status = filteredRecord.status as! [String]
                   if filteredRecord.totalDays % 7 == 0 {
                       filteredRecord.status =  ["empty","empty","empty","empty","empty","empty","empty"] as NSObject
                       if filteredRecord.lives < 3 {
                           filteredRecord.lives += 1
                       }
                   }
                 
               }
            try context.save()
     
        } catch _ {
            // error handling
        }
    }
    
    func habitFailedUpdate(fetchRequest: NSFetchRequest<NSFetchRequestResult>){
        let checkTheUndone = fetchRequest
        checkTheUndone.predicate = NSPredicate(format:  "modified == NO")
        
        do {
            let undoneRecords = try context.fetch(checkTheUndone)
               for record in undoneRecords {
                   let filteredRecord = record as! HabitsData
                   var status = filteredRecord.status as! [String]
                   if filteredRecord.modified == false {
                       filteredRecord.lives -= 1
                       status[Int(filteredRecord.totalDays) % 7] = "failed"
                       filteredRecord.status = status as NSObject
                   }
                   filteredRecord.totalDays += 1
                   do {
                       try self.context.save()
                       
                   }catch{
                       print("failed to save data")
                   }
                   
                   
//                   habitTableView.reloadData()
//                   self.fetchCoreData()
//                   self.blurEffectView.removeFromSuperview()
                   
               }
        } catch _ {
            print("failed update habits")
            // error handling
        }
    }
    
    func habitSuccessUpdate(fetchRequest: NSFetchRequest<NSFetchRequestResult>){
        let checkTheDone = fetchRequest
        checkTheDone.predicate = NSPredicate(format:  "modified == YES")
        
        do {
            let undoneRecords = try context.fetch(checkTheDone)
               for record in undoneRecords {
                   let filteredRecord = record as! HabitsData
                   filteredRecord.totalDays += 1
                   filteredRecord.modified = false
                   do {
                       try self.context.save()
                   }catch{
                       print("failed to save data")
                   }
                   
                   DispatchQueue.main.async {
                       self.habitTableView.reloadData()
                       self.fetchCoreData()
                       self.blurEffectView.removeFromSuperview()
                   }
                   
                   
                   
               }
        } catch _ {
            print("failed update habits")
            // error handling
        }
    }
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        print(habits.count)
        if habits.count == 0 {
            self.habitTableView.setEmptyMessage("You don't have any on going Habit.")
           } else {
               self.habitTableView.restore()
           }

        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.selectionStyle = .none
        cell.habit = habits[indexPath.row]
        cell.habitTitleLabel.text = habits[indexPath.row]!.name
        cell.totalDaysLabel.text = String(habits[indexPath.row]!.totalDays)
        cell.totalDaysDone.text = String(habits[indexPath.row]!.totalDone)
        cell.totalLivesLabel.text = String(habits[indexPath.row]!.lives)
        cell.delegate = self
        if habits[indexPath.row]!.modified == false {
            cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
        }else{
            cell.markDoneButton.setImage(UIImage(named: "done-button"), for: .normal)
        }
       
        for item in cell.historyStackView.arrangedSubviews {
            item.removeFromSuperview()
        }
        
        let statusArray = habits[indexPath.row]!.status
        
        for status in statusArray as! [AnyObject] {

            let statusView = UIImageView()
            statusView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

            if status as! String == "success" {
                statusView.image =  UIImage(named: "days-success")
            } else if status as! String == "failed" {
                statusView.image =  UIImage(named: "days-failed")
            } else {
                statusView.image =  UIImage(named: "days-empty")
            }
            cell.historyStackView.addArrangedSubview(statusView)
        }
        return cell
    }
}


extension ViewController : ModifyHabitCardDelegate {
    func settingCellPressed(cell: CustomTableViewCell) {
        self.view.addSubview(blurEffectView)
        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
        let editAction = UIAlertAction(title: "edit", style: .default) { [self] (action) in
            
            let i = habitTableView.indexPath(for: cell)?.row ?? 0
            
            let alertController = UIAlertController.init(title: "Edit Habit", message: "update your habit", preferredStyle: .alert)
    //
            alertController.addTextField { (textField : UITextField!) -> Void in
                textField.text = (self.habits[i]?.name)! as String
               }
    //
            alertController.addAction(UIAlertAction(title: "Update", style: .default, handler: { [self] (action: UIAlertAction!) in
                let habitName = alertController.textFields![0] as UITextField
                
                self.habits[i]?.name = habitName.text
//                newHabit.modified = false
//                newHabit.dateCreated = Date()
//                newHabit.status = ["empty","empty","empty","empty","empty","empty","empty"] as NSObject
    //            self.habits.insert(newHabit, at: 0)
                
                do {
                    try self.context.save()
                }catch{
                    print("failed to save data")
                }
                DispatchQueue.main.async {
                    self.habitTableView.reloadData()
                    self.fetchCoreData()
                }
                
                self.blurEffectView.removeFromSuperview()
            }))
    //
            alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
                self.blurEffectView.removeFromSuperview()
             }))


            self.view.addSubview(self.blurEffectView)
            self.present(alertController, animated: true, completion: nil)
            
            
            self.blurEffectView.removeFromSuperview()
            
            
        }
        let deleteAction = UIAlertAction(title: "delete", style: .destructive) { (action) in
            self.blurEffectView.removeFromSuperview()
            let index = self.habitTableView.indexPath(for: cell)?.row
            let habitToRemove = self.habits[index!]
            self.context.delete(habitToRemove!)
            
            do {
                try self.context.save()
            }catch{
                
            }
            DispatchQueue.main.async {
                self.fetchCoreData()
                self.habitTableView.reloadData()
            }
    
            
            
        }
        let cancelAction = UIAlertAction(title: "cancel", style: .cancel) { (action) in
            self.blurEffectView.removeFromSuperview()
        }
        actionSheet.addAction(editAction)
        actionSheet.addAction(deleteAction)
        actionSheet.addAction(cancelAction)
        self.present(actionSheet, animated: true, completion: nil)
    }
    
    func didUpdateHabitValue(cell: CustomTableViewCell) {
//        self.detectHowManyDayChanged()
        
        let i = habitTableView.indexPath(for: cell)?.row ?? 0

        var habitStatus = (self.habits[i]?.status)! as! [String]
        if self.habits[i]!.modified == false {
            self.habits[i]!.totalDone += 1
            self.habits[i]!.modified = true
            habitStatus[Int(self.habits[i]!.totalDays) % 7] = "success"

            }else{
                self.habits[i]!.totalDone -= 1
                self.habits[i]!.modified = false
                habitStatus[Int(self.habits[i]!.totalDays) % 7] = "false"
            }
        self.habits[i]!.status = habitStatus as NSObject
            let cell = habitTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CustomTableViewCell
                for item in cell.historyStackView.arrangedSubviews {
                    item.removeFromSuperview()
                }
        
        do {
            try self.context.save()
        }catch{
            
        }
        DispatchQueue.main.async {
            self.fetchCoreData()
            self.habitTableView.reloadData()
        }
    }
}

extension Date {
    func interval(ofComponent comp: Calendar.Component, fromDate date: Date) -> Int {
        let currentCalendar = Calendar.current

        guard let start = currentCalendar.ordinality(of: comp, in: .era, for: date) else { return 0 }
        guard let end = currentCalendar.ordinality(of: comp, in: .era, for: self) else { return 0 }

        return end - start
    }
}

extension UITableView {
    func reloadWithAnimation(){
        let tableViewHeight = self.bounds.size.height
                let cells = self.visibleCells
                var delayCounter = 0
                for cell in cells {
                    cell.transform = CGAffineTransform(translationX: self.bounds.size.width, y: 0)
                }
                for cell in cells {
                    UIView.animate(withDuration: 0.8, delay: 0.05 * Double(delayCounter),usingSpringWithDamping: 0.8, initialSpringVelocity: 0, options: .curveEaseInOut, animations: {
                        cell.transform = CGAffineTransform.identity
                    }, completion: nil)
                    delayCounter += 1
                }
    }
}


