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
    
    static var hourSessionNumber = 0
    static var sessionKicks: [Int: [Kick]] = [:]
    
    static var freeSessionNumber = 0
    static var freeKicks: [Int: [Kick]] = [:]
}

enum SessionType {
    case hour
    case free
    case none
}
