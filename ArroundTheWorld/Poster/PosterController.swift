//
//  PosterController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 23.10.2023.
//

import UIKit
import SDWebImage
import FlexiblePageControl


class PosterController: UIViewController, Storyboardable, ArticlesDetailNavigation {

    var viewModel:PosterViewModel!
    @IBOutlet weak var table: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        

        NotificationCenter.default.addObserver(self, selector: #selector(reloadArticles), name: Notification.Name("loadedALL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(reloadGeo), name: Notification.Name("reloadGeo"), object: nil)
        DispatchQueue.main.async{
            self.table.showSkeletonView()
        }
    }
    
    @objc func reloadArticles(){
        DispatchQueue.main.async{
            self.table.hideSkeletonView()
            self.table.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.table.frame.size.width, height: 120))
        }
    }
    
    @objc func reloadGeo(){
        DispatchQueue.main.async{
            self.table.reloadData()
        
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("setupScroll"), object: self.table)
    }
    
    func convertTimestampToDate(timestamp: Int) -> String {
        let date = Date(timeIntervalSince1970: TimeInterval(timestamp))
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateFormat = "dd MMMM yyyy"
        return dateFormatter.string(from: date)
    }
    
    

}

extension PosterController:UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row == 0){
            return 228
        }else if(indexPath.row == 1){
            return 236
        }else{
            return UITableView.automaticDimension
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 6
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "eventCell", for: indexPath) as! PostersCell
            cell.eventCollection.delegate = self
            cell.eventCollection.dataSource = self
            cell.eventCollection.tag = 0
            cell.eventCollection.reloadData()
            
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "placeCell", for: indexPath) as! PostersCell
            guard (ModelManager.shared.places.results?.count ?? 0) > 0 else {return cell}
            let places = ModelManager.shared.places.results?[0]
            
            cell.namePlaceLbl.text = places?.title.lowercased()
            cell.adressPlaceLbl.text = places?.adress
            cell.imageCollection.delegate = self
            cell.imageCollection.dataSource = self
            cell.imageCollection.reloadData()
            cell.imageCollection.tag = 1
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
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! PostersCell
            guard (ModelManager.shared.articles.results?.count ?? 0) > 0 else {return cell}
            let articles = ModelManager.shared.articles.results?[indexPath.row-2]
            
            cell.titleArticleLbl.text = (articles?.title ?? "-").lowercased()
            cell.dateArticleLbl.text = self.convertTimestampToDate(timestamp: articles?.publicationDate ?? 0)
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if(indexPath.row == 1){
            if(ModelManager.shared.places.results?.count ?? 0 > 0){
                self.viewModel.navigation.pushDetail(poster: ModelManager.shared.places.results![indexPath.row-1], type: .place)
            }
           
        }
        if(indexPath.row > 1){
            let navVC = DetailNavigationController.createMain(with: "detailNC")
            // navVC.navigationBar.topItem?.title = self.viewModel.articles.results![indexPath.row].title
            (navVC.viewControllers.first as! ArtcilesDetailController).title = ModelManager.shared.articles.results![indexPath.row-2].title
            (navVC.viewControllers.first as! ArtcilesDetailController).viewModel = ArticlesDetailViewModel(navigationController: self, articleID: ModelManager.shared.articles.results![indexPath.row].id!)
            self.viewModel.navigation.pushNavVC(NC: navVC)
        }
    }
}

extension PosterController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView.tag == 0){
            let newWidth = (collectionView.frame.size.width/2)-16
            return CGSize(width: newWidth, height: 226)
        }else{
            return CGSize(width: collectionView.frame.size.width, height: collectionView.frame.size.height)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView.tag == 0){
            return UIEdgeInsets(top: 0, left: 12, bottom: 100, right: 12)
        }else{
            return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView.tag == 0){
            return 8
        }else{
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView.tag == 0){
            return 8
        }else{
            return 0
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 0){
            guard (ModelManager.shared.events.results?.count ?? 0) > 0 else {return 2}
            return 2
        }else{
            guard (ModelManager.shared.places.results?[0].images.count ?? 0) > 0 else {return 0}
            return ModelManager.shared.places.results![0].images.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.tag == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "smallCell", for: indexPath) as! PosterEventCell
            guard (ModelManager.shared.events.results?.count ?? 0) > 0 else {return cell}
            let poster = ModelManager.shared.events.results?[indexPath.row]
            
//            cell.smallImage.sd_imageIndicator = SDWebImageActivityIndicator.grayLarge
            cell.smallImage.setTemplateWithSubviews(true, viewBackgroundColor: .white)
            cell.smallImage.sd_setImage(with: URL(string: poster?.images[0].image ?? ""),completed: {_,_,_,_ in
                cell.smallImage.setTemplateWithSubviews(false, animate: true)
            })
            cell.smallImage.layer.cornerRadius = 24
            cell.smallImage.layer.masksToBounds = true
            cell.smallTitle.text = (poster?.title ?? "Нет данных").lowercased()
            cell.smallTitle.adjustsFontSizeToFitWidth = true
            cell.smallTitle.minimumScaleFactor = 0.8
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageCollectionCell
            
            guard let image = ModelManager.shared.places.results?[0].images[indexPath.row] else { return cell }
            cell.imageView.sd_setImage(with: URL(string: image.image))
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(collectionView.tag == 0){
            if(ModelManager.shared.events.results?.count ?? 0 > 0){
                self.viewModel.navigation.pushDetail(poster: ModelManager.shared.events.results![indexPath.row], type: .poster)
            }
        }
    }
    
}
