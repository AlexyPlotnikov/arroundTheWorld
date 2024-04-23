//
//  FadingLabel.swift
//  TestApp
//
//  Created by Shawn Frank on 21/01/2022.
//

import UIKit

class FadingLabel: UILabel
{
    
    let ivgLayer = InvertedGradientLayer()
        override func layoutSubviews() {
            super.layoutSubviews()
            guard let f = self.font, let t = self.text else { return }
            // we only want to fade-out the last line if
            //  it would be clipped
            let constraintRect = CGSize(width: bounds.width, height: .greatestFiniteMagnitude)
            let boundingBox = t.boundingRect(with: constraintRect, options: .usesLineFragmentOrigin, attributes: [NSAttributedString.Key.font : f], context: nil)
            if boundingBox.height <= bounds.height {
                layer.mask = nil
                return
            }
            layer.mask = ivgLayer
            lineBreakMode = .byClipping
            ivgLayer.lineHeight = f.lineHeight
            ivgLayer.gradWidth = 60.0
            ivgLayer.frame = bounds
            ivgLayer.setNeedsDisplay()
        }
}
