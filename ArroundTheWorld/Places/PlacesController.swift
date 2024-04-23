//
//  PlacesController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import UIKit
import SDWebImage
import FlexiblePageControl

class PlacesController: UIViewController, Storyboardable {

    var viewModel:PlacesViewModel!
    @IBOutlet weak var table: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self, selector: #selector(self.methodOfReceivedNotification(notification:)), name: Notification.Name("endLoad"), object: nil)
        DispatchQueue.main.async{
            self.table.showSkeletonView()
        }
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("setupScroll"), object: self.table)
    }
    
    @objc func methodOfReceivedNotification(notification: Notification) {
        DispatchQueue.main.async{
            self.table.hideSkeletonView()
            self.table.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.table.frame.size.width, height: 120))
        }
    }
   

}

extension PlacesController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 236
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (ModelManager.shared.places.results?.count ?? 0) > 0 else {return 6}
        return ModelManager.shared.places.results!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "placeCard", for: indexPath) as! PlaceCell
        guard (ModelManager.shared.places.results?.count ?? 0) > 0 else {return cell}
        let places = ModelManager.shared.places.results?[indexPath.row]
        
        cell.namePlaceLbl.text = places?.title.lowercased()
        cell.adressPlaceLbl.text = places?.adress
        cell.imageCollection.delegate = self
        cell.imageCollection.dataSource = self
        cell.imageCollection.reloadData()
        cell.imageCollection.tag = indexPath.row
        cell.pageControllerView.isHidden = (places?.images.count)! < 2
        cell.pageControllerView.numberOfPages = (places?.images.count)!
        let config = FlexiblePageControl.Config(
            displayCount: 5,
            dotSize: 5,
            dotSpace: 6,
            smallDotSizeRatio: 0.5,
            mediumDotSizeRatio: 0.7
        )
        cell.pageControllerView.pageIndicatorTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        cell.pageControllerView.currentPageIndicatorTintColor = UIColor.init(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

        cell.pageControllerView.setConfig(config)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let places = ModelManager.shared.places.results?[indexPath.row] else { return }
        self.viewModel.navigation.pushDetail(model: places, type: .place)
    }
    
    
}

extension PlacesController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard (ModelManager.shared.places.results?[collectionView.tag].images.count ?? 0) > 0 else {return 0}
        return ModelManager.shared.places.results![collectionView.tag].images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionCell
        
        guard let image = ModelManager.shared.places.results?[collectionView.tag].images[indexPath.row] else { return cell }
        cell.imageView.sd_setImage(with: URL(string: image.image))
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (ModelManager.shared.places.results![collectionView.tag].images.count > 0){
           
            if let cell = self.table.cellForRow(at: IndexPath(row: collectionView.tag, section: 0)) as? PlaceCell{
                cell.pageControllerView.setCurrentPage(at: indexPath.row, animated: true)
            }
            
        }
        
    }
    
}
