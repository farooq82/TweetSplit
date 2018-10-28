//
//  UITableView+additions.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 28/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import UIKit

extension UITableView{
    func adjustFooterViewHeightToFillTableView() {
        
        // Invoke from UITableViewController.viewDidLayoutSubviews()
        
        if let tableFooterView = self.tableFooterView {
            
            let minHeight = tableFooterView.systemLayoutSizeFitting(UIView.layoutFittingCompressedSize).height
            
            let currentFooterHeight = tableFooterView.frame.height
            
            let fitHeight = self.frame.height - self.adjustedContentInset.top - self.contentSize.height  + currentFooterHeight
            let nextHeight = (fitHeight > minHeight) ? fitHeight : minHeight
            
            if (round(nextHeight) != round(currentFooterHeight)) {
                var frame = tableFooterView.frame
                frame.size.height = nextHeight
                tableFooterView.frame = frame
                self.tableFooterView = tableFooterView
            }
        }
    }
}
