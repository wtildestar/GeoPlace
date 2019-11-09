//
//  MapViewController.swift
//  GeoPlace
//
//  Created by wtildestar on 09/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit
import MapKit

class MapViewController: UIViewController {
    
    var place: Place!
    
    

    @IBOutlet weak var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupPlacemark()
        
    }

    @IBAction func closeVC() {
        dismiss(animated: true)
    }
    
    // Маркер указывающий местоположение на карте
    private func setupPlacemark() {
        guard let location = place.location else { return }
        
        // CLGeocoder будет преобразовывать адрес в геолографические координаты
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(location) { (placemarks, error) in
            if let error = error {
                print(error)
                return
            }
            
            guard let placemarks = placemarks else { return }
            
            let placemark = placemarks.first
            
            // MKPointAnnotation используется чтобы описать какую-то точку на карте
            let annotation = MKPointAnnotation()
            annotation.title = self.place.name
            annotation.subtitle = self.place.type
            
            // Определяем геопозицию маркера
            guard let placemarkLocation = placemark?.location else { return }
            // Привязываем аннотацию к этой же точке на карте
            annotation.coordinate = placemarkLocation.coordinate
            
            self.mapView.showAnnotations([annotation], animated: true)
            self.mapView.selectAnnotation(annotation, animated: true)
        }
    }
}
