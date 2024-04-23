//
//  SegmentControllCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import UIKit

class SegmentControllCell: UICollectionViewCell {
    
    @IBOutlet weak var titleLbl: UILabel!
    
    
    
    func setState(isSelected:Bool){
        self.titleLbl.textColor = isSelected ? .blackTitle():.grayTitles()
    }
}
