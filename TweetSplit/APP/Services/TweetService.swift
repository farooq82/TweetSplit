//
//  TweetService.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 28/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation
import Realm
import RealmSwift
import RxRealm
import RxSwift

struct TweetService:TweetServiceType{
    let disposeBag = DisposeBag()
    
    /// Tweets change set. Any time a tweet is added or removed from realm, observer will be notified
    
    var tweetsChangeSet: Observable<(AnyRealmCollection<Tweet>, RealmChangeset?)>{
        let tweets = ServiceManager.shared.realm.objects(Tweet.self)
            .sorted(byKeyPath: "datePosted", ascending: false)
        
        return Observable.changeset(from: tweets)
    }
    
    
    /// Add subtweets to realm
    ///
    /// - Parameter subTweets: subtweets of a message. Date is used to sort these messages
    
    func postTweets(_ subTweets:[String]){
        Observable.from(subTweets)
            .map{Tweet(message:$0, datePosted:Date())}
            .subscribe(ServiceManager.shared.realm.rx.add())
            .disposed(by:disposeBag)
    }
    
}
