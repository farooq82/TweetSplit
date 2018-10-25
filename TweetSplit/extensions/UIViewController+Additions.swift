//
//  UIViewController+Additions.swift
//  Unisel Helpdesk
//
//  Created by Farooq Zaman on 24/07/2018.
//  Copyright © 2018 Universiti Selangor (UNISEL). All rights reserved.
//

import UIKit

extension UIViewController{
    func addBlur(visualEffect:UIVisualEffect = UIBlurEffect(style: .extraLight)){
        self.view.backgroundColor = .clear
        self.navigationController?.view.backgroundColor = .clear
        let visuaEffectView = UIVisualEffectView(effect: visualEffect)
        visuaEffectView.frame = self.view.bounds
        visuaEffectView.autoresizingMask = UIView.AutoresizingMask.flexibleWidth.union(UIView.AutoresizingMask.flexibleHeight)
        visuaEffectView.translatesAutoresizingMaskIntoConstraints = true
        self.view.insertSubview(visuaEffectView, at: 0)
    }
}
