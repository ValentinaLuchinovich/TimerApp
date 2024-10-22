//
//  UILabelExtension.swift
//  JustMobi_test
//
//  Created by Валентина Лучинович on 19.10.2024.
//

import UIKit

extension UILabel {
    func strokeText() -> NSAttributedString {
        let attributes = [
            NSAttributedString.Key.strokeColor: UIColor.black,
            NSAttributedString.Key.foregroundColor: UIColor.white,
            NSAttributedString.Key.strokeWidth: -3.0,
            NSAttributedString.Key.font: UIFont.systemFont(ofSize: 22.0, weight: .bold)
        ] as [NSAttributedString.Key : Any]
        
        let attributedText = NSAttributedString(string: self.text ?? "", attributes: attributes)
        return attributedText
    }
}
