//
//  Challenge.swift
//  drawinspiration
//
//  Created by Mark Danforth on 12/08/2017.
//  Copyright © 2017 Mark Danforth. All rights reserved.
//

import UIKit
import os.log

class Challenge: NSObject, NSCoding {
    // MARK: Properties
    
    var medium: String
    var subject: String
    var timeLimit: TimeInterval
    var created: Date?
    var image: UIImage?
    var repetitions: Int = 1
    
    // MARK: Archiving paths
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!
    static let ArchiveURL = DocumentsDirectory.appendingPathComponent("challenges")
    
    // MARK: Types
    struct PropertyKey {
        static let medium = "medium"
        static let subject = "subject"
        static let timeLimit = "timeLimit"
        static let created = "created"
        static let image = "image"
    }
    
    // MARK: Initialisation
    
    init(medium: String, subject: String, timeLimit: TimeInterval) {
        self.medium = medium
        self.subject = subject
        self.timeLimit = timeLimit
    }
    
    // MARK: NSCoding
    
    func encode(with aCoder: NSCoder) {
        if created == nil {
            created = Date()
        }
        
        aCoder.encode(medium, forKey: PropertyKey.medium)
        aCoder.encode(subject, forKey: PropertyKey.subject)
        aCoder.encode(timeLimit, forKey: PropertyKey.timeLimit)
        aCoder.encode(image, forKey: PropertyKey.image)
        aCoder.encode(Date(), forKey: PropertyKey.created)
    }
    
    required convenience init?(coder aDecoder: NSCoder) {
        self.init(medium: aDecoder.decodeObject(forKey: PropertyKey.medium) as! String,
                  subject: aDecoder.decodeObject(forKey: PropertyKey.subject) as! String,
                  timeLimit: aDecoder.decodeDouble(forKey: PropertyKey.timeLimit) )
        
        image = aDecoder.decodeObject(forKey: PropertyKey.image) as? UIImage
        created = aDecoder.decodeObject(forKey: PropertyKey.created) as? Date

    }
}
