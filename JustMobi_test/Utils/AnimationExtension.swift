//
//  AnimationExtension.swift
//  JustMobi_test
//
//  Created by Валентина Лучинович on 23.10.2024.
//

import UIKit

class Animations {
    static func shake(on onView: UIView) {
        let animation = CABasicAnimation(keyPath: "position")
        animation.duration = 0.13
        animation.repeatCount = 4
        animation.autoreverses = true
        animation.fromValue = NSValue(cgPoint: CGPoint(x: onView.center.x - 7, y: onView.center.y))
        animation.toValue = NSValue(cgPoint: CGPoint(x: onView.center.x + 7, y: onView.center.y))
        onView.layer.add(animation, forKey: "position")
    }
}
