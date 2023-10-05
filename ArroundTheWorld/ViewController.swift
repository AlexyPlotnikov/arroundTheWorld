//
//  ViewController.swift
//  ArroundTheWorld
//
//  Created by Алексей Плотников on 05.10.2023.
//


import UIKit

class ViewController: UIViewController {
    
    let label = UILabel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Установка текста и стиля для метки
        label.text = "Это бесконечная бегущая строка!"
        label.textColor = .white
        label.font = UIFont.systemFont(ofSize: 20)
        label.sizeToFit()
        
        // Установка начальной позиции метки за пределами экрана
        label.frame.origin.x = view.frame.width
        label.frame.origin.y = 400
        // Добавление метки на экран
        view.addSubview(label)
        
        // Запуск анимации бегущей строки
        UIView.animate(withDuration: 10, delay: 0, options: [.curveLinear, .repeat], animations: {
            self.label.frame.origin.x = -self.label.frame.width
        }, completion: nil)
    }
}


