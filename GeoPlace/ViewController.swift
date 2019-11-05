//
//  ViewController.swift
//  GeoPlace
//
//  Created by wtildestar on 03/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    let restaurantNames = [
        "Черный ручей", "Несколько ночей", "Закатные колонны",
        "Широкая равнина", "Луг сатиров", "Сторожевая излучина",
        "Мертвое ущелье", "Красные пещеры", "Лодочные колонны",
        "Звенящее логово", "Сияющее гнездо", "Стылая пещера",
        "Bled Swang", "Turry Li", "Merge You Kneel", "Your Space Here"
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return restaurantNames.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OwnTableViewCell
        
        cell.nameLabel.text = restaurantNames[indexPath.row]
        cell.imageOfPlace.image = UIImage(named: restaurantNames[indexPath.row])
        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true
        
        return cell
    }

     @IBAction func cancelAction(_ segue: UIStoryboardSegue) {}

}

