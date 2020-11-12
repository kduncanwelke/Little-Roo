//
//  KickManager.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 10/29/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation

struct KickManager {
    static var loaded: [Kick] = []
    
    static var sessionType: SessionType = .none
}

enum SessionType {
    case hour
    case free
    case none
}