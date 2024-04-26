//
//  LoadingService.swift
//  ArroundTheWorld
//
//  Created by Алексей on 27.01.2024.
//

import Foundation

class ModelManager: NSObject {
    
    static let shared = ModelManager()
    var events: EventModel = EventModel(count: 0, next: "", previous: "", results: [])
    var articles: Artciles = Artciles(count: 0, next: "", previous: "", results: [])
    var places: PlacesModel = PlacesModel(count: 0, next: "", previous: "", results: [])
    private var loadingPosters = false
    private var loadingArticles = false
    private var loadingPlaces = false
    var loadCount = 0
    var cities:[CityModel] = []
    var baseTicket:BaseTicket = []
    var recomendTickets:[[Datum]] = []
    
    func firstLoad() {
        events = EventModel(count: 0, next: "", previous: "", results: [])
        articles = Artciles(count: 0, next: "", previous: "", results: [])
        places = PlacesModel(count: 0, next: "", previous: "", results: [])
        loadingPosters = false
        loadingArticles = false
        loadingPlaces = false
        loadEvents(byPage: 1) {
            self.checkLoadIsEnd()
        }
        loadPlaces(byPage: 1) {
            self.checkLoadIsEnd()
        }
        loadArticles(byPage: 1) {
            self.checkLoadIsEnd()
        }
    }
    
    func loadCity(completion: (() -> Void)? = nil){
        getArrayRequest(URLString: "https://kudago.com/public-api/v1.4/locations/?lang=ru", completion: {
            result in
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
               let tempCity = try? JSONDecoder().decode([CityModel].self, from: jsonData) {
                self.cities = tempCity
                completion?()
            }
        })
    }
    
    func loadWay(destinationCode:String, startDate:String, endDate:String, completion: (() -> Void)? = nil){
//        24573
        getRequest(URLString: "https://api.travelpayouts.com/aviasales/v3/prices_for_dates?origin=\(self.getCurrentCity() ?? "")&destination=\(destinationCode)&departure_at=\(startDate)&return_at=\(endDate)&unique=false&sorting=price&direct=false&currency=rub&limit=30&page=1&one_way=false",needSecretKey: true, completion: {
            result in
           
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
               let tempTickets = try? JSONDecoder().decode(Ticket.self, from: jsonData) {
                if let data = tempTickets.data{
                    self.recomendTickets.append(data)
                }
                
                completion?()
            }
           
            
        })
    }
    
    final func getCurrentCity()->String?{
        if let path = Bundle.main.path(forResource: "city", ofType: "json") {
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                let decodedData = try JSONDecoder().decode(Cities.self, from: data)
                return decodedData.first(where: {$0.name == LocationService.shared.currentCity?.rawValue})?.code ?? ""
                
            } catch {
                print("Ошибка при чтении файла:", error)
                return nil
            }
        } else {
            return nil
        }
    }
    
    func loadBase(completion: (() -> Void)? = nil){
        getArrayRequest(URLString: "https://jwmbgmjmubjefvvhhycj.supabase.co/rest/v1/TicketInfo",loadBase: true, completion: {
            result in
            
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
               let tempTicket = try? JSONDecoder().decode(BaseTicket.self, from: jsonData) {
                self.baseTicket = tempTicket
                completion?()
                
            }
        })
    }
    
    func loadEvents(byPage page: Int, completion: (() -> Void)? = nil) {
        guard !loadingPosters else { return }
        loadingPosters = true
        var url = "https://kudago.com/public-api/v1.4/events/?actual_since=\(Date().timeIntervalSince1970)&expand=images,site_url,place,tags,dates&fields=id,tags,dates,place,publication_date,description,title,images,site_url&text_format=text"
        if let location = LocationService.shared.currentCity {
            url += "&location=\(location)"
        }
        url += "&page=\(page)"
      print(url)
        getRequest(URLString: url) { result in
          //  print(result)
            self.loadingPosters = false
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
               let tempEvents = try? JSONDecoder().decode(EventModel.self, from: jsonData) {
                if self.events.results?.count == 0 || page == 1 {
                    self.events = tempEvents
                } else if let tempResults = tempEvents.results, !tempResults.isEmpty {
                    self.events.results?.append(contentsOf: tempResults)
                }
                completion?()
                NotificationCenter.default.post(name: Notification.Name("endLoadPosters"), object: nil)
              
                
            }
        }
    }
    
    func loadArticles(byPage page: Int, completion: (() -> Void)? = nil) {
        guard !loadingArticles else { return }
        loadingArticles = true
        var url = "https://kudago.com/public-api/v1.4/lists?fields=id,title,publication_date&text_format=text"
        if let location = LocationService.shared.currentCity {
            url += "&location=\(location)"
        }
        url += "&page=\(page)"
        print(url)
        getRequest(URLString: url) { result in
            self.loadingArticles = false
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
               let tempArticles = try? JSONDecoder().decode(Artciles.self, from: jsonData) {
                if self.articles.results?.count == 0 || page == 1 {
                    self.articles = tempArticles
                } else if let tempResults = tempArticles.results, !tempResults.isEmpty {
                    self.articles.results?.append(contentsOf: tempResults)
                }
                completion?()
                NotificationCenter.default.post(name: Notification.Name("endLoadArticles"), object: nil)
                
            }
        }
    }
    
    func loadPlaces(byPage page: Int, completion: (() -> Void)? = nil) {
        guard !loadingPlaces else { return }
        loadingPlaces = true
        var url = "https://kudago.com/public-api/v1.4/places?fields=id,tags,dates,publication_date,description,subway,coords,address,title,images,site_url"
        if let location = LocationService.shared.currentCity {
            url += "&location=\(location)"
        }
        url += "&page=\(page)"
        print(url)
        getRequest(URLString: url) { result in
            self.loadingPlaces = false
            if let jsonData = try? JSONSerialization.data(withJSONObject: result, options: .prettyPrinted),
               let tempPlaces = try? JSONDecoder().decode(PlacesModel.self, from: jsonData) {
                if self.places.results?.count == 0 || page == 1 {
                    self.places = tempPlaces
                } else if let tempResults = tempPlaces.results, !tempResults.isEmpty {
                    self.places.results?.append(contentsOf: tempResults)
                }
                completion?()
                NotificationCenter.default.post(name: Notification.Name("endLoad"), object: nil)
              
            }
        }
    }
    
    func checkLoadIsEnd() {
        loadCount += 1
        if loadCount == 3 {
            loadCount = 0
            NotificationCenter.default.post(name: Notification.Name("loadedALL"), object: nil)
        }
    }
}

