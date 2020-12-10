//
//  Timer.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 11/13/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import UIKit

public class TimerViewModel {
    
    static var seconds = 0
    static var time = 0
    static var timer: Timer?
    static var stopped = true
    
    func beginTimer(label: UILabel) {
        
        TimerViewModel.stopped = false
        // hour total in seconds
        let maxTime = 3600
        TimerViewModel.seconds = maxTime
        
        TimerViewModel.time = maxTime
        TimerViewModel.seconds = maxTime
        
        TimerViewModel.timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { timer in
            print("Timer fired!")
            TimerViewModel.seconds -= 1
           
            if TimerViewModel.seconds == 0 {
                self.stopTimer()
                self.stopCountUpTimer()
            } else if TimerViewModel.seconds < 60 {
                if TimerViewModel.seconds < 10 {
                    label.text = "0:0\(TimerViewModel.seconds)"
                } else {
                    label.text = "0:\(Int(TimerViewModel.seconds))"
                }
            } else if TimerViewModel.seconds >= 3600 {
                let hour = Int(TimerViewModel.seconds / 3600)
                let minute = Int((TimerViewModel.seconds - (hour * 3600)) / 60)
                let second = TimerViewModel.seconds % 60
                
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
                let minute = TimerViewModel.seconds / 60
                let second = TimerViewModel.seconds % 60
                if second < 10 {
                    label.text = "\(minute):0\(second)"
                } else {
                    label.text = "\(minute):\(second)"
                }
            }
        }
        
        TimerViewModel.timer?.fire()
    }
    
    func stopTimer() {
        TimerViewModel.timer?.invalidate()
        TimerViewModel.seconds = 0
        TimerViewModel.stopped = true
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "endSession"), object: nil)
    }
    
    static var countUpSeconds = 0
    static var countUpTime = 0
    static var countUpTimer: Timer?
    static var countUpStopped = true
    
    func beginCountUpTimer(label: UILabel) {
        
        TimerViewModel.countUpTimer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { ctimer in
            print("Timer fired!")
            TimerViewModel.countUpSeconds += 1
            
            if TimerViewModel.countUpSeconds < 60 {
                if TimerViewModel.countUpSeconds < 10 {
                    label.text = "0:0\(TimerViewModel.countUpSeconds)"
                } else {
                    label.text = "0:\(Int(TimerViewModel.countUpSeconds))"
                }
            } else if TimerViewModel.countUpSeconds >= 3600 {
                let hour = Int(TimerViewModel.countUpSeconds / 3600)
                let minute = Int((TimerViewModel.countUpSeconds - (hour * 3600)) / 60)
                let second = TimerViewModel.countUpSeconds % 60
                
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
                let minute = TimerViewModel.countUpSeconds / 60
                let second = TimerViewModel.countUpSeconds % 60
                if second < 10 {
                    label.text = "\(minute):0\(second)"
                } else {
                    label.text = "\(minute):\(second)"
                }
            }
        }
        
        TimerViewModel.countUpTimer?.fire()
    }
    
    func stopCountUpTimer() {
        TimerViewModel.countUpTimer?.invalidate()
        TimerViewModel.countUpSeconds = 0
        TimerViewModel.countUpStopped = true
    }
}
