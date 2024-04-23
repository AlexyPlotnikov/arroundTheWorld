//
//  BannerController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 16.10.2023.
//

import UIKit
import FloatingPanel
import SDWebImage
import UIView_Shimmer
import FlexiblePageControl

class BannerController: UIViewController, Storyboardable,UIGestureRecognizerDelegate  {
    
    var viewModel:BannerViewModel!
    var fpc: FloatingPanelController!
    @IBOutlet weak var paginationView: FlexiblePageControl!
    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var descriptLbl: UILabel!
    
    @IBOutlet weak var geoButton: UIButton!
    @IBOutlet weak var imageCollection: UICollectionView!
    lazy var posterVC = {
        let poster = PosterController.createMain(with: "posterVC")
        let viewModel = PosterViewModel.init(navigationController: self)
        poster.viewModel = viewModel
        return poster
    }()
    
    
    lazy var ticketVC = {
        let ticket = TicketController.createMain(with: "ticketVC")
        let viewModel = TicketViewModel.init(navigationController: self)
        ticket.viewModel = viewModel
        return ticket
    }()
    lazy var placesVC = {
        let places = PlacesController.createMain(with: "placesVC")
        let viewModel = PlacesViewModel.init(navigationController: self)
        places.viewModel = viewModel
        return places
    }()
    lazy var articleVC = {
        let articles = ArticlesController.createMain(with: "articlesVC")
        let viewModel = ArticlesViewModel.init(navigationController: self)
        articles.viewModel = viewModel
        return articles
    }()
    
   // lazy var housingVC = HousingController.createMain(with: "housingVC")
    lazy var eventsVC = {
        let events = EventsController.createMain(with: "eventsVC")
        let viewModel = EventViewModel.init(navigationController: self)
        events.viewModel = viewModel
        return events
    }()
    lazy var pageControllers = [posterVC,ticketVC, articleVC, placesVC, eventsVC]
    var timer:Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        self.titleLbl.setTemplateWithSubviews(true,viewBackgroundColor: .white)
        self.descriptLbl.setTemplateWithSubviews(true,viewBackgroundColor: .white)
        self.geoButton.setTitle(LocationService.shared.currentCity?.rawValue, for: .normal)
        
        let mainController = MainController.createMain(with: "mainVC")
        let mainViewModel = MainViewModel.init(navigationController: self)
        DispatchQueue.main.async{
            let pageVC = MainPageController.createMain(with: "MainPageVC")
            pageVC.pageViewControllers = self.pageControllers
            mainController.viewModel = mainViewModel
            mainController.pageVC = pageVC
            self.setupPanel(controller: mainController)
        }
    
        NotificationCenter.default.addObserver(self, selector: #selector(reloadArticles), name: Notification.Name("loadedALL"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(stopTimer), name: Notification.Name("stopTimer"), object: nil)

        DispatchQueue.main.async{
            self.imageCollection.showSkeletonView()
        }
       
    }
    
    @objc func stopTimer(){
        if(timer != nil){
            self.timer.invalidate()
            self.timer = nil
        }
    }
   
   

@objc func reloadArticles(){
    DispatchQueue.main.async{
        self.paginationView.isHidden = false
        self.paginationView.numberOfPages = 3
        let config = FlexiblePageControl.Config(
            displayCount: 3,
            dotSize: 5,
            dotSpace: 6,
            smallDotSizeRatio: 0.5,
            mediumDotSizeRatio: 0.7
        )
        self.paginationView.pageIndicatorTintColor = UIColor.init(displayP3Red: 255/255, green: 255/255, blue: 255/255, alpha: 0.4)
        self.paginationView.currentPageIndicatorTintColor = UIColor.init(displayP3Red: 245/255, green: 245/255, blue: 245/255, alpha: 1)

        self.paginationView.setConfig(config)
        self.titleLbl.setTemplateWithSubviews(false)
        self.descriptLbl.setTemplateWithSubviews(false)
        self.imageCollection.hideSkeletonView()
        self.imageCollection.reloadData()
        self.autoScrollCollectionView()
    }
}
    
   
    @IBAction func selectCity(_ sender: Any) {
        self.viewModel.navigation.pushCity()
    }
    
   
    
    func setupPanel(controller:UIViewController){
        fpc = FloatingPanelController()
        fpc.delegate = self
        fpc.layout = FloatingPanelStocksLayout()
        fpc.move(to: .tip, animated: true)
        let appearance = SurfaceAppearance()
        let shadow = SurfaceAppearance.Shadow()
        shadow.color = .clear
        appearance.shadows = [shadow]
        fpc.surfaceView.appearance = appearance
        fpc.backdropView.backgroundColor = .white
        fpc.set(contentViewController: controller)
        fpc.surfaceView.grabberHandle.isHidden = true
        fpc.addPanel(toParent: self)
        fpc.panGestureRecognizer.delegateProxy = self
        
        NotificationCenter.default.addObserver(self, selector: #selector(setupScroll(notification:)), name: Notification.Name("setupScroll"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(checkScrollEnabled(notification:)), name: Notification.Name("isScrolling"), object: nil)
    }
    
  
    @objc func checkScrollEnabled(notification:Notification){
        fpc.panGestureRecognizer.isEnabled = (notification.object as! Bool)
        
    }
    
   @objc func setupScroll(notification: Notification){
       let scroll = (notification.object as! UIScrollView)
       fpc.track(scrollView: scroll)
    }
    
    func dateFromJSON(_ JSONdate: String) -> String {
        if(JSONdate != ""){
            let dateFormatterGet = DateFormatter()
            var tempDate = JSONdate
    
                dateFormatterGet.dateFormat = "yyyy-MM-dd"
            let dateFormatterPrint = DateFormatter()
            dateFormatterPrint.dateFormat = "yyyy-MM-dd"
            dateFormatterPrint.dateStyle = DateFormatter.Style.full
            dateFormatterPrint.locale = NSLocale(localeIdentifier: "ru") as Locale
            
            let date = dateFormatterGet.date(from: tempDate)
            
            return dateFormatterPrint.string(from: date!)
        }else{
            return ""
        }
    }
    
    func autoScrollCollectionView() {
        if timer == nil{
            timer = Timer.scheduledTimer(withTimeInterval: 6.0, repeats: true) { timer in
                guard let collectionView = self.imageCollection else {
                    timer.invalidate()
                    return
                }
                
                if let visibleIndexPath = collectionView.indexPathsForVisibleItems.first{
                    
                    let nextIndexPath = IndexPath(item: visibleIndexPath.item + 1, section: visibleIndexPath.section)
                    if (nextIndexPath.item < collectionView.numberOfItems(inSection: visibleIndexPath.section)) {
                        collectionView.scrollToItem(at: nextIndexPath, at: .centeredHorizontally, animated: true)
                    } else {
                        let firstIndexPath = IndexPath(item: 0, section: 0)
                        collectionView.scrollToItem(at: firstIndexPath, at: .centeredHorizontally, animated: true)
                    }
                }
            }
            
            timer.fire()
        }
    }
}


//MARK: collection delegate
extension BannerController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        .zero
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.size.width, height: 420)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 3
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "bannerCell", for: indexPath) as! BannerCell
        
        guard (ModelManager.shared.events.results?.count ?? 0) > 0 else {return cell}
        let poster = ModelManager.shared.events.results?[indexPath.row]
        
        cell.imageView.sd_setImage(with: URL(string: (poster?.images[0].image)!)!)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(ModelManager.shared.events.results?.count ?? 0 > 0){
            self.viewModel.navigation.pushDetail(model: ModelManager.shared.events.results?[indexPath.row],type: .poster)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if (ModelManager.shared.events.results!.count > 0){
            let banner = ModelManager.shared.events.results?[indexPath.row]
            self.titleLbl.text = banner?.title
            self.descriptLbl.text = self.dateFromJSON(banner?.dates?.last?.start_date ?? "")
            self.paginationView.setCurrentPage(at: indexPath.row)
        }
        
    }

    
    
}

//MARK: navigation

extension BannerController:MainNavigation, PlacesNavigation, FloatingPanelControllerDelegate, PosterNavigation,  ArticlesNavigation, EventNavigation, TicketNavigation{
    func pushDetail<T>(model: T, type: DetailTypeEnum) where T : Decodable, T : Encodable {
        self.viewModel.navigation.pushDetail(model: model, type: type)
    }
    
    func pushNavVC(NC: UINavigationController) {
        self.viewModel.navigation.pushNavVC(NC: NC)
    }
    
    func pushDetail(poster: ResultModel, type: DetailTypeEnum) {
        self.viewModel.navigation.pushDetail(model: poster, type: type)
    }
    
}
