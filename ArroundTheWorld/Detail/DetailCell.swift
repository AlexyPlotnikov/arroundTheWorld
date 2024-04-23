//
//  DetailCell.swift
//  ArroundTheWorld
//
//  Created by Алексей on 17.12.2023.
//

import UIKit
import MapKit
import FlexiblePageControl

class DetailCell: UITableViewCell {
    @IBOutlet weak var imageCollection: UICollectionView!
    @IBOutlet weak var tagsCollection: UICollectionView!
    
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var adressLbl: UILabel!
    
    @IBOutlet weak var genreLbl: UILabel!
    @IBOutlet weak var ageLbl: UILabel!
    @IBOutlet weak var durationLbl: UILabel!
    
    @IBOutlet weak var descriptionLbl: UILabel!
    
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var paginatorImage: FlexiblePageControl!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

   

}
