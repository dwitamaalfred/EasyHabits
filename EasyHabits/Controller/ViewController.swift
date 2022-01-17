//
//  ViewController.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    var habits = [HabitModel(name: "Coding Everyday", status: ["emoty","empty","empty","empty","empty","empty","empty"],streak: 0),
                  HabitModel(name: "Coding Everyday 1",status: ["success","success","failed","empty","empty","empty","empty"], streak: 3),
                  HabitModel(name: "Coding Everyday 2",status: ["success","success","failed","empty","empty","empty","empty"], streak: 2)]
    
    @IBOutlet weak var addHabitButton: UIButton!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var habitTableView: UITableView!
    

    override func viewDidLoad() {
        
        
        habitTableView.delegate = self
        habitTableView.dataSource = self
        habitTableView.register(UINib(nibName: "CustomTableViewCell", bundle: nil), forCellReuseIdentifier: "CustomTableViewCell")
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
        let cell = tableView.dequeueReusableCell(withIdentifier: "CustomTableViewCell", for: indexPath) as! CustomTableViewCell
        cell.habit = habits[indexPath.row]
        cell.selectionStyle = .none
        return cell
    }
    
    
}
