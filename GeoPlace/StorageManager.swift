//
//  StorageManager.swift
//  GeoPlace
//
//  Created by wtildestar on 06/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import RealmSwift

let realm = try! Realm()

// Имплементируем класс для сохранения объектов типа Place
class StorageManager {
    static func saveObject(_ place: Place) {
        try! realm.write {
            realm.add(place)
        }
    }
}
