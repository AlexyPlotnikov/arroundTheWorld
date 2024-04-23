//
//  PaginationView.swift
//  ArroundTheWorld
//
//  Created by Алексей on 10.11.2023.
//

import UIKit

class PaginationView: UIView {
        var numberOfPages: Int = 0 {
            didSet {
                setupDots()
            }
        }
    
        var currentDot: Int = 0 {
            didSet{
              moveDot(index: currentDot)
            }
        }
    
        private var grayColor = UIColor.init(displayP3Red: 153/255, green: 153/255, blue: 153/255, alpha: 1)
        private var dotViews: [UIView] = []

        override init(frame: CGRect) {
            super.init(frame: frame)
        }

        required init?(coder aDecoder: NSCoder) {
            super.init(coder: aDecoder)
        }

        private func setupDots() {
            // Удалить старые точки
            dotViews.forEach { $0.removeFromSuperview() }
            dotViews.removeAll()
            self.backgroundColor = .clear

            // Добавить новые точки
            for i in 0..<numberOfPages {
                let dot = UIView()
                dot.backgroundColor = grayColor
                dot.layer.cornerRadius = 1
                dot.translatesAutoresizingMaskIntoConstraints = false
                dot.tag = i
                addSubview(dot)
                dotViews.append(dot)

                // Добавить ограничения
                NSLayoutConstraint.activate([
                    dot.heightAnchor.constraint(equalToConstant: 5),
                    dot.widthAnchor.constraint(equalToConstant: 5),
                    dot.centerYAnchor.constraint(equalTo: centerYAnchor)
                ])

                if i == 0 {
                    dot.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true
                } else {
                    let previousDot = dotViews[i - 1]
                    dot.leadingAnchor.constraint(equalTo: previousDot.trailingAnchor, constant: 10).isActive = true
                }
            }
        }
    
    private func moveDot(index:Int){
        dotViews.forEach({$0.backgroundColor = $0.tag == index ? .white:grayColor})
    }
}
