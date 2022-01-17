//
//  ViewController.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

class ViewController: UIViewController {
    
    var habits = [HabitModel(name: "Coding Everyday", status: ["empty","empty","empty","empty","empty","empty","empty"])]
    let blurEffectView = BlurEffectView()
    
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
