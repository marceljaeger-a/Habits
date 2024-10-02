//
//  HabitSymbole.swift
//  Habits
//
//  Created by Marcel Jäger on 30.09.24.
//

import Foundation
import SwiftUI

enum HabitSymbole: String, Codable, CaseIterable, Hashable {
    case listBullet = "list.bullet"
    case figureWalk = "figure.walk"
    case figureRun = "figure.run"
    case figureCooldown = "figure.cooldown"
    case figureFlexibility = "figure.flexibility"
    case figureMindAndBody = "figure.mind.and.body"
    case figureTwo = "figure.2"
//    case dumbbell
    case soccerball
    case football
    case tennisball
    case volleyball
    case bicycle
    
    case sunMax = "sun.max"
    case moonStars = "moon.stars"
    case dog
    case cat
    case graduationcap
//    case shower
    case house
    case camera
    
    var image: Image {
        Image(systemName: self.rawValue)
    }
}
