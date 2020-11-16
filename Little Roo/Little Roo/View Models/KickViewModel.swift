//
//  KickViewModel.swift
//  Little Roo
//
//  Created by Kate Duncan-Welke on 10/29/20.
//  Copyright © 2020 Kate Duncan-Welke. All rights reserved.
//

import Foundation
import CoreData

public class KickViewModel {
    
    public func loadKicks() {
        var managedContext = CoreDataManager.shared.managedObjectContext
        var fetchRequest = NSFetchRequest<Kick>(entityName: "Kick")
        
        do {
            KickManager.loaded = try managedContext.fetch(fetchRequest)
            print("kicks loaded")
            
            for kick in KickManager.loaded {
                if kick.session != 0 {
                    print(kick.session)
                    KickManager.sessionKicks[Int(kick.session), default: []].append(kick)
                }
            }
            
            // sort dictionary by key, then get last key
            if let num = KickManager.sessionKicks.sorted(by: { $0.0 < $1.0 }).last?.key {
                KickManager.sessionNumber = num
                print("last session number")
                print(num)
            }
            
        } catch let error as NSError {
            //alertDelegate?.displayAlert(with: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    public func addKick(date: Date, isHourSession: Bool) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save new kick
        let newKick = Kick(context: managedContext)
        newKick.time = date
        
        if isHourSession {
            newKick.session = Int64(KickManager.sessionNumber)
        } else {
            newKick.session = 0
        }
        
        print(newKick.session)
        // add to model
        KickManager.loaded.append(newKick)
        if newKick.session != 0 {
            KickManager.sessionKicks[Int(newKick.session), default: []].append(newKick)
        }
        
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
        } else {
            // 0 is reserved for non-session kicks, add 1 to index 
            return KickManager.sessionKicks[section+1]
        }
    }
    
    func getSectionsTotal(type: Int) -> Int {
        if type == 0 {
            return 1
        } else {
            return KickManager.sessionNumber
        }
    }
    
    func getHeading(section: Int, segment: Int) -> String {
        if segment == 0 {
            return "All Kicks"
        } else {
            return "Session \(KickManager.sessionKicks[section+1])"
        }
    }
    
    func getDate(index: IndexPath, segment: Int) -> Date? {
        if segment == 0 {
            return KickManager.loaded[index.row].time
        } else {
            return KickManager.sessionKicks[index.section][index.row].time
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
        KickManager.sessionNumber += 1
    }
    
    func getLastKick() -> Date? {
        return KickManager.loaded.last?.time
    }
    
    func kicksToday() -> Int {
        let calendar = Calendar.current
        var kicks = 0
       
        for kick in KickManager.loaded {
            if let kickDate = kick.time {
                if calendar.isDateInToday(kickDate) {
                    kicks += 1
                }
            }
        }
        
        return kicks
    }
    
    func kicksHour() -> Int {
        let calendar = Calendar.current
        let hour = Calendar.current.component(.hour, from: Date())
        var kicks = 0
        
        for kick in KickManager.loaded {
            if let kickDate = kick.time {
                if calendar.isDateInToday(kickDate) && Calendar.current.component(.hour, from: kickDate) == hour {
                    kicks += 1
                }
            }
        }
        
        return kicks
    }
}
