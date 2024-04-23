//
//  TagsCell.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 04.04.2024.
//

import UIKit

class TagsCell: UICollectionViewCell {
    
    @IBOutlet weak var title: UILabel!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(self.title.layer.cornerRadius != 9){
            self.title.backgroundColor = UIColor.init(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)
            self.title.textColor = UIColor.init(displayP3Red: 132/255, green: 132/255, blue: 132/255, alpha: 1)
            self.title.layer.cornerRadius = self.frame.height/2
            self.title.layer.masksToBounds = true
        }
    }
}
