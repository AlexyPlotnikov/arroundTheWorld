//
//  DateCalendar.swift
//  ArroundTheWorld
//
//  Created by Алексей on 15.11.2023.
//

import Foundation

//extension ArticlesController: JTACMonthViewDelegate, JTACMonthViewDataSource{
//    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, willDisplay cell: JTAppleCalendar.JTACDayCell, forItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) {
//        configureCell(view: cell, cellState: cellState)
//    }
//
//    func calendar(_ calendar: JTAppleCalendar.JTACMonthView, cellForItemAt date: Date, cellState: JTAppleCalendar.CellState, indexPath: IndexPath) -> JTAppleCalendar.JTACDayCell {
//        let cell = calendar.dequeueReusableJTAppleCell(withReuseIdentifier: "dateCell", for: indexPath) as! DateCell
//        self.calendar(calendar, willDisplay: cell, forItemAt: date, cellState: cellState, indexPath: indexPath)
//           return cell
//    }
//
//    func configureCalendar(_ calendar: JTAppleCalendar.JTACMonthView) -> JTAppleCalendar.ConfigurationParameters {
//        let formatter = DateFormatter()
//       formatter.dateFormat = "yyyy MM dd"
//       let startDate = formatter.date(from: "2023 01 01")!
//       let endDate = Date()
//       return ConfigurationParameters(startDate: startDate, endDate: endDate)
//    }
//
//    func configureCell(view: JTACDayCell?, cellState: CellState) {
//       guard let cell = view as? DateCell  else { return }
//       cell.dateLbl.text = cellState.text
//       handleCellTextColor(cell: cell, cellState: cellState)
//    }
//
//    func handleCellTextColor(cell: DateCell, cellState: CellState) {
//       if cellState.dateBelongsTo == .thisMonth {
//          cell.dateLbl.textColor = UIColor.blackTitle()
//       } else {
//          cell.dateLbl.textColor = UIColor.grayTitles()
//       }
//    }
//}
