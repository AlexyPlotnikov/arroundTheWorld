//
//  PopularCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 29.04.2024.
//

import UIKit

class PopularCell: UICollectionViewCell {
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var nameWayLbl: UILabel!
    @IBOutlet weak var cityImage: UIImageView!
    var tintView:UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
       
            if(tintView != nil){
                tintView.removeFromSuperview()
            }
            
            tintView = UIView()
            tintView.backgroundColor = UIColor.init(displayP3Red: 36/255, green: 36/255, blue: 36/255, alpha: 0.3)
            tintView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
        cityImage.addSubview(tintView)
    }
}
