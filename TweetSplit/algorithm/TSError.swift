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
    case textFormattingError

    public var localizedDescription: String{
        switch self {
        case .emptyTweet:
            return "Tweet should not be empty"
        case .tweetNotSplitable:
            return "Tweet cannot be split"
        case .textFormattingError:
            return "<e>Text formatting error</e>"
        }
    }
    
    public var styledDescription: String{
        switch self {
        case .emptyTweet:
            return "<e>Tweet should not be empty</e>"
        case .tweetNotSplitable:
            return "<e>Tweet cannot be split</e>"
        case .textFormattingError:
            return "<e>Text formatting error</e>"
        }
    }
}
