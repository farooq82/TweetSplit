//
//  ViewController.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 23/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let tweets = "Praesent commodo cursus magna, vel scelerisque nisl consectetur et. Nullam id dolor id nibh ultricies vehicula ut id elit. Maecenas faucibus mollis interdum. Donec ullamcorper nulla non metus auctor fringilla. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Sed posuere consectetur est at lobortis. Nullam id dolor id nibh ultricies vehicula ut id elit.".splitMessage2(limit: 50)
        
        for tweet in tweets{
            print("Tweet: \(tweet) - length: \(tweet.count)")
        }
    }
}

