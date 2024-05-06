//
//  MainTicketCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 23.04.2024.
//

import UIKit
import MarqueeLabel

class MainTicketCell: UITableViewCell {

    @IBOutlet weak var popularCollection: UICollectionView!
    @IBOutlet weak var collectionTickets: UICollectionView!
    
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var scrollingLabel: MarqueeLabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
        if(self.backView != nil){
            self.backView.addGradientBackground(firstColor: UIColor.init(displayP3Red: 253/255, green: 110/255, blue: 106/255, alpha: 0.16), secondColor: UIColor.init(displayP3Red: 255/255, green: 198/255, blue: 0/255, alpha: 0.16))
        }
    }

   
}

extension UIView{
    func addGradientBackground(firstColor: UIColor, secondColor: UIColor){
        clipsToBounds = true
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [firstColor.cgColor, secondColor.cgColor]
        gradientLayer.frame = self.bounds
        gradientLayer.startPoint = CGPoint(x: 0, y: 0)
        gradientLayer.endPoint = CGPoint(x: 1, y: 1)
        print(gradientLayer.frame)
        self.layer.insertSublayer(gradientLayer, at: 0)
    }
}
