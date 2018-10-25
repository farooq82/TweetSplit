//
//  UIView+animation.swift
//  Pods
//
//  Created by Farooq Zaman on 05/05/2017.
//
//

import Foundation
import UIKit

extension UIView{
    public func shake(count : Float? = nil,for duration : TimeInterval? = nil,withTranslation translation : Float? = nil) {
        let animation : CABasicAnimation = CABasicAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        
        animation.repeatCount = count ?? 2
        animation.duration = (duration ?? 0.5)/TimeInterval(animation.repeatCount)
        animation.autoreverses = true
        animation.byValue = translation ?? -5
        layer.add(animation, forKey: "shake")
    }
    
    public func roundCorners(_ corners:UIRectCorner, radius: CGFloat) {
        let path = UIBezierPath(roundedRect: self.bounds, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        let mask = CAShapeLayer()
        mask.path = path.cgPath
        self.layer.mask = mask
    }
    
    public func addDropShadow(shadowOffset:CGSize = CGSize(width: 0, height: 0), opacity:Float = 0.3, radius:CGFloat = 1.5){
        self.layer.masksToBounds = false;
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowOffset = shadowOffset
        self.layer.shadowOpacity = opacity;
        self.layer.shadowRadius = radius;
    }
}
