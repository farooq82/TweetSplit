//
//  TweetServiceType.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 28/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation
import RealmSwift
import RxSwift
import RxRealm


protocol TweetServiceType{
    
    /// Add subtweets to realm
    ///
    /// - Parameter subTweets: subtweets of a message. Date is used to sort these messages
    func postTweets(_ subTweets:[String])
    
    /// Tweets change set. Any time a tweet is added or removed from realm, observer will be notified
    var tweetsChangeSet: Observable<(AnyRealmCollection<Tweet>, RealmChangeset?)>   {get}
    
}
