//
//  DetailController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 16.12.2023.
//

import UIKit
import SDWebImage
import SPIndicator
import MapKit
import SafariServices
import FlexiblePageControl
import ImageViewer_swift


class DetailController: UIViewController, Storyboardable, UIGestureRecognizerDelegate, SFSafariViewControllerDelegate {

    
    @IBOutlet weak var table: UITableView!
    var viewModel:DetailViewModel!
    @IBOutlet weak var moreBtn: UIButton!
    @IBOutlet weak var shareBtn: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.interactivePopGestureRecognizer?.delegate = self
        self.navigationController?.interactivePopGestureRecognizer?.isEnabled = true
        table.contentInsetAdjustmentBehavior = .never
        table.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: 80, right: 0)
        
        moreBtn.layer.cornerRadius = 12
        moreBtn.layer.masksToBounds = true
        moreBtn.isHidden = self.viewModel.site == ""
        shareBtn.isHidden = self.viewModel.site == ""
    }
    
    @IBAction func back(_ sender: Any) {
        self.viewModel.navigation.back()
    }
    
    @IBAction func share(_ sender: Any) {
        let someText:String = self.viewModel.titleText
        let objectsToShare:URL = URL(string: self.viewModel.site)!
            let sharedObjects:[AnyObject] = [objectsToShare as AnyObject,someText as AnyObject]
            let activityViewController = UIActivityViewController(activityItems : sharedObjects, applicationActivities: nil)
            activityViewController.popoverPresentationController?.sourceView = self.view

            activityViewController.excludedActivityTypes = [ .airDrop, .mail]

            self.present(activityViewController, animated: true, completion: nil)
    }
    
    
    @IBAction func showMore(_ sender: Any) {
       
        if let url = URL(string: self.viewModel.site) {
            let safariViewController = SFSafariViewController(url: url)
            safariViewController.delegate = self
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    
    @objc func handleLongPress(_ gesture: UILongPressGestureRecognizer) {
            if gesture.state == .began, let label = gesture.view as? UILabel {
                if let text = label.text {
                    UIPasteboard.general.string = text
                    let indicatorView = SPIndicatorView(title: "Текст скопирован", preset: .done)
                    indicatorView.present(duration: 2)
                    print("Текст \(label.tag) скопирован: \(text)")
                }
            }
        }
    
    
    func strippingStr(text:String) -> String{
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailBy otherGestureRecognizer: UIGestureRecognizer) -> Bool {
           return true
       }
    
    func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
           controller.dismiss(animated: true, completion: nil)
       }
}

extension DetailController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.coords != nil ? 5:4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row == 0){
            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DetailCell
            cell.imageCollection.reloadData()
            cell.imageCollection.tag = 0
            
            cell.paginatorImage.numberOfPages = self.viewModel.images.count
            let config = FlexiblePageControl.Config(
                displayCount: 3,
                dotSize: 5,
                dotSpace: 6,
                smallDotSizeRatio: 0.5,
                mediumDotSizeRatio: 0.7
            )
            cell.paginatorImage.pageIndicatorTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
            cell.paginatorImage.currentPageIndicatorTintColor = UIColor.init(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

            cell.paginatorImage.setConfig(config)
            
            return cell
        }else if(indexPath.row == 1){
            let cell = tableView.dequeueReusableCell(withIdentifier: "titleCell", for: indexPath) as! DetailCell
           
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            let longPressGesture1 = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            
            cell.titleLbl.text = self.viewModel.titleText
            cell.adressLbl.text = self.viewModel.adress
            
            cell.adressLbl.addGestureRecognizer(longPressGesture)
            cell.titleLbl.addGestureRecognizer(longPressGesture1)

            return cell
        }else if(indexPath.row == 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "descriptionCell", for: indexPath) as! DetailCell
            let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPress(_:)))
            
            cell.descriptionLbl.addGestureRecognizer(longPressGesture)
            cell.descriptionLbl.text = self.strippingStr(text: self.viewModel.descriptionText)
            
            return cell
        }else if (indexPath.row == 3){
            let cell = tableView.dequeueReusableCell(withIdentifier: "tagsCell", for: indexPath) as! DetailCell
            cell.tagsCollection.reloadData()
            cell.tagsCollection.tag = 1
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "mapsCell", for: indexPath) as! DetailCell
            
            let initialLocation = CLLocation(latitude: self.viewModel.coords!.lat!, longitude: self.viewModel.coords!.lon!)
            cell.mapView.centerToLocation(initialLocation)
            let annotation = MKPointAnnotation()
                annotation.coordinate = CLLocationCoordinate2D(latitude: self.viewModel.coords!.lat!, longitude: self.viewModel.coords!.lon!)
                annotation.title = self.viewModel.titleText
            cell.mapView.addAnnotation(annotation)
            cell.mapView.layer.cornerRadius = 16
            
            return cell
        }
    }
    
    
}

extension DetailController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView.tag == 0){
            return CGSize(width: collectionView.bounds.width, height: self.view.frame.size.height * 0.57)
        }else{
            return CGSize(width: self.viewModel.tags[indexPath.row].widthOfString(usingFont: UIFont.systemFont(ofSize: 12)) + 30.0, height: 18)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        if(collectionView.tag == 0){
          return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        }else{
            return UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView.tag == 0){
            return 0
        }else{
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        if(collectionView.tag == 0){
            return 0
        }else{
            return 8
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag == 0){
            return self.viewModel.images.count
        }else{
            return self.viewModel.tags.count
        }
       
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.tag == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "imageCell", for: indexPath) as! ImageDetailCell
            
            let image = self.viewModel.images[indexPath.row]
            cell.imageView.setTemplateWithSubviews(true, viewBackgroundColor: .white)
            cell.imageView.sd_setImage(with: URL(string: image),completed: {_,_,_,_ in
                cell.imageView.setTemplateWithSubviews(false, animate: true)
            })
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "tagsCell", for: indexPath) as! TagsCell
            
            let tag = self.viewModel.tags[indexPath.row]
            cell.title.text = "#\(tag)"
            cell.layoutSubviews()
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = self.table.cellForRow(at: IndexPath(row: 0, section: 0)) as? DetailCell{
            cell.paginatorImage.setCurrentPage(at: indexPath.row,animated: true)
        }
           
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if let cell = collectionView.cellForItem(at: IndexPath(row: indexPath.row, section: 0)) as? ImageDetailCell{
            cell.imageView.setupImageViewer(urls: self.viewModel.imagesURLs,initialIndex: indexPath.row,options: [.closeIcon( UIImage(systemName: "xmark")!)])
        }
        
    }
   
}

private extension MKMapView {
  func centerToLocation(
    _ location: CLLocation,
    regionRadius: CLLocationDistance = 100
  ) {
    let coordinateRegion = MKCoordinateRegion(
      center: location.coordinate,
      latitudinalMeters: regionRadius,
      longitudinalMeters: regionRadius)
    setRegion(coordinateRegion, animated: true)
  }
}
