//
//  RatingControl.swift
//  GeoPlace
//
//  Created by wtildestar on 08/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

// Привязываем класс RatingControl для пятой ячейки с рейтингом и создаем в нем кнопку
// @IBDesignable отображает в сториборде визуальные изменения сделанные в коде
@IBDesignable class RatingControl: UIStackView {
    
    // MARK: Properties
    
    var rating = 0 {
        didSet {
            updateButtonSelectionState()
            isUserInteractionEnabled = false
        }
    }
    
    // Создаем массив кнопок рейтинга
    private var ratingButtons = [UIButton]()
    
    // можно отобразить сами свойства которые будут отображаться в attributes inspector через @IBInspectable
    @IBInspectable var starSize: CGSize = CGSize(width: 44.0, height: 44.0) {
        // Воспользуемся did set чтобы была возможность менять значения прямо через attributes builder в stotyboard'e
        didSet {
            setupButtons()
        }
    }
    @IBInspectable var starCount: Int = 5 {
        didSet {
            setupButtons()
        }
    }

    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButtons()
    }
    
    required init(coder: NSCoder) {
        super.init(coder: coder)
        setupButtons()
    }

    // MARK: Button Action
    @objc func ratingButtonTapped(button: UIButton) {
        guard let index = ratingButtons.firstIndex(of: button) else { return }
        
        // Вычисляем рейтинг выбранной кнопки
        let selectedRating = index + 1
        
        if selectedRating == rating {
            rating = 0
        } else {
            rating = selectedRating
        }
        
    }
    
    // MARK: Private Methods
    
    private func setupButtons() {
        
        // удаляем все кнопки в массиве с кнопками рейтинга
        for button in ratingButtons {
            removeArrangedSubview(button)
            button.removeFromSuperview()
        }
        
        ratingButtons.removeAll()
        
        // Для отображения кнопок в интерфейс билдере необходимо явно указать от куда будем брать изображения
        let bundle = Bundle(for: type(of: self))
        
        // Загрузка изображений кнопок рейтинга
        let filledStar = UIImage(named: "star-filled",
                                 in: bundle,
                                 compatibleWith: self.traitCollection)
        
        let emptyStar = UIImage(named: "star-blank",
                                in: bundle,
                                compatibleWith: self.traitCollection)
        
        let highlightedStar = UIImage(named: "star-highlighted",
                                      in: bundle,
                                      compatibleWith: self.traitCollection)
        
        for _ in 0 ..< starCount {

            // Создаем кнопку
           let button = UIButton()
           
            // Устанавливаем изображение для кнопок
            button.setImage(emptyStar, for: .normal)
            button.setImage(filledStar, for: .selected)
            button.setImage(highlightedStar, for: .highlighted)
            button.setImage(highlightedStar, for: [.highlighted, .selected])
            
           
           // Добавляем констрейнты
           button.translatesAutoresizingMaskIntoConstraints = false // выключает автоматическисгенерированные констрейнты для кнопки
            button.heightAnchor.constraint(equalToConstant: starSize.height).isActive = true
            button.widthAnchor.constraint(equalToConstant: starSize.width).isActive = true
           
           // Устанавливаем действие для кнопки
           button.addTarget(self, action: #selector(ratingButtonTapped(button:)), for: .touchUpInside)
           
           // Добавляем кнопку в stackview
           addArrangedSubview(button)
            
            // Добавляем новую кнопку в массив с кнопками рейтинга
            ratingButtons.append(button)
                    
        }
        
        updateButtonSelectionState()
        
    }
    
    // Обновляем внешний вид звезд в соответствии с рейтингом
    private func updateButtonSelectionState() {
        for (index, button) in ratingButtons.enumerated() {
            button.isSelected = index < rating
        }
    }
    
}
