//
//  ChallengeManager.swift
//  drawinspiration
//
//  Created by Mark Danforth on 04/09/2017.
//  Copyright © 2017 Mark Danforth. All rights reserved.
//

import UIKit
import CoreData

class ChallengeManager: NSObject {
    static func createChallenge(medium: String, subject: String, timeLimit: TimeInterval, repetitions: Int) -> NSManagedObject? {
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let entity = NSEntityDescription.entity(forEntityName: "ChallengeEntity", in: managedContext)
        
        let challenge = NSManagedObject(entity: entity!, insertInto: managedContext)
        
        challenge.setValue(medium, forKeyPath: "medium")
        challenge.setValue(subject, forKeyPath: "subject")
        challenge.setValue(timeLimit, forKeyPath: "timeLimit")
        challenge.setValue(repetitions, forKeyPath: "repetitons")
        
        do {
            try managedContext.save()
            return challenge
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
            return nil
        }
    }
}
