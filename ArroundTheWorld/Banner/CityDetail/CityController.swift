//
//  CityController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 14.04.2024.
//

import UIKit

class CityController: UIViewController, Storyboardable {

    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        ModelManager.shared.loadCity(completion: {
            DispatchQueue.main.async{
                self.table.reloadData()
                
                NotificationCenter.default.post(name: Notification.Name("stopTimer"), object: nil)
                
            }
        })
    }
    

    
}


extension CityController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelManager.shared.cities.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! CityCell
        
        cell.titleCity.text = ModelManager.shared.cities[indexPath.row].name ?? ""
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        LocationService.shared.currentCity = City.init(rawValue: ModelManager.shared.cities[indexPath.row].name!)
        ModelManager.shared.loadCount = 0
        ModelManager.shared.firstLoad()
        NotificationCenter.default.post(name: Notification.Name("reloadGeo"), object: nil)
        self.dismiss(animated: true)
    }
    
}
