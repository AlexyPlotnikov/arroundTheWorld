//
//  HousingController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import UIKit

class HousingController: UIViewController, Storyboardable {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
       // NotificationCenter.default.post(name: Notification.Name("setupScroll"), object: self)
    }

}
