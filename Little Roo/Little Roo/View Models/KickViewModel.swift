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
            
            for kick in KickManager.loaded.reversed() {
                if kick.session != nil {
                    KickManager.sessionNumber = Int(kick.session)
                    KickManager.sessionKicks.append(kick)
                }
            }
            
            KickManager.sessionKicks.reverse()
            
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
            newKick.session = Int16(KickManager.sessionNumber)
        }
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //alertDelegate?.displayAlert(with: "Save failed", message: "Notice: Data has not successfully been saved.")
        }
    }
    
    func retrieveSource(section: Int) -> [Kick] {
        if section == 0 {
            return KickManager.loaded
        } else {
            return KickManager.sessionKicks
        }
    }
    
    func getSessionSectionsTotal() -> Int {
        return KickManager.sessionNumber + 1
    }
    
    func getDate(index: IndexPath) -> Date? {
        return KickManager.loaded[index.row].time
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
        KickManager.sessionNumber += 1
        return KickManager.sessionType
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
