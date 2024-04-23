//
//  EventsController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import UIKit
import SDWebImage

class EventsController: UIViewController, Storyboardable {

    var viewModel:EventViewModel!
    @IBOutlet weak var collcetionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        NotificationCenter.default.addObserver(self, selector: #selector(reloadPosters), name: Notification.Name("endLoadPosters"), object: nil)
        DispatchQueue.main.async{
            self.collcetionView.showSkeletonView()
        }
    }
   
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("setupScroll"), object: self.collcetionView)
    }
    
    @objc func reloadPosters(){
        DispatchQueue.main.async{
            self.collcetionView.hideSkeletonView()
            
        }
    }
   

}


extension EventsController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let newWidth = (collectionView.frame.size.width/2)-16
        return CGSize(width: newWidth, height: 226)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 100, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 8
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        guard (ModelManager.shared.events.results?.count ?? 0) > 0 else {return 6}
        return ModelManager.shared.events.results!.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCell", for: indexPath) as! EventCell
        
        guard (ModelManager.shared.events.results?.count ?? 0) > 0 else {return cell}
        let poster = ModelManager.shared.events.results?[indexPath.row]
        
//        cell.smallImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
        
        cell.smallImage.setTemplateWithSubviews(true, viewBackgroundColor: .white)
        cell.smallImage.sd_setImage(with: URL(string: poster?.images[0].image ?? ""),completed: {_,_,_,_ in
            cell.smallImage.setTemplateWithSubviews(false, animate: true)
        })
        cell.smallImage.layer.cornerRadius = 24
        cell.smallImage.layer.masksToBounds = true
        cell.smallTitle.text = (poster?.title ?? "Нет данных").lowercased()
      
//        cell.smallTitle.adjustsFontSizeToFitWidth = true
//        cell.smallTitle.minimumScaleFactor = 0.8
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let results = ModelManager.shared.events.results, !results.isEmpty else { return }
        if indexPath.row == results.count - 1 && (ModelManager.shared.events.count ?? 0 > results.count) {
            self.viewModel.currentPage += 1
            self.viewModel.reloadEvents()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        self.viewModel.navigation.pushDetail(poster: ModelManager.shared.events.results![indexPath.row], type: .poster)
    }
    
}
