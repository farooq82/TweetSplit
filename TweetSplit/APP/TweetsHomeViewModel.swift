//
//  TweetsHomeViewModel.swift
//  TweetSplit
//
//  Created by Farooq Zaman on 26/10/2018.
//  Copyright © 2018 TMS Sdn Bhd. All rights reserved.
//

import Foundation

import RxSwift
import RxCocoa
import Action


struct TweetsHomeViewModel{
    let sceneCoordinator: SceneCoordinatorType
    
    init(coordinator: SceneCoordinatorType) {
        self.sceneCoordinator = coordinator
    }        
}
