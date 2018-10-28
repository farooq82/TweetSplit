//
//  TweetTextView.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 27/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import UIKit

class TweetTextView:UITextView{
    var width:CGFloat = 200.0           //Initial width
    
    override var intrinsicContentSize : CGSize {
        let textHeight = self.sizeThatFits(CGSize(width: self.frame.size.width, height: CGFloat.greatestFiniteMagnitude)).height
        return CGSize(width: width, height: max(40, min(textHeight, 120)))
    }
}
