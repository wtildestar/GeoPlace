//
//  ViewController.swift
//  GeoPlace
//
//  Created by wtildestar on 03/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import RealmSwift

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let searchController = UISearchController(searchResultsController: nil)
    private var places: Results<Place>!
    private var filteredPlaces: Results<Place>! // отфильтрованные записи для поиска
    private var ascendingSorting = true
    private var searchBarIsEmpty: Bool {
        // если строка поиска будет пустой то вернется значение true
        guard let text = searchController.searchBar.text else { return false }
        return text.isEmpty
    }
    
    private var isFiltering: Bool {
        return searchController.isActive && !searchBarIsEmpty
    }
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segmentedControl: UISegmentedControl!
    @IBOutlet weak var reversedSortingButton: UIBarButtonItem!
    // Results - автообновляемый тип контейнера который возврашает запрашиваемые объекты
   
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Делаем запрос объектов из Realm
        places = realm.objects(Place.self) // self говорит что мы подставляем не сам объект данных модели  а именно тип Place
        
        // Делаем настройку search controller
        searchController.searchResultsUpdater = self // получателем информации об изменении текста в поисковой строке должен быть наш класс
        searchController.obscuresBackgroundDuringPresentation = false // позволит взаимодействовать с этим viewcontroller'om как с основным ( смотреть детали записей, исправлять / удалять )
        searchController.searchBar.placeholder = "Поиск"
        navigationItem.searchController = searchController
        definesPresentationContext = true // отпускаем строку поиска при переходе на другой экран
    }

    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if isFiltering {
            return filteredPlaces.count
        }
        return places.isEmpty ? 0 : places.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as! OwnTableViewCell

        var place = Place()
        
        if isFiltering {
            place = filteredPlaces[indexPath.row]
        } else {
            place = places[indexPath.row]
        }

        cell.nameLabel.text = place.name
        cell.locationLabel.text = place.location
        cell.typeLabel.text = place.type
        cell.imageOfPlace.image = UIImage(data: place.imageData!) // Извлекаем принудительно тк оно никогда не будет nil

        cell.imageOfPlace.layer.cornerRadius = cell.imageOfPlace.frame.size.height / 2
        cell.imageOfPlace.clipsToBounds = true

        return cell
        
    }
    
    // MARK: Table view delegate

    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let place = places[indexPath.row]
        let contextItem = UIContextualAction(style: .destructive, title: "Delete") { (_, _, _) in
            StorageManager.deleteObject(place)
            tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        let swipeActions = UISwipeActionsConfiguration(actions: [contextItem])
        
        return swipeActions
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showDetail" {
            // определеяем индекс выбранной ячейки
            guard let indexPath = tableView.indexPathForSelectedRow else { return }
            // извлекаем объект по этому же индексу
            let place: Place
            if isFiltering {
                place = filteredPlaces[indexPath.row]
            } else {
                place = places[indexPath.row]
            }
            // создаем экземпляр вью контроллера в который будем передавать этот объект
            let newPlaceVC = segue.destination as! NewPlaceViewController
            // передаем объект из выбранной ячейки на NewPlaceViewController
            newPlaceVC.currentPlace = place
        }
    }
    
     @IBAction func unwindSegue(_ segue: UIStoryboardSegue) {
        guard let newPlaceVC = segue.source as? NewPlaceViewController else { return }
        newPlaceVC.savePlace()
        tableView.reloadData()
    }
    @IBAction func sortSelection(_ sender: UISegmentedControl) {
        
        sorting()
        
    }
    
    @IBAction func reversedSorting(_ sender: Any) {
        ascendingSorting.toggle()
        
        if ascendingSorting {
            reversedSortingButton.image = #imageLiteral(resourceName: "sorting-down")
        } else {
            reversedSortingButton.image = #imageLiteral(resourceName: "sorting-up")
        }
        
        sorting()
    }
    
    private func sorting() {
        if segmentedControl.selectedSegmentIndex == 0 {
            places = places.sorted(byKeyPath: "date", ascending: ascendingSorting)
        } else {
            places = places.sorted(byKeyPath: "name", ascending: ascendingSorting)
        }
        
        tableView.reloadData()
    }
}

extension ViewController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        filterContentForSearchText(searchController.searchBar.text!)
    }
    
    private func filterContentForSearchText(_ searchText: String) {
        // заполняем коллекцию filteredPlaces отфильтрованными значениями places
        filteredPlaces = places.filter("name CONTAINS[c] %@ OR location CONTAINS[c] %@", searchText, searchText) // вместо %@ подставляем параметры указанные после условия фильтра , [c] - содержимое поля не зависит от регистра символов
        tableView.reloadData()
    }
    
}

