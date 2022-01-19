//
//  HabitModel.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 16/01/22.
//

import Foundation

struct HabitModel: Codable {
    var name : String
    var status : [String] = ["empty","empty","empty","empty","empty","empty","empty"]
    var lives : Int = 3
    var totalDone : Int = 0
    var modified : Bool = false
    var totalDays : Int = 0
}
