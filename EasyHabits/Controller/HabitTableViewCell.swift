//
//  HabitTableViewCell.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

class HabitTableViewCell: UITableViewCell {
    
    @IBOutlet weak var habitCellView: UIView!
    @IBOutlet weak var habitName: UILabel!
    @IBOutlet weak var optionButton: UIButton!
    @IBOutlet weak var markDoneButton: UIButton!
    @IBOutlet weak var daysLabel: UILabel!
    @IBOutlet weak var streakLabel: UILabel!
    @IBOutlet weak var livesLabel: UILabel!
    @IBOutlet weak var recordHorizontalStackView: UIStackView!
    
    
    override func awakeFromNib() {
        
        super.awakeFromNib()
        
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    

    
}
