//
//  BannerCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 18.10.2023.
//

import UIKit

class BannerCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptLbl: UILabel!
    @IBOutlet weak var pageControll: UIPageControl!
    var tintView:UIView!
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        if(tintView != nil){
            tintView.removeFromSuperview()
        }
        tintView = UIView()
        tintView.backgroundColor = UIColor(white: 0, alpha: 0.3)
        tintView.frame = CGRect(x: 0, y: 0, width: self.frame.width, height: self.frame.height)

        imageView.addSubview(tintView)
    }
}
