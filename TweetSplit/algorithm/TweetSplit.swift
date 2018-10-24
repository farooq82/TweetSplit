//
//  TweetSplit.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 23/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation

public let SPACE:Character = " "

struct Word {
    let string:String
    let count:Int
}

extension String{
    
    /// Splits out of bound tweet into 1-n within bound tweets
    /// Adds part indicators i.e 1\2, 2\2
    /// Wrong approach for following reasons
    /// 1. This approach is fast but it cannot handle extraneous white spaces at the end or start of a subtweet
    /// 2. It is also assumming there will be maximum 9 subtweets, more tweets will have 5 charatcer part indicator
    /// 3. Cannot eliminate multiple space characters between words
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
    
    
    /// Token based implementation
    /// Data structure: Dictionary with words and their length count
    ///
    ///
    /// - Parameter limit: Tweet characters limit (aka bounds)
    /// - Returns: 1-n within bound tweets
    
    
    func splitMessage2(limit:Int) -> [String]{
        
       
        //String is empty
        guard self.count > 0 else {
            return []
        }
        
        let (tokens, totalLen) = tokenize()
        if(totalLen <= limit){
            return [tokens.map{$0.string}.joined(separator: " ")]
        }
        
        //Initially we assume there will be less than 10 sub tweets, we will re-adjust if that's not the case
        let newLimit = limit - 4
        let estimatedParts = totalLen/newLimit + (totalLen % newLimit > 0 ? 1 : 0);
        return buildSubTweets(limit:newLimit, words: tokens, parts: estimatedParts)
    }
    
    
    func tokenize() -> ([Word], Int){
        var wordsIndex:[Word] = []
        var totalLen = 0;               //Compact message total length
        
        let input = self.unicodeScalars
        var wsIndex = input.startIndex                              //Word start index
        var weIndex = input.startIndex                              //Word end index
        let whiteSpaces = CharacterSet.whitespacesAndNewlines
                
        func distance() -> Int{
            return input.distance(from: wsIndex, to: weIndex)
        }
        
        for index in input.indices{
            
            if whiteSpaces.contains(input[index]){
                let wordLen = distance()
                if wordLen > 0{
                    //Word found, store it
                    let letters = input[ wsIndex ... weIndex]
                    wordsIndex.append(Word(string: String(letters), count: wordLen + 1))        //+1 to accomodate for space
                    wsIndex = input.index(after: index)
                    weIndex = wsIndex
                    
                    totalLen += wordLen + 2  //Extra 1 to accomodate for space
                }else{
                    //empty space, keep going
                    wsIndex = index
                    weIndex = index
                }
            }else{
                //traversing on word
                weIndex = index;
            }
        }
        
        //Last word
        if wsIndex != weIndex{
            let letters = input[ wsIndex ... weIndex]
            let wordLen = distance() + 1
            wordsIndex.append(Word(string: String(letters), count: wordLen))
            totalLen += wordLen + 1
        }
        
        return (wordsIndex, totalLen)
    }
    
    func buildSubTweets(limit:Int, words: [Word], parts: Int) -> [String]{
        var subTweets:[String] = []
        var part = 1;
        var subTweet = "\(part)/\(parts)"
        
        for word in words{
            if (subTweet.count + word.string.count) > limit{
                subTweets.append(subTweet)
                part += 1
                subTweet = "\(part)/\(parts)"
            }
            
            subTweet += " " + word.string
        }
        
        subTweets.append(subTweet)
        return subTweets
    }
    
}
