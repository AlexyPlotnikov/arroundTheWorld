//
//  RecomendedTicketCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 23.04.2024.
//

import UIKit

class RecomendedTicketCell: UICollectionViewCell {
    
    @IBOutlet weak var imageRecomend: UIImageView!
    @IBOutlet weak var titleRecomend: UILabel!
    @IBOutlet weak var subtitleRecomend: UILabel!
    var tintView:UIView!
    
    @IBOutlet weak var priceLbl: UILabel!
    @IBOutlet weak var discontLbl: UILabel!
 
    @IBOutlet weak var timeIntervalTo: UILabel!
    @IBOutlet weak var timeTo: UILabel!
    @IBOutlet weak var returnTransferTo: UILabel!
    
    @IBOutlet weak var timeIntervalBack: UILabel!
    @IBOutlet weak var timeBack: UILabel!
    @IBOutlet weak var returnTransferBack: UILabel!
    
    @IBOutlet weak var airlineImage: UIImageView!
    
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(self.reuseIdentifier == "cell"){
            if(tintView != nil){
                tintView.removeFromSuperview()
            }
            
            imageRecomend.layer.cornerRadius = 16
            imageRecomend.layer.masksToBounds = true
            tintView = UIView()
            tintView.backgroundColor = UIColor(white: 0, alpha: 0.3)
            tintView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)
            
            imageRecomend.addSubview(tintView)
        }else{
            self.contentView.layer.cornerRadius = 16
            self.contentView.layer.masksToBounds = true
        }
    }
}
