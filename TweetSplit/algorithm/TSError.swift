//
//  TweetSplitError.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 24/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation

public enum TSError: LocalizedError{
    case emptyTweet
    case tweetNotSplitable
    
    public var errorDescription: String?{
        switch self {
        case .emptyTweet:
            return "Tweet should not be empty"
        case .tweetNotSplitable:
            return "Tweet cannot be split"
        }
    }
}
