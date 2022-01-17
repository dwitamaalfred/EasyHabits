//
//  CustomTableViewCell.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import UIKit

class CustomTableViewCell: UITableViewCell {

    var totalDays = 7
    
    
    @IBOutlet weak var day1view: UIImageView!
    @IBOutlet weak var day2view: UIImageView!
    @IBOutlet weak var day3view: UIImageView!
    @IBOutlet weak var day4view: UIImageView!
    @IBOutlet weak var day5view: UIImageView!
    @IBOutlet weak var day6view: UIImageView!
    @IBOutlet weak var day7view: UIImageView!
    
    @IBOutlet weak var historyStackView: UIStackView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
