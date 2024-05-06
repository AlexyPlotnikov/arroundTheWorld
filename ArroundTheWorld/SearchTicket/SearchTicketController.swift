//
//  SearchTicketController.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 06.05.2024.
//

import UIKit

class SearchTicketController: UIViewController, Storyboardable {

    @IBOutlet weak var geoBtn: UIButton!
    @IBOutlet weak var searchField: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.configSearchField()
        self.geoBtn.setTitle(LocationService.shared.currentCity?.rawValue, for: .normal)
    }
    
    func configSearchField(){
        let imageAttachment = NSTextAttachment()
           imageAttachment.image = UIImage(named: "imageName")
           let imageString = NSAttributedString(attachment: imageAttachment)
           let placeholderString = NSMutableAttributedString(string: "куда")
           placeholderString.append(imageString)
            searchField.attributedPlaceholder = placeholderString
    }
    

}
