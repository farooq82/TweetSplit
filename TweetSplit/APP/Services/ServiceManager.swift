//
//  ServiceManager.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 28/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation
import Realm
import RealmSwift

open class ServiceManager{
    static let shared = ServiceManager()
    
    public let realm = try! Realm(configuration: Realm.Configuration(deleteRealmIfMigrationNeeded: true))
}


