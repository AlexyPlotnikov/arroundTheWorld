//
//  LocationService.swift
//  ArroundTheWorld
//
//  Created by Алексей on 09.11.2023.
//

import CoreLocation

class LocationService: NSObject, CLLocationManagerDelegate {
    
    static let shared = LocationService()
    
    var locationManager: CLLocationManager?
    var currentCity: City?
    var updated:Bool = false

    private override init() {
        super.init()
        self.locationManager = CLLocationManager()
        self.locationManager?.delegate = self
        self.locationManager?.desiredAccuracy = kCLLocationAccuracyBest
        self.locationManager?.requestWhenInUseAuthorization()
    }
    
    func startUpdatingLocation() {
        self.locationManager?.startUpdatingLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
            // Обработка изменения статуса разрешения на геолокацию
        if(status == .authorizedAlways || status == .authorizedWhenInUse){
            self.updated=false
            self.locationManager?.startUpdatingLocation()
        }
        if status == .denied || status == .notDetermined {
            self.currentCity = .msk
            NotificationCenter.default.post(name: Notification.Name("reloadGeo"), object: nil)
            }
        }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else { return }
        if(!updated){
            self.updated=true
            CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
                if let error = error {
                    print("Failed to get address: \(error)")
                    return
                }
                
                if let city = placemarks?.first?.locality {
                   
                    switch city {
                    case "Новосибирск":
                        self.currentCity = .nsk
                    case "Москва":
                        self.currentCity = .msk
                    case "Санкт-Петербург":
                        self.currentCity = .spb
                    case "Нижний Новгород":
                        self.currentCity = .nnv
                    case "Екатеринбург":
                        self.currentCity = .ekb
                    case "Казань":
                        self.currentCity = .kzn
                    default:
                        self.currentCity = .msk
                        
                    }
                   
                }
                NotificationCenter.default.post(name: Notification.Name("reloadGeo"), object: nil)
            }
        }
    }
}
