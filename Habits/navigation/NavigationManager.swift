//
//  NavigationManager.swift
//  Habits
//
//  Created by Marcel Jäger on 10.10.24.
//

import Foundation
import SwiftUI

@Observable final class NavigationManager {
    var path: NavigationPath
    
    init(path: NavigationPath = .init()) {
        self.path = path
    }
}
