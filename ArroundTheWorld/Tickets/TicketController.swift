//
//  TicketController.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 22.04.2024.
//

import UIKit
import SDWebImage
import SafariServices
import MarqueeLabel
import Kingfisher

class TicketController: UIViewController, Storyboardable, SFSafariViewControllerDelegate {
    
    var viewModel:TicketViewModel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ModelManager.shared.loadBase(completion: {
                ModelManager.shared.loadPopularWays(completion: {
                    DispatchQueue.main.async{
                        if let cell = self.table.cellForRow(at: IndexPath(row: 2, section: 0)) as? MainTicketCell{
                            cell.popularCollection.reloadData()
                        }
                    }
                })
                for ticket in ModelManager.shared.baseTicket{
                    let day1 = self.getNextWeekDate(for: ticket.startDayOfWeek!)
                    let day2 = self.getNextWeekDate(for: ticket.endDayOfWeek!)
                    ModelManager.shared.loadWay(destinationCode: ticket.cityCode!, startDate: day1!, endDate: day2!,completion: {
                        DispatchQueue.main.async {
                            self.table.tableFooterView = UITableViewHeaderFooterView(frame: CGRect(x: 0, y: 0, width: self.table.frame.size.width, height: 120))
                            self.table.reloadData()
                            
                        }
                    })
                }
             })
        
        
    }
    
 func getCityByCode(code:String)->String?{
         if let path = Bundle.main.path(forResource: "city", ofType: "json"),  self.viewModel.decodedCities == nil {
             do {
                 let data = try Data(contentsOf: URL(fileURLWithPath: path), options: .mappedIfSafe)
                 let decodedData = try JSONDecoder().decode(Cities.self, from: data)
                 self.viewModel.decodedCities = decodedData
                 return self.viewModel.decodedCities.first(where: {$0.code == code})?.name ?? ""
                 
             } catch {
                 print("Ошибка при чтении файла:", error)
                 return nil
             }
         } else {
             return self.viewModel.decodedCities.first(where: {$0.code == code})?.name ?? ""
         }
     }

    
   
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("setupScroll"), object: self.table)
    }
    
    func getNextWeekDate(for dayOfWeek: Int) -> String? {
        let today = Date()
           
           var calendar = Calendar.current
           calendar.firstWeekday = 2
        
           let currentWeekday = calendar.component(.weekday, from: today) - 1
           
           var components = DateComponents()
           components.day = (7 - currentWeekday) + dayOfWeek
           
           if let nextWeekDate = calendar.date(byAdding: components, to: today) {
               return self.dateFromJSON(nextWeekDate)
           } else {
               return nil
           }
        
    }
    
    
    func dateFromJSON(_ JSONdate: Date) -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        return dateFormatterPrint.string(from: JSONdate)
    }
    
    func convertDate(_ JSONdate: String) -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.locale = Locale(identifier: "ru_RU")
        dateFormatterPrint.dateFormat = "d MMMM"
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd"
        
        // Проверка на корректность формата даты
        guard let date = dateFormatterGet.date(from: JSONdate) else {
            print("Ошибка: Некорректный формат даты")
            return ""
        }
        
        return dateFormatterPrint.string(from: date)
        
    }

    
    func calculateTime(_ dateString: String, addedMinutes: Int) -> (String, String)? {
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "HH:mm"
        
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"

        // Проверка на корректность формата даты
        guard let date = dateFormatterGet.date(from: dateString) else {
            print("Ошибка: Некорректный формат даты")
            return nil
        }
        
        // Вычисление новой даты с добавленными минутами
        let calendar = Calendar.current
        let newDate = calendar.date(byAdding: .minute, value: addedMinutes, to: date)!
        
        // Форматирование времени в формат "часы:минуты"
        let originalTime = dateFormatterPrint.string(from: date)
        let newTime = dateFormatterPrint.string(from: newDate)
        
        return (originalTime, newTime)
    }
   
    
    func formatPrice(price:Int)->String?{
        let numberFormatter = NumberFormatter()
        numberFormatter.numberStyle = .decimal // Устанавливаем стиль форматирования как десятичный
        numberFormatter.groupingSeparator = " " // Устанавливаем пробел в качестве разделителя групп

        // Форматируем число с пробелами между цифрами
        if let formattedNumber = numberFormatter.string(from: NSNumber(value: price)) {
            return formattedNumber // Вывод: "1 234 567"
        }else{
            return nil
        }
    }
    
    @IBAction func searchTickets(_ sender: Any) {
        self.viewModel.navigation.pushSearchTicket()
    }
    
    func downloadImageAndUpdateCell(from url: URL, forCell cell: UICollectionViewCell, at indexPath: IndexPath) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data, let image = UIImage(data: data) {
                DispatchQueue.main.async {
                    // Найти imageView в вашей ячейке и установить изображение
                    if let cell = cell as? PopularCell { // Замените YourCustomCollectionViewCell на ваш класс ячейки
                        if let imageView = cell.cityImage { // Предполагаем, что изображение находится в imageView
                            imageView.image = image
                        }
                    }
                }
            }
        }.resume()
    }
}

extension TicketController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard (ModelManager.shared.baseTicket.count) > 0 else {
            return 0
        }
        return ModelManager.shared.baseTicket.count + 1
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if(indexPath.row != 2){
            return 206
        }else{
            return 178
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if(indexPath.row != 2){
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTicketCell
            cell.collectionTickets.delegate = self
            cell.collectionTickets.dataSource = self
            cell.collectionTickets.tag = indexPath.row
            cell.collectionTickets.reloadData()
            
            return cell
        }else{
            let cell = tableView.dequeueReusableCell(withIdentifier: "promoCell", for: indexPath) as! MainTicketCell
           
            cell.backView.layer.cornerRadius = 16
            cell.backView.layer.masksToBounds = true
            cell.popularCollection.tag = indexPath.row
            cell.popularCollection.delegate = self
            cell.popularCollection.dataSource = self
            cell.popularCollection.reloadData()
            cell.scrollingLabel.type = .continuous
            cell.scrollingLabel.speed = .duration(10)
            cell.scrollingLabel.animationDelay = 0
            cell.scrollingLabel.holdScrolling = false
            cell.scrollingLabel.triggerScrollStart()
            
            return cell
        }
    }
    
    
}

extension TicketController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(collectionView.tag != 2){
            if(indexPath.row == 0){
                return CGSize(width: 146, height: 198)
            }else{
                return CGSize(width: 172, height: 198)
            }
        }else{
            return CGSize(width: 170, height: 120)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if(collectionView.tag != 2){
           let code = ModelManager.shared.baseTicket[collectionView.tag < 2 ? collectionView.tag:collectionView.tag-1].cityCode
           return 1 + (ModelManager.shared.recomendTickets.first(where: {$0[0].destination == code})?.count ?? 0)
       }else{
           return ModelManager.shared.popularWay?.data?.count ?? 0
       }
              
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(collectionView.tag != 2){
            if(indexPath.row == 0){
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as! RecomendedTicketCell
                
                let ticket = ModelManager.shared.baseTicket[collectionView.tag < 2 ? collectionView.tag:collectionView.tag-1]
                cell.imageRecomend.sd_setImage(with: URL(string: ticket.imageWay ?? ""))
                cell.imageRecomend.contentMode = .scaleToFill
                cell.titleRecomend.text = ticket.titleWay
                cell.subtitleRecomend.text = ticket.subtitleWay
                
                let day1 = self.getNextWeekDate(for: ticket.startDayOfWeek!)
                let day2 = self.getNextWeekDate(for: ticket.endDayOfWeek!)
                
                cell.datesRecomend.text = "\(self.convertDate(day1!)) - \(self.convertDate(day2!))"
                
                return cell
            }else{
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketCell", for: indexPath) as! RecomendedTicketCell
                let code = ModelManager.shared.baseTicket[collectionView.tag < 2 ? collectionView.tag:collectionView.tag-1].cityCode
                let ticket = ModelManager.shared.recomendTickets.first(where: {$0[0].destination == code})![indexPath.row - 1]
                cell.priceLbl.text = "\(self.formatPrice(price: ticket.price ?? 0) ?? "")₽"
                cell.discontLbl.isHidden = indexPath.row != 1
                
                let time = self.calculateTime(ticket.departureAt ?? "", addedMinutes: ticket.durationTo ?? 0)
                cell.timeIntervalTo.text = "\(time?.0 ?? "")-\(time?.1 ?? "")"
                cell.timeTo.text = String(format: "%02dч %02dм", (ticket.durationTo ?? 0) / 60, (ticket.durationTo ?? 0) % 60)
                cell.returnTransferTo.text = ticket.transfers == 0 ? "без пересадок":"пересадок: \(ticket.transfers ?? 0)"
                
                
                let timeBack = self.calculateTime(ticket.returnAt ?? "", addedMinutes: ticket.durationBack ?? 0)
                cell.timeIntervalBack.text = "\(timeBack?.0 ?? "")-\(timeBack?.1 ?? "")"
                cell.timeBack.text = String(format: "%02dч %02dм", (ticket.durationBack ?? 0) / 60, (ticket.durationBack ?? 0) % 60)
                cell.returnTransferBack.text = ticket.returnTransfers == 0 ? "без пересадок":"пересадок: \(ticket.returnTransfers ?? 0)"
                
                cell.airlineImage.sd_setImage(with: URL(string: "http://pics.avs.io/200/200/\(ticket.airline ?? "").png")!)
                
                return cell
            }
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "popularCell", for: indexPath) as! PopularCell
            let popularWay = ModelManager.shared.popularWay?.data?[indexPath.row]
           
            cell.nameWayLbl.text = popularWay?.destinationNameDeclined
            cell.priceLbl.text = "\(self.formatPrice(price: popularWay?.price ?? 0) ?? "")₽"
            if(!cell.loaded){
                cell.loaded = true
                ModelManager.shared.loadImageByCity(cityName: popularWay?.destinationName ?? "", completion: {
                    result in
                    DispatchQueue.main.async{
                        cell.cityImage.image = nil
                        cell.cityImage.kf.setImage(with: URL(string: result)!)
                        cell.cityImage.contentMode = .scaleAspectFill
                        cell.cityImage.layer.cornerRadius = 12
                        cell.cityImage.layer.masksToBounds = true
                    }
                })
            }
            
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row > 0){
            let code = ModelManager.shared.baseTicket[collectionView.tag < 2 ? collectionView.tag:collectionView.tag-1].cityCode
            let ticket = ModelManager.shared.recomendTickets.first(where: {$0[0].destination == code})![indexPath.row - 1]
            print("https://aviasales.ru" + (ticket.link ?? ""))
            
            guard let url = URL(string: "https://aviasales.ru" + (ticket.link ?? "")) else {
                 return
            }

            if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
        }
    }
    
}
