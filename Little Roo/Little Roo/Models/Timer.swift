//
//  Timer.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/13/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

class TimerManager {
    
    static var seconds = 0
    static var time = 0
    static var timer: Timer?
    static var stopped = true
    
    static func beginTimer(label: UILabel) {
        
        stopped = false
        // hour total in seconds
        let maxTime = 3600
        
        time = maxTime
        seconds = maxTime
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            seconds -= 1
            print(seconds)
            if seconds < 60 {
                if seconds < 10 {
                    label.text = "0:0\(seconds)"
                } else {
                    label.text = "0:\(Int(seconds))"
                }
            } else if seconds >= 3600 {
                let hour = Int(seconds / 3600)
                let minute = Int((seconds - (hour * 3600)) / 60)
                let second = seconds % 60
                
                if minute < 10 {
                    if second < 10 {
                        label.text = "\(hour):0\(minute):0\(second)"
                        print("sec")
                    } else {
                        label.text = "\(hour):0\(minute):\(second)"
                        print("minute")
                    }
                }
                
                if minute > 10 && second < 10 {
                    label.text = "\(hour):\(minute):0\(second)"
                } else if minute > 10 && second > 10 {
                    label.text = "\(hour):\(minute):\(second)"
                }
            } else {
                let minute = seconds / 60
                let second = seconds % 60
                if second < 10 {
                    label.text = "\(minute):0\(second)"
                } else {
                    label.text = "\(minute):\(second)"
                }
            }
        }
        
        timer?.fire()
    }
    
    static func stopTimer() {
        timer?.invalidate()
        seconds = 0
        stopped = true
    }
    
}

class CountupTimer {
    
    static var seconds = 0
    static var time = 0
    static var timer: Timer?
    static var stopped = true
    
    static func beginTimer(label: UILabel) {
        
        timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            seconds += 1
            print(seconds)
            if seconds < 60 {
                if seconds < 10 {
                    label.text = "0:0\(seconds)"
                } else {
                    label.text = "0:\(Int(seconds))"
                }
            } else if seconds >= 3600 {
                let hour = Int(seconds / 3600)
                let minute = Int((seconds - (hour * 3600)) / 60)
                let second = seconds % 60
                
                if minute < 10 {
                    if second < 10 {
                        label.text = "\(hour):0\(minute):0\(second)"
                        print("sec")
                    } else {
                        label.text = "\(hour):0\(minute):\(second)"
                        print("minute")
                    }
                }
                
                if minute > 10 && second < 10 {
                    label.text = "\(hour):\(minute):0\(second)"
                } else if minute > 10 && second > 10 {
                    label.text = "\(hour):\(minute):\(second)"
                }
            } else {
                let minute = seconds / 60
                let second = seconds % 60
                if second < 10 {
                    label.text = "\(minute):0\(second)"
                } else {
                    label.text = "\(minute):\(second)"
                }
            }
        }
        
        timer?.fire()
    }
    
    static func stopTimer() {
        timer?.invalidate()
        seconds = 0
        stopped = true
    }
    
}
