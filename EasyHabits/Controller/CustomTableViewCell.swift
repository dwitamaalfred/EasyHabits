//
//  CustomTableViewCell.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

protocol ModifyHabitCardDelegate {
    func didUpdateHabitValue(cell:CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell, MainViewDelegate {
   
    func changeButtonStyle() {
        print("test")
        markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
    }
    
    var habit = HabitModel(name: "", streak: 0)
    var totalDays = Int()
    var failed = Int()
    var mainView = ViewController()
    
    
    var delegate: ModifyHabitCardDelegate?
    
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
        
        mainView.delegate = self
        
        updateStyling()
        
        DispatchQueue.main.async {
            
            self.habitTitleLabel.text = self.habit.name
            self.totalDaysLabel.text = String(self.habit.daysCount)
            self.totalStreaksLabel.text = String(self.habit.daysCount)
            self.totalLivesLabel.text = String(self.habit.lives)
            
            self.updateRecords()
            
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        delegate?.didUpdateHabitValue(cell: self)
        for item in self.historyStackView.arrangedSubviews {
            item.removeFromSuperview()
        }
        self.updateRecords()
    }
    
 
    
    func updateRecords(){
    
        for status in habit.status {
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
    
    func updateStyling(){
        habitCardView.layer.cornerRadius = 20
        historyStackView.distribution = .equalSpacing
        
    
        markDoneButton.layer.shadowColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0.25).cgColor
        markDoneButton.layer.shadowOffset = CGSize(width: 0.0, height: 5.0)
        markDoneButton.layer.shadowOpacity = 1.0
        markDoneButton.layer.shadowRadius = 5
        markDoneButton.layer.masksToBounds = false
        markDoneButton.layer.cornerRadius = 4.0
    }
    
}
