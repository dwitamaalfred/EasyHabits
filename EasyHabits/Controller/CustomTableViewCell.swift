//
//  CustomTableViewCell.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var habit = HabitModel(name: "", streak: 0)
    var totalDays = Int()
    var failed = Int()
    var status = false
    
    @IBOutlet weak var habitCardView: UIView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var totalLivesLabel: UILabel!
    @IBOutlet weak var totalStreaksLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var markDoneButton: UIButton!
    
    
    
    @IBOutlet weak var historyStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        habitCardView.layer.cornerRadius = 20
        historyStackView.distribution = .equalSpacing
        
        DispatchQueue.main.async {
            self.habitTitleLabel.text = self.habit.name
            self.totalDaysLabel.text = String(self.habit.daysCount)
            self.totalStreaksLabel.text = String(self.habit.streak)
            self.totalLivesLabel.text = String(self.habit.lives)
            self.updateRecords()
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func donePressed(_ sender: Any) {
        
        let counter = failed+totalDays
        
        if self.status == false{
            self.habit.daysCount += 1
            self.totalDaysLabel.text = String(self.habit.daysCount)
            self.status = true
            self.markDoneButton.setImage(UIImage(named: "done-button"), for: .normal)
            self.habit.status[counter] = "success"
        }else{
            self.habit.daysCount -= 1
            self.status = false
            self.totalDaysLabel.text = String(self.habit.daysCount)
            self.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
            self.habit.status[counter] = "empty"
        }
        
        print(habit.name)
        
        
    }
    
    
    func updateRecords(){
        
        for status in habit.status {
            
            print(status)
            
            let statusView = UIImageView()
            statusView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            
            if status == "success" {
                statusView.image =  UIImage(named: "days-success")
            } else if status == "failed" {
                statusView.image =  UIImage(named: "days-failed")
            } else {
                statusView.image =  UIImage(named: "days-empty")
            }
            
            
            historyStackView.addArrangedSubview(statusView)
        }
    }
    
}
