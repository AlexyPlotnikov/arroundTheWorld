//
//  ArtcilesDetailController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.01.2024.
//

import UIKit
import SDWebImage

class ArtcilesDetailController: UIViewController, Storyboardable, UIGestureRecognizerDelegate {

    var viewModel:ArticlesDetailViewModel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        navigationItem.setValue(1, forKey: "__largeTitleTwoLineMode")

        NotificationCenter.default.addObserver(self, selector: #selector(reloadArticles), name: Notification.Name("endLoadArticleDetail"), object: nil)
        DispatchQueue.main.async{
            self.table.showSkeletonView()
            self.createLeftButton()
        }
        
        setupGestureRecognizers()
    }
    
    func createLeftButton(){
        navigationItem.leftBarButtonItem = nil
        let backButton = UIButton(frame: CGRect(x: 0.0, y: 0.0, width: 32, height: 32))
            backButton.setImage(UIImage(named: "backIcon"), for: .normal)
            backButton.addTarget(self, action: #selector(back), for: .touchUpInside)
            backButton.tintColor = .clear
            self.navigationItem.leftBarButtonItem = UIBarButtonItem(customView: backButton)
    }
    
    @objc func back(){
        self.dismiss(animated: false, completion: nil)
    }
    
    private func setupGestureRecognizers() {
        let leftSwipe = UISwipeGestureRecognizer(target: self, action: #selector(self.swipeAction(swipe:)))
        leftSwipe.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(leftSwipe)
    }
    
    @objc func swipeAction(swipe: UISwipeGestureRecognizer) {
       let transition = CATransition()
       transition.duration = 0.3
       transition.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.easeInEaseOut)
       transition.type = CATransitionType.push
       transition.subtype = CATransitionSubtype.fromLeft
       self.view.window!.layer.add(transition, forKey: nil)
       self.dismiss(animated: false, completion: nil)
    }
    
   
    
    @objc func reloadArticles(){
        DispatchQueue.main.async{
            self.table.hideSkeletonView()
        }
    }

    func strippingStr(text:String) -> String{
        return text.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }

}

extension ArtcilesDetailController: UITableViewDelegate, UITableViewDataSource{
   
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.details?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       
            return UITableView.automaticDimension
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        if(indexPath.row == 0){
//            let cell = tableView.dequeueReusableCell(withIdentifier: "imageCell", for: indexPath) as! DetailArticleCell
//            let image = self.viewModel.details?.images?[indexPath.section].image
//            cell.imageDetail.sd_setImage(with: URL(string: image!))
//            return cell
//        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "textCell", for: indexPath) as! DetailArticleCell
            let detail = self.viewModel.details?.items?[indexPath.row]
            cell.titleDetail.text = (detail?.title ?? "").lowercased()
            cell.descriptionDetail.text = self.strippingStr(text: detail?.description ?? "")
            
            return cell
            
     //   }
    }
    
    
}

extension UIViewController {

/// Sets two lines for navigation title if needed
/// - Parameter animated: used for changing titles on one controller,in that case animation is off
func multilineNavTitle(_ animated:Bool = true) {
    
    if animated {
        // setting initial state for animation of title to look more native
        self.navigationController?.navigationBar.transform = CGAffineTransform.init(translationX: self.view.frame.size.width/2, y: 0)
        self.navigationController?.navigationBar.alpha = 0
    }
    
    //Checks if two lines is needed
    if self.navigationItem.title?.forTwoLines() ?? false {
        
        // enabling multiline
        navigationItem.setValue(true,
                                forKey: "__largeTitleTwoLineMode")
    } else {
        
        // disabling multiline
        navigationItem.setValue(false,
                                forKey: "__largeTitleTwoLineMode")
    }
    
    // laying out title without animation
    UIView.performWithoutAnimation {
        self.navigationController?.navigationBar.layoutSubviews()
        self.navigationController?.view.setNeedsLayout()
        self.navigationController?.view.layoutIfNeeded()
    }
    
    if animated {
        //animating title
        UIView.animate(withDuration: 0.3) {
            self.navigationController?.navigationBar.transform = CGAffineTransform.identity
            self.navigationController?.navigationBar.alpha = 1
        }
    }

}


}


fileprivate extension String {

/// Checks if navigation title is wider than label frame
/// - Returns: `TRUE` if title cannot fit in one line of navigation title label
func forTwoLines() -> Bool {
    
    let fontAttributes = [NSAttributedString.Key.font: UIFont.systemFont(ofSize: 24)]
    let size = self.size(withAttributes: fontAttributes)
    return size.width > size.width - 40 //in my case
    
}


}
