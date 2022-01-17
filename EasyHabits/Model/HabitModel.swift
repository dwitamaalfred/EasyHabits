//
//  HabitModel.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import Foundation

struct HabitModel {
    var name : String
    var status : [String] = ["empty","empty","empty","empty","empty","empty","empty"]
    var streak : Int = 0
    var lives : Int = 3
    var daysCount : Int = 0
}
