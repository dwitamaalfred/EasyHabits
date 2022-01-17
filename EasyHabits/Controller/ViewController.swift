//
//  ViewController.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

protocol MainViewDelegate {
    func changeButtonStyle()
}

class ViewController: UIViewController {
    
    var habits = [HabitModel(name: "Coding Everyday", status: ["empty","empty","empty","empty","empty","empty","empty"])]
    let blurEffectView = BlurEffectView()
    let defaults = UserDefaults.standard
    var totalDays = Int()
    var failed = Int()
    
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
        
        
        // Do any additional setup after loading the view.
    }
    
//    @objc func calendarDayDidChange(_ notification : NSNotification) {
//        print(habits)
//
//        DispatchQueue.main.async {
//            for i in self.habits.indices {
//                self.habits[i].modified = false
//            }
//            self.habitTableView.reloadData()
//        }
//    }
    
   
    
    @IBAction func addDayButton(_ sender: Any) {
        for i in self.habits.indices {
            self.habits[i].modified = false
            
        }
        
        DispatchQueue.main.async {
            for cell in self.habitTableView.visibleCells as! [CustomTableViewCell] {
                       //do someting with the cell here.
                cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
                   }
            self.habitTableView.reloadData()
        }
        
        //--------------------------------------------------------------------------------------------------------//

        let date = Date()
        let modifiedDate = Calendar.current.date(byAdding: .day, value: 1, to: date)!
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.locale = .current
        formatter.dateFormat = "E, d MMM yyyy"
        dateLabel.text = formatter.string(from: modifiedDate)

        print(habits)

//        do {
//            // Create JSON Encoder
//            let encoder = JSONEncoder()
//
//            // Encode Note
//            let data = try encoder.encode(habits)
//
//            // Write/Set Data
//            UserDefaults.standard.set(data, forKey: "latestHabit")
//
//        } catch {
//            print("Unable to Encode Note (\(error))")
//        }
//
//
//        if let data = UserDefaults.standard.data(forKey: "notes") {
//            do {
//                // Create JSON Decoder
//                let decoder = JSONDecoder()
//
//                // Decode Note
//                habits = try decoder.decode([HabitModel].self, from: data)
//
//            } catch {
//                print("Unable to Decode Notes (\(error))")
//            }
//        }

        //--------------------------------------------------------------------------------------------------------//
        
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

extension ViewController : UITableViewDelegate, ModifyHabitCardDelegate {
    
    func didUpdateHabitValue(cell: CustomTableViewCell) {
        let indexPath = self.habitTableView.indexPath(for: cell)
        
        let counter = failed+totalDays
//               print(indexPath!.row)
        if cell.habit.modified == false{
            cell.habit.daysCount += 1
            cell.habit.streak += 1
            cell.totalDaysLabel.text = String(cell.habit.daysCount)
            cell.totalStreaksLabel.text = String(cell.habit.streak)
            cell.habit.modified = true
            cell.markDoneButton.setImage(UIImage(named: "done-button"), for: .normal)
            cell.habit.status[counter] = "success"
        //            print(self.habit.streak)
        
                }else{
                    cell.habit.daysCount -= 1
                    cell.habit.streak -= 1
                    cell.habit.modified = false
                    cell.totalDaysLabel.text = String(cell.habit.daysCount)
                    cell.totalStreaksLabel.text = String(cell.habit.streak)
                    cell.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
                    cell.habit.status[counter] = "empty"
                }
        habits[indexPath!.row] = cell.habit
    }
    
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
        return cell
    }
}


