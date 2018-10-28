//
//  TweetsHomeViewModel.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 26/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Action
import RealmSwift
import RxRealm


struct TweetsHomeViewModel{
    let sceneCoordinator: SceneCoordinatorType
    let tweetService: TweetServiceType
    let tweetMessage: BehaviorRelay<String?>
    
    init(coordinator: SceneCoordinatorType, tweetService:TweetServiceType) {
        self.sceneCoordinator = coordinator
        self.tweetService = tweetService
        tweetMessage = BehaviorRelay(value: "")
    }
    
    /// tweets changeset observer
    lazy var tweetsChangeSet: Observable<(AnyRealmCollection<Tweet>, RealmChangeset?)> = {this in
        return this.tweetService.tweetsChangeSet
    }(self)
    
    ///Post tweets
    lazy var actionPostTweets:Action<[String], Void> = {this in
        return Action{tweets in
            this.tweetService.postTweets(tweets)
            return .just(())
        }
    }(self)
}
