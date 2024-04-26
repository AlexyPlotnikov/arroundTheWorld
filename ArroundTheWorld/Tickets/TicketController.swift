//
//  TicketController.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 22.04.2024.
//

import UIKit
import SDWebImage
import SafariServices

class TicketController: UIViewController, Storyboardable, SFSafariViewControllerDelegate {
    
    var viewModel:TicketViewModel!
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        ModelManager.shared.loadBase(completion: {
        
                for ticket in ModelManager.shared.baseTicket{
                    let day1 = self.getNextWeekDate(for: ticket.startDayOfWeek!)
                    let day2 = self.getNextWeekDate(for: ticket.endDayOfWeek!)
                    print(day1, day2)
//                    ModelManager.shared.loadWay(destinationCode: ticket.cityCode!, startDate: day1!, endDate: day2!,completion: {
//                        DispatchQueue.main.async {
//                            self.table.reloadData()
//                        }
//                    })
                }
        })
    }
    
//    func getNextDayOfWeek(firstDate:Int, secondDate:Int) -> (String,String) {
//        let calendar = Calendar.current
//        var startDate = Date()
//        
//        // Находим дату следующего понедельника
//        while calendar.component(.weekday, from: startDate) != 2 {
//            startDate = calendar.date(byAdding: .day, value: firstDate, to: startDate)!
//        }
//        
//        // Добавляем 6 дней для получения даты воскресенья на следующей неделе
//        let endDate = calendar.date(byAdding: .day, value: secondDate, to: startDate)!
//        
//        return (self.dateFromJSON(startDate), self.dateFromJSON(endDate))
//    }
    
    func getNextWeekDate(for dayOfWeek: Int) -> String? {
        let today = Date()
           
           var calendar = Calendar.current
           calendar.firstWeekday = 2 // Понедельник - 2
           
           let currentWeekday = calendar.component(.weekday, from: today)
           
           var components = DateComponents()
           components.day = (dayOfWeek - currentWeekday + 7) % 7
           
           if let nextWeekDate = calendar.date(byAdding: components, to: today) {
               return self.dateFromJSON(nextWeekDate)
           } else {
               return nil
           }
        
    }
    
    func getWeekendDates()->(String,String)?{
        let calendar = Calendar.current

        if let nextWeekend = calendar.nextWeekend(startingAfter: Date()) {
            let startDate = nextWeekend.start
            let endDate = nextWeekend.end
            
            return (self.dateFromJSON(startDate), self.dateFromJSON(endDate))
        } else {
            return nil
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        NotificationCenter.default.post(name: Notification.Name("setupScroll"), object: self.table)
    }
    
    func dateFromJSON(_ JSONdate: Date) -> String {
        
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "yyyy-MM-dd"
        
        return dateFormatterPrint.string(from: JSONdate)
        
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
   
}

extension TicketController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ModelManager.shared.baseTicket.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 206
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MainTicketCell
        cell.collectionTickets.delegate = self
        cell.collectionTickets.dataSource = self
        cell.collectionTickets.tag = indexPath.row
        cell.collectionTickets.reloadData()
        
        return cell
    }
    
    
}

extension TicketController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if(indexPath.row == 0){
            return CGSize(width: 146, height: 198)
        }else{
            return CGSize(width: 172, height: 198)
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let code = ModelManager.shared.baseTicket[collectionView.tag].cityCode
        return 1 + (ModelManager.shared.recomendTickets.first(where: {$0[0].destination == code})?.count ?? 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if(indexPath.row == 0){
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "titleCell", for: indexPath) as! RecomendedTicketCell
            
            let ticket = ModelManager.shared.baseTicket[collectionView.tag]
            cell.imageRecomend.sd_setImage(with: URL(string: ticket.imageWay ?? ""))
            cell.imageRecomend.contentMode = .scaleToFill
            cell.titleRecomend.text = ticket.titleWay
            cell.subtitleRecomend.text = ticket.subtitleWay
            
            return cell
        }else{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ticketCell", for: indexPath) as! RecomendedTicketCell
            let code = ModelManager.shared.baseTicket[collectionView.tag].cityCode
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
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if(indexPath.row > 0){
            let code = ModelManager.shared.baseTicket[collectionView.tag].cityCode
            let ticket = ModelManager.shared.recomendTickets.first(where: {$0[0].destination == code})![indexPath.row - 1]
            print("https://aviasales.ru" + (ticket.link ?? ""))
            
            guard let url = URL(string: "https://aviasales.ru" + (ticket.link ?? "")) else {
                 return
            }

            if UIApplication.shared.canOpenURL(url) {
                 UIApplication.shared.open(url, options: [:], completionHandler: nil)
            }
//            if let url = URL(string: "https://aviasales.ru" + (ticket.link ?? "")) {
//                let safariViewController = SFSafariViewController(url: url)
//                safariViewController.delegate = self
//                self.navigationController?.present(safariViewController, animated: true, completion: nil)
//            }
        }
    }
    
}
