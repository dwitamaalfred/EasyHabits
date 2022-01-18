//
//  ViewController.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

protocol MainViewDelegate {
    func updateHabitCards()
}

class ViewController: UIViewController {
    
    var counter = 1
    
    var habits = [HabitModel(name: "habit 1", status: ["success","empty","empty","empty","empty","empty","empty"], streak: 1, lives: 3, totalDone: 1, modified: false, totalDays: 1),
                  HabitModel(name: "habit 2", status: ["success","success","empty","empty","empty","empty","empty"], streak: 2, lives: 3, totalDone: 2, modified: false, totalDays: 2),
                  HabitModel(name: "habit 3", status: ["success","success","success","empty","empty","empty","empty"], streak: 3, lives: 3, totalDone: 3, modified: false, totalDays: 3)]
    let blurEffectView = BlurEffectView()
    let defaults = UserDefaults.standard
    
    var delegate: MainViewDelegate?
    
    
    @IBOutlet weak var addHabitButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var habitTableView: UITableView!
    

    override func viewDidLoad() {
        
//        NotificationCenter.default.addObserver(self, selector:#selector(self.calendarDayDidChange(_:)), name:NSNotification.Name.NSCalendarDayChanged, object:nil)
        
        
        
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
        updateDate()
        super.viewDidLoad()
    }
   
    
    @IBAction func addDayButton(_ sender: Any) {
       
        
//        let existingCell = self.habitTableView.visibleCells as! [CustomTableViewCell]
        
        for i in self.habits.indices {
            if self.habits[i].modified == false {
                self.habits[i].status[self.habits[i].totalDays % 7] = "failed"
                self.habits[i].lives -= 1
                
                
//                ---- kalo lives nya habis
                if self.habits[i].lives == 0 {
//                    let alertController = UIAlertController.init(title: "Habit Deleted", message: "You failed to maintain your habit", preferredStyle: .alert)
//
//                    alertController.addAction(UIAlertAction(title: "Ok", style: .default, handler: { [self] (action: UIAlertAction!) in
//                        self.blurEffectView.removeFromSuperview()
//                        self.habits.remove(at: i)
//                        self.habitTableView.reloadData()
//                    }))
//                                            self.habits.remove(at: i)
//                                            self.habitTableView.reloadData()
                    
//                    self.view.addSubview(blurEffectView)
//                    self.present(alertController, animated: true, completion: nil)
                }
//                ----
            }
            
                self.habits[i].modified = false // biar bisa di modified kembali
                self.habits[i].totalDays += 1 // biar total days dari tiap habitnya nambah
            if self.habits[i].totalDays % 7 == 0 && self.habits[i].totalDays != 0 { //reset statusnya jadi empty empty empty di minggu yang baru
                    self.habits[i].status = ["empty","empty","empty","empty","empty","empty","empty"]
                }
            
//            self.habits[i].modified = false // biar bisa di modified kembali
//            self.habits[i].totalDays += 1 // biar total days dari tiap habitnya nambah

            let cell = habitTableView.cellForRow(at: IndexPath(row: i, section: 0)) as! CustomTableViewCell
                for item in cell.historyStackView.arrangedSubviews {
                    item.removeFromSuperview()
                }

            for status in habits[i].status { // buat nge update value status dari historystackview
                let statusView = UIImageView()
                statusView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)

                if status == "success" {
                    statusView.image =  UIImage(named: "days-success")
                } else if status == "failed" {
                    statusView.image =  UIImage(named: "days-failed")
                } else {
                    statusView.image =  UIImage(named: "days-empty")
                }

                cell.historyStackView.addArrangedSubview(statusView)
//                existingCell[i].totalLivesLabel.text = String(self.habits[i].lives)
//
//
//            existingCell[i].totalStreaksLabel.text = String(habits[i].totalDays)
////                existingCell[i].historyStackView.removeFromSuperview()
//                existingCell[i].historyStackView.addArrangedSubview(statusView)
//                print("\( existingCell[i].habit.name) = \(existingCell[i].historyStackView.subviews.count)")
            }
            print(self.habits[i])
        }
        

        DispatchQueue.main.async {
            for cell in self.habitTableView.visibleCells as! [CustomTableViewCell] {
                cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
                }
            
        }
      
        
        let date = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "E, d MMM yyyy"
        dateLabel.text = formatter.string(from: modifiedDate)
        
    }
    
    
    @IBAction func addHabitButton(_ sender: Any) {
        
        let blurEffect = UIBlurEffect(style: .dark)
        let blurVisualEffectView = UIVisualEffectView(effect: blurEffect)
        blurVisualEffectView.frame = view.bounds
        blurVisualEffectView.alpha = 0.4
        
        let alertController = UIAlertController.init(title: "New Habit", message: "that will determine your future", preferredStyle: .alert)
        
        alertController.addTextField { (textField : UITextField!) -> Void in
               textField.placeholder = "Enter new habit"
           }
        
        alertController.addAction(UIAlertAction(title: "add", style: .default, handler: { [self] (action: UIAlertAction!) in
            let habitName = alertController.textFields![0] as UITextField
            let newHabit = HabitModel(name: habitName.text!)
            self.habits.append(newHabit)
            habitTableView.reloadData()
            
            self.blurEffectView.removeFromSuperview()
        }))
        
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            self.blurEffectView.removeFromSuperview()
         }))

        
        self.view.addSubview(blurEffectView)
        self.present(alertController, animated: true, completion: nil)
    }
    
    func updateDate(){
        let date = Date()
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "dd"
        let day = formatter.string(from: date)
        defaults.set(day, forKey: "latestDay")
    }
    
    func restartButton(cell: CustomTableViewCell){
        cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
    }
    
}

extension ViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: false)
    }
}

extension ViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return habits.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.habit = habits[indexPath.row]
        cell.selectionStyle = .none
        cell.delegate = self
        cell.mainView = self
        return cell
    }
}


extension ViewController : ModifyHabitCardDelegate {    
    
    func didUpdateHabitValue(cell: CustomTableViewCell) {
//        let indexPath = self.habitTableView.indexPath(for: cell)
//        
//        if cell.habit.modified == false{
//            
//            cell.totalDaysLabel.text = String(cell.habit.totalDone)
//            cell.totalStreaksLabel.text = String(cell.habit.totalDays)
//            cell.habit.modified = true
//            cell.markDoneButton.setImage(UIImage(named: "done-button"), for: .normal)
//            cell.habit.status[(cell.habit.totalDays) % 7] = "success"
//            cell.habit.totalDone += 1
//            cell.habit.streak += 1
//            
//                }else{
//                    cell.habit.totalDone -= 1
//                    cell.habit.streak -= 1
//                    cell.habit.modified = false
//                    cell.totalDaysLabel.text = String(cell.habit.totalDone)
//                    cell.totalStreaksLabel.text = String(cell.habit.totalDays)
//                    cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
//                    cell.habit.status[(cell.habit.totalDays) % 7] = "empty"
//               
//                }
//        habits[indexPath!.row] = cell.habit
    }
}
