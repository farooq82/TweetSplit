//
//  TextStyles.swift
//  C2H
//
//  Created by Farooq Zaman on 25/05/2018.
//  Copyright © 2018 TMS Software Sdn Bhd. All rights reserved.
//

import Foundation
import BonMot

class TextUtils{
    static let shared = TextUtils()
    
    var tweetStatusStyle: StringStyle{
        let required = StringStyle(.color(.red))
        return StringStyle(
            .font(UIFont.pt11SuperSmallLight),
            .color(.battleshipGrey),
            .xmlRules([
                .style("e", required)
                ])
        )
    }
    
    func registerTextStyles(){
        let required = StringStyle(.color(.red))
        let style = StringStyle(
            .font(UIFont.pt11SuperSmallLight),
            .color(.battleshipGrey),
            .xmlRules([
                .style("r", required)
                ])
        )
        NamedStyles.shared.registerStyle(forName: "Required-Label", style: style)
    }
}
