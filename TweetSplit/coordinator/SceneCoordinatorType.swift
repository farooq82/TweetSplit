//
//  SceneCoordinatorType.swift
//  C2H
//
//  Created by Farooq Zaman on 22/03/2018.
//  Copyright © 2018 TMS Software Sdn Bhd. All rights reserved.
//

import UIKit
import RxSwift

protocol SceneCoordinatorType{
    init(window: UIWindow)
    
    @discardableResult
    func transition(to scene: Scene, type: SceneTransitionType) -> Observable<Void>
    
    @discardableResult
    func pop(animated:Bool) -> Observable<Void>
    
    var currentViewController:UIViewController {get}
}

extension SceneCoordinatorType{
    @discardableResult
    func pop() -> Observable<Void>{
        return pop(animated: true)
    }
}

