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
        if(totalLen <= limit){
            //Compact message length is within limit
            return [tokens.joined(separator: " ")]
        }

        //Initially estimate the number of parts possible from total string length
        
        let estimatedParts = totalLen/limit + (totalLen % limit > 0 ? 1 : 0);
        return try buildSubTweets(limit:limit, words: tokens, parts: estimatedParts)
    }
    
    /// Tokenize message into words while eliminating the whatspace characters.
    ///
    /// - Parameter limit: Tweet characters limit
    /// - Returns: Array of words, total length of compacted message including spaces
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
        
        for index in input.indices{
            
            if whiteSpaces.contains(input[index]){
                let wordLen = distance(index)
                if wordLen == 1 && !whiteSpaces.contains(input[wsIndex]){
                    let letters = input[ wsIndex ..< index]
                    wordsIndex.append(String(letters))
                    totalLen += wordLen + 1  //Extra 1 to accomodate for space
                    
                    wsIndex = index
                }else if wordLen > 1{
                    
                    if wsIndex != input.startIndex{
                        wsIndex = input.index(wsIndex, offsetBy: 1)
                    }
                    
                    //Word is not splittable
                    if wordLen > limit || (wordsIndex.count > 0 && wordLen >= limit){
                        throw TSError.tweetNotSplitable
                    }
                    
                    //Word found, store it
                    let letters = input[ wsIndex ..< index]
                    wordsIndex.append(String(letters))
                    totalLen += wordLen  //Extra 1 to accomodate for space
                    
                    wsIndex = index
                }else{
                    wsIndex = index
                }
            }
        }
        
        //Last word
        if wsIndex != input.endIndex{
            let wordLen = distance(input.endIndex)
            wsIndex = input.index(wsIndex, offsetBy: 1)
            
            if wordLen > limit || (wordsIndex.count > 0 && wordLen >= limit){
                throw TSError.tweetNotSplitable
            }
            
            let letters = input[ wsIndex ..< input.endIndex]
            
            if letters.count > 0{
                wordsIndex.append(String(letters))
                totalLen += wordLen
            }
        }
        
        return (wordsIndex, totalLen)
    }
    
    /// Recursive method to build subtweets from words array.
    /// Re-adjusts itself if number of built parts is greater that estimated parts
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
