//
//  PosterEventCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 04.02.2024.
//

import UIKit

class PosterEventCell: UICollectionViewCell {
    
    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var smallTitle: FadingLabel!
  
    
    
    func setGradient(){
        self.setNeedsLayout()
    }
}
