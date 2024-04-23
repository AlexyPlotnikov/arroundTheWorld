//
//  MainPageController.swift
//  ArroundTheWorld
//
//  Created by Алексей on 07.10.2023.
//

import UIKit

class MainPageController: UIPageViewController, Storyboardable {
    
    var pageViewControllers: [UIViewController]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
       
        
        if let firstViewController = pageViewControllers.first {
                setViewControllers([firstViewController],
                    direction: .forward,
                    animated: false,
                    completion: nil)
            }
    }
    

    

}


