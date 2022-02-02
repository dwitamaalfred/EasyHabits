//
//  CustomTableViewCell.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit
import CoreData

protocol ModifyHabitCardDelegate {
    func didUpdateHabitValue(cell:CustomTableViewCell)
    func settingCellPressed(cell:CustomTableViewCell)
}

class CustomTableViewCell: UITableViewCell {

    var habit : HabitsData!
    var modified = Bool()
    
    @IBOutlet weak var cetagoryDoneLabel: UILabel!
    @IBOutlet weak var categoryDaysLabel: UILabel!
    @IBOutlet weak var categoryLivesLabel: UILabel!
    
    var delegate: ModifyHabitCardDelegate?
    
    @IBOutlet weak var habitCardView: UIView!
    
    @IBOutlet weak var settingButton: UIButton!
    
    @IBOutlet weak var totalDaysDone: UILabel!
    @IBOutlet weak var totalLivesLabel: UILabel!
    @IBOutlet weak var totalDaysLabel: UILabel!
    @IBOutlet weak var habitTitleLabel: UILabel!
    @IBOutlet weak var markDoneButton: UIButton!
    @IBOutlet weak var historyStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        updateStyling()
//        DispatchQueue.main.async {
//            self.updateRecords()
//        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    @IBAction func settingButtonPressed(_ sender: Any) {
        delegate?.settingCellPressed(cell: self)
//        let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
//        let editAction = UIAlertAction(title: "edit", style: .default) { (action) in
//            print("edit pressed")
//        }
//        let deleteAction = UIAlertAction(title: "delete", style: .default) { (action) in
//            print("delete pressed")
//        }
//        let cancelAction = UIAlertAction(title: "cancel", style: .default) { (action) in
//            print("cancel pressed")
//        }
//        actionSheet.addAction(editAction)
//        actionSheet.addAction(deleteAction)
//        actionSheet.addAction(cancelAction)
        
    }
    
    
    @IBAction func donePressed(_ sender: UIButton) {
        //        var habitStatus = habit.status as! [String]
//        print("done pressed from \(self.habitTitleLabel.text)")
//        self.animateView(sender)
//        if habit.modified == false {
//
//            self.markDoneButton.setImage(UIImage(named: "done-button"), for: .normal)
//        }else{
//
//            self.markDoneButton.setImage(UIImage(named: "check-button"), for: .normal)
//        }
        delegate?.didUpdateHabitValue(cell: self)
        updateHabit()
    }
    
    func updateHabit(){
        
        self.habitTitleLabel.text = self.habit!.name
        self.totalDaysDone.text = String(self.habit!.totalDone)
        self.totalDaysLabel.text = String(self.habit!.totalDays)
        self.totalLivesLabel.text = String(self.habit!.lives)
        
//        for status in habit.status {
//            let statusView = UIImageView()
//            statusView.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
//
//            if status == "success" {
//                statusView.image =  UIImage(named: "days-success")
//            } else if status == "failed" {
//                statusView.image =  UIImage(named: "days-failed")
//            } else {
//                statusView.image =  UIImage(named: "days-empty")
//            }
//            historyStackView.addArrangedSubview(statusView)
//        }
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
//        markDoneButton.translatesAutoresizingMaskIntoConstraints = false
    }
    
//    fileprivate func animateView(_ viewToAnimate: UIButton){
//
//        UIView.animate(withDuration: 0, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
//            viewToAnimate.transform = CGAffineTransform(scaleX: 0.92, y: 0.92)
//            print("aniamte in")
//        } completion: { (_) in
//            print("aniamte out")
//            UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseIn) {
//                viewToAnimate.transform = CGAffineTransform(scaleX: 1, y: 1)
//            }
//
//        }
//    }
    

    
}




