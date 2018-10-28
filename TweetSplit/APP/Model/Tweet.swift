//
//  Tweet.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 28/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

class Tweet:Object{
    
    @objc dynamic var id:String?
    @objc dynamic var message:String?
    @objc dynamic var datePosted:Date?
    
    override class func primaryKey() -> String? {
        return "id"
    }
    
    required init() {
        super.init()
    }
    
    init(message:String, datePosted:Date) {
        super.init()
        
        id = UUID().uuidString
        self.message = message
        self.datePosted = datePosted
    }
    
    required init(realm: RLMRealm, schema: RLMObjectSchema) {
        super.init(realm: realm, schema: schema)
    }
    
    required init(value: Any, schema: RLMSchema) {
        super.init(value: value, schema: schema)
    }
}

//MARK:- Utility methods
extension Tweet{
    var time:String?{
        get{
            guard let timestamp = datePosted else{return "n/a"}
            
            let formatter = DateFormatter()
            
            if timestamp.isToday() == true{
                formatter.dateFormat = "hh:mm a"
                return formatter.string(from: timestamp)
            }else if timestamp.isYesterday() == true{
                return "Yesterday"
            }else{
                formatter.dateFormat = "MMM dd, yyyy hh:mm a"
                return formatter.string(from: timestamp)
            }
        }
    }
}
