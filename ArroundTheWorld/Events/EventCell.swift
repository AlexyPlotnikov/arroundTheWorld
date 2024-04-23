//
//  EventCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 04.02.2024.
//

import UIKit

class EventCell: UICollectionViewCell {

    @IBOutlet weak var smallImage: UIImageView!
    @IBOutlet weak var smallTitle: FadingLabel!
    @IBOutlet weak var smallDate: UILabel!
    
    
    func setGradient(){
        self.setNeedsLayout()
    }
}
