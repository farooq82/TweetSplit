//
//  TweetSplit.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 23/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation


extension String{
    
    /// Token based implementation
    /// Data structure: Dictionary with words and their length count
    ///
    ///
    /// - Parameter limit: Tweet characters limit (aka bounds)
    /// - Returns: 1-n within bound tweets
    /// - Throws: TSError.tweetNotSplitable if a single words length is greater than limit
    
    func splitMessage(limit:Int) throws -> [String]{
        
        //String is empty
        guard self.count > 0 else {
            return []
        }
        
        let (tokens, totalLen) = try tokenize(limit: limit)
        if totalLen == 0{
            //message is all spaces
            return []
        }else if(totalLen <= limit){
            //Compact message length is within limit
            return [tokens.joined(separator: " ")]
        }

        //Initial estimates of parts message will be divided into
        let estimatedParts = totalLen/limit + (totalLen % limit > 0 ? 1 : 0);
        return try buildSubTweets(limit:limit, words: tokens, parts: estimatedParts)
    }
    
    
    
    /// Tokenize message into words while eliminating whatspace characters.
    ///
    /// - Parameter limit: Tweet characters limit
    /// - Returns: Array of words. Total length of compact message including spaces (helps in part estimatation)
    /// - Throws: TSError.tweetNotSplitable if a single words length is greater than limit
    
    private func tokenize(limit: Int) throws -> ([String], Int){
        var wordsIndex:[String] = []
        var totalLen = 0;   //Compact message total length
        
        let input = self.unicodeScalars
        var wsIndex = input.startIndex  //Word start index
        let whiteSpaces = CharacterSet.whitespacesAndNewlines
        
        func distance(_ weIndex: String.UnicodeScalarView.Index) -> Int{
            return input.distance(from: wsIndex, to: weIndex)
        }
        
        func extractWord(_ index: String.UnicodeScalarView.Index, wordLen:Int) throws {
            
            //Do not ignore first letter of first word
            if wsIndex != input.startIndex{
                wsIndex = input.index(wsIndex, offsetBy: 1)
            }
            
            //Word is not splitable
            if wordLen > limit || (wordsIndex.count > 0 && wordLen >= limit){
                throw TSError.tweetNotSplitable
            }

            //Make word
            let letters = input[ wsIndex ..< index]
            
            if letters.count > 0{
                wordsIndex.append(String(letters))
                totalLen += wordLen                 //word len + 1 (for space)
            }
        }
        
        for index in input.indices{
            
            if whiteSpaces.contains(input[index]){
                let wordLen = distance(index)
                
                if wordLen == 1 && !whiteSpaces.contains(input[wsIndex]){
                    //Single letter word i.e "I"
                    let letters = input[ wsIndex ..< index]
                    wordsIndex.append(String(letters))
                    totalLen += wordLen + 1  //Extra 1 to accomodate for space
                    
                    wsIndex = index
                }else if wordLen > 1{
                    //Multi letters word
                    try extractWord(index, wordLen: wordLen)
                    wsIndex = index
                }else{
                    //ignore white space
                    wsIndex = index
                }
            }
        }
        
        //Last word
        let wordLen = distance(input.endIndex);
        if wordLen > 1 || !whiteSpaces.contains(input[wsIndex]) {
            try extractWord(input.endIndex, wordLen: wordLen)
        }
        
        return (wordsIndex, totalLen)
    }
    
    
    
    
    /// Recursive method to build subtweets from words array.
    /// Re-adjusts itself if number of built parts is greater that estimated parts
    /// Maximum recusions - 1
    ///
    /// - Parameters:
    ///   - limit: Limit of a subtweet
    ///   - words: words dictionary
    ///   - parts: estimated parts
    /// - Returns: List of subtweets with part number prefixed
    /// - Throws: TSError.tweetNotSplitable if a single words length is greater than limit
    
    private func buildSubTweets(limit:Int, words: [String], parts: Int) throws -> [String]{
        var subTweets:[String] = []
        var part = 1;
        var strPart = "\(part)/\(parts)"
        var subTweet = strPart
        
        for word in words{
            
            if (strPart.count + word.count + 1) > limit{
                throw TSError.tweetNotSplitable
            }
            
            if (subTweet.count + word.count + 1) > limit{
                subTweets.append(subTweet)
                part += 1
                strPart = "\(part)/\(parts)"
                subTweet = strPart
            }
            
            subTweet += " " + word
        }
        subTweets.append(subTweet)

        if(subTweets.count > parts){
            return try buildSubTweets(limit: limit, words: words, parts: subTweets.count)
        }
        
        return subTweets
    }
}
