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
            
        } catch let error as NSError {
            //alertDelegate?.displayAlert(with: "Could not retrieve data", message: "\(error.userInfo)")
        }
    }
    
    public func addKick(date: Date) {
        var managedContext = CoreDataManager.shared.managedObjectContext
        
        // save new kick
        let newKick = Kick(context: managedContext)
        newKick.time = date
        
        do {
            try managedContext.save()
            print("saved")
        } catch {
            // this should never be displayed but is here to cover the possibility
            //alertDelegate?.displayAlert(with: "Save failed", message: "Notice: Data has not successfully been saved.")
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
}
