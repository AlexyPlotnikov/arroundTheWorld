//
//  ViewController.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 05.10.2023.
//


import UIKit
import AppMetricaCore

class MainController: UIViewController, Storyboardable, UIGestureRecognizerDelegate {
    
 
    @IBOutlet weak var pageContainer: UIView!
    var viewModel:MainViewModel!
    @IBOutlet weak var segmentCollectionView: UICollectionView!
    var pageVC:MainPageController! 
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        tapGestureRecognizer.cancelsTouchesInView = false
        tapGestureRecognizer.delegate = self
        self.view.addGestureRecognizer(tapGestureRecognizer)
       
    }
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        let gestureState = gestureRecognizer.state.rawValue
        let isScrollingNotification = Notification.Name("isScrolling")
        
        if [3, 4, 5].contains(gestureState) {
            NotificationCenter.default.post(name: isScrollingNotification, object: true)
        } else {
            let isAboveThreshold = gestureRecognizer.location(in: self.view).y >= 52
            NotificationCenter.default.post(name: isScrollingNotification, object: isAboveThreshold)
        }
        
        return true
    }
    
    
    @objc func handleTap(_ gesture: UITapGestureRecognizer) {

    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        pageContainer.addSubview(pageVC.view)
    }
    
   
    
}


extension MainController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let title = self.viewModel.segmentTitles[indexPath.row]
        return CGSize(width: title.widthOfString(usingFont: UIFont.systemFont(ofSize: 28)) + 8, height: 52)
        }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        UIEdgeInsets(top: 0, left: 16, bottom: 0, right: 16)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.viewModel.segmentTitles.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "segmentCell", for: indexPath) as! SegmentControllCell
        
        let title = self.viewModel.segmentTitles[indexPath.row]
        cell.titleLbl.text = title
        cell.titleLbl.isUserInteractionEnabled = false
        cell.setState(isSelected: indexPath.row == self.viewModel.currentSelectedindex)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        pageVC.setViewControllers([pageVC.pageViewControllers[indexPath.row]], direction: self.viewModel.currentSelectedindex<indexPath.row ? .forward:.reverse, animated: true)
        self.viewModel.currentSelectedindex = indexPath.row
        self.segmentCollectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        self.segmentCollectionView.reloadData()
        
        var message = self.viewModel.segmentTitles[indexPath.row]
        AppMetrica.reportEvent(name: message, onFailure: { (error) in
            print("REPORT ERROR: %@", error.localizedDescription)
        })
    }
    
    
    
  
}

