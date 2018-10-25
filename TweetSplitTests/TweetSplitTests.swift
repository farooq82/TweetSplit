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
    let limit = 50
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        super.setUp()
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    //0 subtweets when empty string
    func testThatItsEmpty() {
        let message = ""
        
        XCTAssertEqual(try message.splitMessage(limit: limit).count, 0)
    }
    
    //1 subtweets when string length is less than upper bound
    func testThatItsLessThanUpperBound() {
        let message = "Mattis Parturient Risus Sollicitudin"
        let output = ["Mattis Parturient Risus Sollicitudin"]
        
        XCTAssertEqual(try message.splitMessage(limit: limit), output)
    }
    
    func testThatItsMoreThanUpperBound() {
        let message = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                      "2/2 my messages, so I don't have to do it myself."]
        do{
            let output  = try message.splitMessage(limit: limit)
            XCTAssertEqual(output, expected)
        }catch let error{
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable )
        }
    }
    
    func testThatItContainsDoubleSpaces() {
        let message = "I  can't  believe  Tweeter  now  supports  chunking  my  messages,  so  I  don't  have  to  do  it  myself."
        let expected = ["1/2 I can't believe Tweeter now supports chunking",
                        "2/2 my messages, so I don't have to do it myself."]
        do{
            let output  = try message.splitMessage(limit: limit)
            XCTAssertEqual(output, expected)
        }catch let error{
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable )
        }
    }
    
    func testThatItsNineTweets() {
        let message = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed posuere consectetur est at lobortis. Nullam id dolor id nibh ultricies vehicula ut id elit."
        
        let expected = ["1/9 Praesent commodo cursus magna, vel scelerisque",
                        "2/9 nisl consectetur et. Nullam id dolor id nibh",
                        "3/9 ultricies vehicula ut id elit. Maecenas",
                        "4/9 faucibus mollis interdum. Donec ullamcorper",
                        "5/9 nulla non metus auctor fringilla. Cum sociis",
                        "6/9 natoque penatibus et magnis dis parturient",
                        "7/9 montes, nascetur ridiculus mus. Sed posuere",
                        "8/9 consectetur est at lobortis. Nullam id dolor",
                        "9/9 id nibh ultricies vehicula ut id elit."]
        
        do{
            let output  = try message.splitMessage(limit: limit)
            XCTAssertEqual(output, expected)
        }catch let error{
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable )
        }
    }
    
    func testThatItsMoreThanNineTweets() {
        let message = "Donec ullamcorper nulla non metus auctor fringilla. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Curabitur blandit tempus porttitor. Maecenas sed diam eget risus varius blandit sit amet non magna. Aenean lacinia bibendum nulla sed consectetur. Nullam id dolor id nibh ultricies vehicula ut id elit. Cras justo odio, dapibus ac facilisis in, egestas eget quam. Maecenas sed diam eget risus varius blandit sit amet non magna. Maecenas sed diam eget risus varius blandit sit amet non magna. Vivamus sagittis lacus vel augue laoreet rutrum faucibus dolor auctor. Sed posuere consectetur est at lobortis. Donec ullamcorper nulla non metus auctor fringilla. Duis mollis, est non commodo luctus, nisi erat porttitor ligula, eget lacinia odio sem nec elit."
        
        let expected = ["1/19 Donec ullamcorper nulla non metus auctor",
                        "2/19 fringilla. Lorem ipsum dolor sit amet,",
                        "3/19 consectetur adipiscing elit. Curabitur",
                        "4/19 blandit tempus porttitor. Maecenas sed diam",
                        "5/19 eget risus varius blandit sit amet non magna.",
                        "6/19 Aenean lacinia bibendum nulla sed",
                        "7/19 consectetur. Nullam id dolor id nibh",
                        "8/19 ultricies vehicula ut id elit. Cras justo",
                        "9/19 odio, dapibus ac facilisis in, egestas eget",
                        "10/19 quam. Maecenas sed diam eget risus varius",
                        "11/19 blandit sit amet non magna. Maecenas sed",
                        "12/19 diam eget risus varius blandit sit amet non",
                        "13/19 magna. Vivamus sagittis lacus vel augue",
                        "14/19 laoreet rutrum faucibus dolor auctor. Sed",
                        "15/19 posuere consectetur est at lobortis. Donec",
                        "16/19 ullamcorper nulla non metus auctor",
                        "17/19 fringilla. Duis mollis, est non commodo",
                        "18/19 luctus, nisi erat porttitor ligula, eget",
                        "19/19 lacinia odio sem nec elit."]
        do{
            let output  = try message.splitMessage(limit: limit)
            XCTAssertEqual(output, expected)
        }catch let error{
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable )
        }
    }
    
    func testThatItssNotSpiltableAtStart() {
        let message = "Ican'tbelieveTweeternowsupportschunkingmymessages,soIdon'thavetodoitmyself."
        
        XCTAssertThrowsError(try message.splitMessage(limit: limit), "Cannot split") { (error) in
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable)
        }
    }
    
    func testThatItsNotSplitableInMiddle() {
        let message = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nullanonmetusauctorfringilla.Cumsociisnatoquepenatibusetmagnisdisparturientmontes,nasceturridiculusmus. Sed posuere consectetur est at lobortis. Nullam id dolor id nibh ultricies vehicula ut id elit."
        
        XCTAssertThrowsError(try message.splitMessage(limit: limit), "Cannot split") { (error) in
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable)
        }
    }
    
    func testThatItsNotSplitableAtEnd() {
        let message = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis disparturientmontes,nasceturridiculusmus.Sedposuereconsecteturestatlobortis.Nullamiddoloridnibhultriciesvehiculautidelit."
        
        XCTAssertThrowsError(try message.splitMessage(limit: limit), "Cannot split") { (error) in
            XCTAssertEqual(error as! TSError, TSError.tweetNotSplitable)
        }
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }

}
