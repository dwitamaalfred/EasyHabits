//
//  ViewController.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    var habits = [HabitModel(name: "Coding Everyday", dayCount: [true,false,true,true], streak: 5, lives: 3),
                  HabitModel(name: "Coding Everyday", dayCount: [true,false,true,true], streak: 5, lives: 3),
                  HabitModel(name: "Coding Everyday", dayCount: [true,false,true,true], streak: 5, lives: 3)]
    
    @IBOutlet weak var addHabitButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var habitTableView: UITableView!
    

    override func viewDidLoad() {
        
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.register(UINib(nibName: "HabitTableViewCell", bundle: nil), forCellReuseIdentifier: "HabitTableViewCell")
        habitTableView.rowHeight = 200
    
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "HabitTableViewCell", for: indexPath) as! HabitTableViewCell
        cell.habitName.text = habits[indexPath.row].name
        cell.daysLabel.text = String(habits[indexPath.row].dayCount.count)
        cell.streakLabel.text = String(habits[indexPath.row].streak)
        cell.livesLabel.text = String(habits[indexPath.row].lives)
        cell.selectionStyle = .none
        return cell
    }
    
    
}
