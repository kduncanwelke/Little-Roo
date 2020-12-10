//
//  KickViewModel.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 10/29/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData
import Charts

public class KickViewModel {
    
    public func loadKicks() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Kick>(entityName: "Kick")
        
        do {
            KickManager.loaded = try managedContext.fetch(fetchRequest)
            print("kicks loaded")
            
            KickManager.loaded.reverse()
            
            for kick in KickManager.loaded {
                if let hour = kick.hour {
                    KickManager.sessionKicks[Int(hour.id), default: []].append(kick)
                } else if let free = kick.free {
                    KickManager.freeKicks[Int(free.id), default: []].append(kick)
                }
            }
            
            // sort dictionary by key, then get first key
            if let num = KickManager.sessionKicks.sorted(by: { $0.0 > $1.0 }).first?.key {
                KickManager.hourSessionNumber = num
            }
            
            if let num = KickManager.freeKicks.sorted(by: { $0.0 > $1.0 }).first?.key {
                KickManager.freeSessionNumber = num
            }
         
        } catch let error as NSError {
            //alertDelegate?.displayAlert(with: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    public func addKick(date: Date, time: String, isHourSession: Bool) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save new kick
        let newKick = Kick(context: managedContext)
        
        if isHourSession {
            var hour = Hour(context: managedContext)
            hour.date = date
            hour.id = Int64(KickManager.hourSessionNumber)
            hour.timePassed = time
            KickManager.sessionKicks[Int(hour.id), default: []].insert(newKick, at: 0)
            newKick.hour = hour
        } else {
            var free = Free(context: managedContext)
            free.date = date
            free.id = Int64(KickManager.freeSessionNumber)
            free.timePassed = time
            KickManager.freeKicks[Int(free.id), default: []].insert(newKick, at: 0)
            newKick.free = free
        }
       
        // add to model, at the beginning so sorted by most recent
        KickManager.loaded.insert(newKick, at: 0)
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //alertDelegate?.displayAlert(with: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
    
    func retrieveSource(type: Int, section: Int) -> [Kick]? {
        if type == 0 {
            return KickManager.loaded
        } else if type == 1 {
            // reverse order so most recent is first by subtracting scetion from total sessions
            return KickManager.sessionKicks[KickManager.hourSessionNumber-section]
        } else {
           // reverse order so most recent is first by subtracting scetion from total sessions
            return KickManager.freeKicks[KickManager.freeSessionNumber-section]
        }
    }
    
    func isEmpty(type: Int) -> Bool {
        if type == 0 {
            return KickManager.loaded.isEmpty
        } else if type == 1 {
            return KickManager.sessionKicks.isEmpty
        } else {
            return KickManager.freeKicks.isEmpty
        }
    }
    
    func getSectionsTotal(type: Int) -> Int {
        if type == 0 {
            return 1
        } else if type == 1 {
            return KickManager.hourSessionNumber
        } else {
            return KickManager.freeSessionNumber
        }
    }
    
    func getHeading(section: Int, segment: Int) -> String {
        if segment == 0 {
            return "All Kicks"
        } else if segment == 1 {
            // add 1 to section as sessions are indexed at one instead of zero
            // to prevent confusion on the user end
            if let session = KickManager.sessionKicks[KickManager.hourSessionNumber-section]?.first?.hour?.id {
                return "Session #\(session)"
            } else {
                return "Session"
            }
        } else {
            // add 1 to section as sessions are indexed at one instead of zero
            // to prevent confusion on the user end
            if let session = KickManager.freeKicks[KickManager.freeSessionNumber-section]?.first?.free?.id {
                return "Session #\(session)"
            } else {
                return "Session"
            }
        }
    }
    
    func getTimePassed(index: IndexPath, segment: Int) -> String? {
        if segment == 0 {
            if let hour = KickManager.loaded[index.row].hour {
                return hour.timePassed
            } else if let free = KickManager.loaded[index.row].free {
                return free.timePassed
            } else {
                return nil
            }
        } else if segment == 1 {
            return KickManager.sessionKicks[KickManager.hourSessionNumber-index.section]?[index.row].hour?.timePassed
        } else {
            return KickManager.freeKicks[KickManager.freeSessionNumber-index.section]?[index.row].free?.timePassed
        }
    }
    
    func getDate(index: IndexPath, segment: Int) -> Date? {
        if segment == 0 {
            if let hour = KickManager.loaded[index.row].hour {
                return hour.date
            } else if let free = KickManager.loaded[index.row].free {
                return free.date
            } else {
                return nil
            }
        } else if segment == 1 {
            return KickManager.sessionKicks[KickManager.hourSessionNumber-index.section]?[index.row].hour?.date
        } else {
            return KickManager.freeKicks[KickManager.freeSessionNumber-index.section]?[index.row].free?.date
        }
    }
    
    func setSessionType(index: Int) {
        if index == 0 {
            KickManager.sessionType = .hour
        } else if index == 1 {
            KickManager.sessionType = .free
        } else {
            KickManager.sessionType = .none
        }
    }
    
    func retrieveSessionType() -> SessionType {
        return KickManager.sessionType
    }
    
    func newSession() {
        switch KickManager.sessionType {
        case .hour:
            KickManager.hourSessionNumber += 1
        case .free:
            KickManager.freeSessionNumber += 1
        case .none:
            return
        }
        
    }
    
    func getLastKick() -> Date? {
        if let hour = KickManager.loaded.first?.hour {
            return hour.date
        } else if let free = KickManager.loaded.first?.free {
            return free.date
        } else {
            return nil
        }
    }
    
    func kicksToday() -> Int {
        let calendar = Calendar.current
        var kicks = 0
       
        for kick in KickManager.loaded {
            if let hour = kick.hour {
                if let kickDate = hour.date {
                    if calendar.isDateInToday(kickDate) {
                        kicks += 1
                    }
                }
            } else if let free = kick.free {
                if let kickDate = free.date {
                    if calendar.isDateInToday(kickDate) {
                        kicks += 1
                    }
                }
            }
        }
        
        return kicks
    }
    
    func kicksHour() -> Int {
        let calendar = Calendar.current
        let hourNow = Calendar.current.component(.hour, from: Date())
        var kicks = 0
        
        for kick in KickManager.loaded {
            if let hour = kick.hour {
                if let kickDate = hour.date {
                    if calendar.isDateInToday(kickDate) && Calendar.current.component(.hour, from: kickDate) == hourNow {
                        kicks += 1
                    }
                }
            } else if let free = kick.free {
                if let kickDate = free.date {
                    if calendar.isDateInToday(kickDate) && Calendar.current.component(.hour, from: kickDate) == hourNow {
                        kicks += 1
                    }
                }
            }
        }
        
        return kicks
    }
    
    func getGraphData(type: Int, startDate: Date?) -> [ChartDataEntry]? {
        // hourly info, show for one day
        if type == 0 {
            KickManager.hourKicks.removeAll()
            
            guard let date = startDate else { return nil }
            
            var entries: [ChartDataEntry] = []
            
            sortKicksByHour(date: date)
            
            for i in 1...24 {
                if let kicks = KickManager.hourKicks[i] {
                    var entry = ChartDataEntry(x: Double(i), y: Double(kicks.count))
                    entries.append(entry)
                } else {
                    var entry = ChartDataEntry(x: Double(i), y: Double(0))
                    entries.append(entry)
                }
            }
            
            return entries
        } else {
            // date info, show seven days
            KickManager.dayKicks.removeAll()
            
            guard var date = startDate else { return nil }
            var dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            
            var entries: [ChartDataEntry] = []
            
            sortKicksByDate()
            
            for i in 1...7 {
                var stringDate = dateFormatter.string(from: date)
                
                if let kicks = KickManager.dayKicks[stringDate] {
                    var entry = ChartDataEntry(x: Double(i), y: Double(kicks.count))
                    entries.append(entry)
                } else {
                    var entry = ChartDataEntry(x: Double(i), y: Double(0))
                    entries.append(entry)
                }
                
                date = Calendar.current.date(byAdding: .day, value: -1, to: date)!
            }
            
            return entries
        }
    }
    
    func sortKicksByHour(date: Date) {
        let calendar = Calendar.current
       
        for kick in KickManager.loaded {
            if let hour = kick.hour {
                if let kickDate = hour.date {
                    if calendar.isDate(kickDate, inSameDayAs: date) {
                        let kickDateHour = calendar.component(.hour, from: kickDate)
                        KickManager.hourKicks[kickDateHour, default: []].append(kick)
                    }
                }
            } else if let free = kick.free {
                if let kickDate = free.date {
                    if calendar.isDate(kickDate, inSameDayAs: date) {
                        let kickDateHour = calendar.component(.hour, from: kickDate)
                        KickManager.hourKicks[kickDateHour, default: []].append(kick)
                    }
                }
            }
        }
    }
    
    func sortKicksByDate() {
        let calendar = Calendar.current
        var dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        for kick in KickManager.loaded {
            if let hour = kick.hour {
                if let kickDate = hour.date {
                    let string = dateFormatter.string(from: kickDate)
                    KickManager.dayKicks[string, default: []].append(kick)
                }
            } else if let free = kick.free {
                if let kickDate = free.date {
                    let string = dateFormatter.string(from: kickDate)
                    KickManager.dayKicks[string, default: []].append(kick)
                }
            }
        }
    }
}
