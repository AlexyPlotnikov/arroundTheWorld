//
//  String + Extensions.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import Foundation
import UIKit

extension String{
       func widthOfString(usingFont font: UIFont) -> CGFloat {
           let fontAttributes = [NSAttributedString.Key.font: font]
           let size = self.size(withAttributes: fontAttributes)
           return size.width
       }

       func heightOfString(usingFont font: UIFont) -> CGFloat {
           let fontAttributes = [NSAttributedString.Key.font: font]
           let size = self.size(withAttributes: fontAttributes)
           return size.height
       }
}
