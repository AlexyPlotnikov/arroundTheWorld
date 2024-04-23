//
//  ArticlesController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import UIKit


class ArticlesController: UIViewController, Storyboardable, ArticlesDetailNavigation {

    var viewModel:ArticlesViewModel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(reloadArticles), name: Notification.Name("endLoadArticles"), object: nil)
       
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

extension ArticlesController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (ModelManager.shared.articles.results?.count ?? 0) > 0 else {return 6}
        return ModelManager.shared.articles.results!.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "articleCell", for: indexPath) as! ArticlesCell
        
        guard (ModelManager.shared.articles.results?.count ?? 0) > 0 else {return cell}
        let articles = ModelManager.shared.articles.results?[indexPath.row]
        
        cell.titleArticleLbl.text = (articles?.title ?? "-").lowercased()
        cell.dateArticleLbl.text = self.convertTimestampToDate(timestamp: articles?.publicationDate ?? 0)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard let results = ModelManager.shared.articles.results, !results.isEmpty else { return }
        if indexPath.row == results.count - 1 && (ModelManager.shared.articles.count ?? 0 > results.count) {
            self.viewModel.currentPage += 1
            self.viewModel.reloadArticles()
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let navVC = DetailNavigationController.createMain(with: "detailNC")
       // navVC.navigationBar.topItem?.title = self.viewModel.articles.results![indexPath.row].title 
        (navVC.viewControllers.first as! ArtcilesDetailController).title = ModelManager.shared.articles.results![indexPath.row].title
        (navVC.viewControllers.first as! ArtcilesDetailController).viewModel = ArticlesDetailViewModel(navigationController: self, articleID: ModelManager.shared.articles.results![indexPath.row].id!)
        self.viewModel.navigation.pushNavVC(NC: navVC)
    
    }
    
}
