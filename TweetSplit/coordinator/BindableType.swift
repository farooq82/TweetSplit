//
//  BindableType.swift
//  C2H
//
//  Created by Farooq Zaman on 22/03/2018.
//  Copyright © 2018 TMS Software Sdn Bhd. All rights reserved.
//

import Foundation
import RxSwift

protocol BindableType {
    associatedtype ViewModelType
    
    var viewModel: ViewModelType! {get set}
    
    func bindViewModel()
}

extension BindableType where Self: UIViewController{
    mutating func bindViewModel(to model: Self.ViewModelType) {
        viewModel = model
        loadViewIfNeeded()
        bindViewModel()
    }
}

