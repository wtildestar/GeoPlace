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
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")
        cell?.textLabel?.text = restaurantNames[indexPath.row]
        cell?.imageView?.image = UIImage(named: restaurantNames[indexPath.row])
        cell?.imageView?.layer.cornerRadius = cell!.frame.size.height / 2
        cell?.imageView?.clipsToBounds = true
        return cell!
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 85
    }

}

