//
//  TweetSplit.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 23/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation

public let SPACE:Character = " "

extension String{
    
    /// Splits out of bound tweet into 1-n within bound tweets
    /// Adds part indicators i.e 1\2, 2\2
    ///
    /// - Parameters:
    ///   - limit: Tweet characters limit (aka bounds)
    /// - Returns: 1-n within bound tweets
    
    func splitMessage(limit:Int) throws -> [String]{
        guard self.count > 0 else {
            throw TSError.emptyTweet
        }
        
        guard self.count > limit else {
            return [self]
        }
        
        let charMessage = Array(self)
        var nearSpace = 0                   //Nearest Space to index
        var subTweetStart = 0               //Start of sub tweet
        let partLimit = limit - 3           //to reserve space for part indicator
        var subTweets = [String]()
        
        for index in 0 ..< charMessage.count{
            
            if index - subTweetStart > partLimit{
                if nearSpace <= subTweetStart{
                    throw TSError.tweetNotSplitable
                }
                
                let subTweet = charMessage[subTweetStart ... nearSpace - 1]
                subTweets.append(String(subTweet))
                
                subTweetStart = nearSpace + 1
            }
            
            if charMessage[index] == SPACE{
                nearSpace = index
                
                if(nearSpace == subTweetStart){
                    subTweetStart = nearSpace + 1;
                }
            }
        }
        
        let subTweet = charMessage[subTweetStart ... charMessage.count - 1]
        subTweets.append(String(subTweet))
        
        return subTweets
    }
    
}
