//
//  PlaceCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.10.2023.
//

import UIKit
import FlexiblePageControl

class PlaceCell: UITableViewCell {

    @IBOutlet weak var namePlaceLbl: UILabel!
    @IBOutlet weak var adressPlaceLbl: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var pageControllerView: FlexiblePageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

}
