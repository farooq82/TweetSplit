//
//  TweetSplitTests.swift
//  TweetSplitTests
//
//  Created by Farooq Zaman on 23/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import XCTest
@testable import TweetSplit

class TweetSplitTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    //0 subtweets when empty string
    func testThatItsEmpty() {
        let message = ""
        
        XCTAssertThrowsError(try message.splitMessage(limit: 50), "Cannot split") { (error) in
            XCTAssertEqual(error as! TweetSplitError, TweetSplitError.emptyTweet)
        }
    }
    
    //1 subtweets when string length is less than upper bound
    func testThatItsLessThanUpperBound() {
        let message = "Mattis Parturient Risus Sollicitudin"
        
        XCTAssertNoThrow(try message.splitMessage(limit: 50))
        XCTAssertEqual(try message.splitMessage(limit: 50).count, 1)
    }
    
    func testThatItssMoreThanUpperBound() {
        let message = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        
        XCTAssertNoThrow(try message.splitMessage(limit: 50))
        XCTAssertEqual(try message.splitMessage(limit: 50).count, 2)
    }
    
    func testThatItsMultipleTweets() {
        let message = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed posuere consectetur est at lobortis. Nullam id dolor id nibh ultricies vehicula ut id elit."
        
        XCTAssertNoThrow(try message.splitMessage(limit: 50))
        XCTAssertGreaterThan(try message.splitMessage(limit: 50).count, 2)
    }
    
    func testThatItssNotSpiltableStart() {
        let message = "Ican'tbelieveTweeternowsupportschunkingmymessages,soIdon'thavetodoitmyself."
        
        XCTAssertThrowsError(try message.splitMessage(limit: 50), "Cannot split") { (error) in
            XCTAssertEqual(error as! TweetSplitError, TweetSplitError.tweetNotSplitable)
        }
    }
    
    func testThatItsNotSplitableMiddle() {
        let message = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nullanonmetusauctorfringilla.Cumsociisnatoquepenatibusetmagnisdisparturientmontes,nasceturridiculusmus. Sed posuere consectetur est at lobortis. Nullam id dolor id nibh ultricies vehicula ut id elit."
        
        XCTAssertThrowsError(try message.splitMessage(limit: 50), "Cannot split") { (error) in
            XCTAssertEqual(error as! TweetSplitError, TweetSplitError.tweetNotSplitable)
        }
    }
    
    func testThatItsNotSplitableEnd() {
        let message = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis disparturientmontes,nasceturridiculusmus.Sedposuereconsecteturestatlobortis.Nullamiddoloridnibhultriciesvehiculautidelit."
        
        XCTAssertThrowsError(try message.splitMessage(limit: 50), "Cannot split") { (error) in
            XCTAssertEqual(error as! TweetSplitError, TweetSplitError.tweetNotSplitable)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
