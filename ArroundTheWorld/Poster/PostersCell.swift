//
//  PostersCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 25.10.2023.
//

import UIKit
import FlexiblePageControl

class PostersCell: UITableViewCell {
    
    @IBOutlet weak var eventCollection: UICollectionView!
    
    @IBOutlet weak var namePlaceLbl: UILabel!
    @IBOutlet weak var adressPlaceLbl: UILabel!
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var pageControllerView: FlexiblePageControl!
    
    @IBOutlet weak var titleArticleLbl: UILabel!
    @IBOutlet weak var dateArticleLbl: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
}
