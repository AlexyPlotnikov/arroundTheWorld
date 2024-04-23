//
//  InvertedGradientLayer.swift
//  ArroundTheWorld
//
//  Created by Алексей on 05.01.2024.
//

import Foundation
import UIKit

class InvertedGradientLayer: CALayer {
    
    public var lineHeight: CGFloat = 0
    public var gradWidth: CGFloat = 0
    
    override func draw(in inContext: CGContext) {
        
        // fill all but the bottom "line height" with opaque color
        inContext.setFillColor(UIColor.gray.cgColor)
        var r = self.bounds
        r.size.height -= lineHeight
        inContext.fill(r)

        // can be any color, we're going from Opaque to Clear
        let colors = [UIColor.gray.cgColor, UIColor.gray.withAlphaComponent(0.0).cgColor]
        
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        
        let colorLocations: [CGFloat] = [0.0, 1.0]
        
        let gradient = CGGradient(colorsSpace: colorSpace, colors: colors as CFArray, locations: colorLocations)!
        
        // start the gradient "grad width" from right edge
        let startPoint = CGPoint(x: bounds.maxX - gradWidth, y: 0.5)
        // end the gradient at the right edge, but
        // probably want to leave the farthest-right 1 or 2 points
        //  completely transparent
        let endPoint = CGPoint(x: bounds.maxX - 2.0, y: 0.5)

        // gradient rect starts at the bottom of the opaque rect
        r.origin.y = r.size.height - 1
        // gradient rect height can extend below the bounds, becuase it will be clipped
        r.size.height = bounds.height
        inContext.addRect(r)
        inContext.clip()
        inContext.drawLinearGradient(gradient, start: startPoint, end: endPoint, options: .drawsBeforeStartLocation)

    }
    
}
