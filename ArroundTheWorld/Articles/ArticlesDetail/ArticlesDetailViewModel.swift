//
//  ArticlesDetailViewModel.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.01.2024.
//

import Foundation

protocol ArticlesDetailNavigation : AnyObject{
   
}

class ArticlesDetailViewModel{
    weak var navigation : ArticlesDetailNavigation!
    var articleID:Int!
    var details:ArticlesDetail?
    
    init(navigationController : ArticlesDetailNavigation, articleID:Int) {
        self.navigation = navigationController
        self.articleID = articleID
        self.loadDetail(articleID:self.articleID)
    }
    
    func loadDetail(articleID:Int){
        print("https://kudago.com/public-api/v1.4/lists/\(articleID)")
        getRequest(URLString: "https://kudago.com/public-api/v1.4/lists/\(articleID)?text_format=text", completion: {
            result in
           
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted){
                if let tempArticles = try? JSONDecoder().decode(ArticlesDetail.self, from: jsonData){
                    self.details = tempArticles
                    NotificationCenter.default.post(name: Notification.Name("endLoadArticleDetail"), object: nil)
                }
            }
            
        })
    }
}
