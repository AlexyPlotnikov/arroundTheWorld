//
//  ViewController.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 05.10.2023.
//


import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
       
    }
}


extension MainViewController:UITableViewDelegate, UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 12
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "scrollCell",for: indexPath) as! MainCell
        
        return cell
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
      let offsetY = scrollView.contentOffset.y
      
        if let cell = table.cellForRow(at: IndexPath(row: 6, section: 0)) as? MainCell{
            UIView.animate(withDuration: 0.7, delay: 0, options: [.curveLinear], animations: {
                cell.scrollLbl.translatesAutoresizingMaskIntoConstraints = true
                
                cell.scrollLbl.frame.origin.x = -offsetY
                cell.scrollLbl.frame.size.width = self.table.frame.size.height
                print(cell.scrollLbl.frame.origin.x, cell.scrollLbl.frame.size.width)
            }, completion: nil)
           
           
        }
      
    }
}
