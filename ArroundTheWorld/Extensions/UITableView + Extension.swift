//
//  UITableView + Extension.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.12.2023.
//

import UIKit
import UIView_Shimmer

extension UILabel: ShimmeringViewProtocol { }
extension UIImageView: ShimmeringViewProtocol { }

extension UITableView{
    func showSkeletonView(){
        self.setTemplateWithSubviews(true, viewBackgroundColor: .white)
    }
    
    func hideSkeletonView(){
        self.reloadData()
        self.setTemplateWithSubviews(false, animate: true)
    }
}


