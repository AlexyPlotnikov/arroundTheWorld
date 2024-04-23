//
//  UICollectionView + Extensions.swift
//  ArroundTheWorld
//
//  Created by Алексей on 09.11.2023.
//

import UIKit
import UIView_Shimmer



extension UICollectionView{
    func showSkeletonView(){
        self.setTemplateWithSubviews(true, viewBackgroundColor: .white)
    }
    
    func hideSkeletonView(){
        self.reloadData()
        self.setTemplateWithSubviews(false, animate: true)
    }
}
