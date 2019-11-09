//
//  NewPlaceViewController.swift
//  GeoPlace
//
//  Created by wtildestar on 05/11/2019.
//  Copyright © 2019 wtildestar. All rights reserved.
//

import UIKit

class NewPlaceViewController: UITableViewController {
    
    var currentPlace: Place!
    var imageIsChanged = false
    
    @IBOutlet weak var placeImage: UIImageView!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var placeName: UITextField!
    @IBOutlet weak var placeLocation: UITextField!
    @IBOutlet weak var placeType: UITextField!
    @IBOutlet weak var ratingControl: RatingControl!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Скрываем остальные пустые ячейки футера tableView за счет UIView()
        tableView.tableFooterView = UIView(frame: CGRect(x: 0,
                                                         y: 0,
                                                         width: tableView.frame.size.width,
                                                         height: 1))
        saveButton.isEnabled = false
        // Проверяем поле placeName на редактирование изменяя кнопку "Сохранить" с enabled на disabled через расширение типа UITextFieldDelegate
        placeName.addTarget(self, action: #selector(textFieldChanged), for: .editingChanged)
        setupEditScreen()
    }
    
    
    // MARK: Table view delegate
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            
            let cameraIcon = #imageLiteral(resourceName: "icon-camera")
            let photoIcon = #imageLiteral(resourceName: "icon-photo")
            
            let actionSheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            let camera = UIAlertAction(title: "Camera", style: .default) { _ in
                self.chooseImagePicker(source: .camera)
            }
            
            // Устанавливаем иконку которую занесли в переменную через imageLiteral
            camera.setValue(cameraIcon, forKey: "image")
            camera.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            let photo = UIAlertAction(title: "Photo", style: .default) { _ in
                self.chooseImagePicker(source: .photoLibrary)
            }
            // Устанавливаем иконку которую занесли в переменную через imageLiteral
            photo.setValue(photoIcon, forKey: "image")
            photo.setValue(CATextLayerAlignmentMode.left, forKey: "titleTextAlignment")
            
            let cancel = UIAlertAction(title: "Cancel", style: .cancel)
            
            actionSheet.addAction(camera)
            actionSheet.addAction(photo)
            actionSheet.addAction(cancel)
            
            present(actionSheet, animated: true)
        } else {
            view.endEditing(true)
        }
    }
}


// MARK: Text field delegate

extension NewPlaceViewController: UITextFieldDelegate {
    // Скрываем клавиатуру по нажатию на Done
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    @objc private func textFieldChanged() {
        if placeName.text?.isEmpty == false {
            saveButton.isEnabled = true
        } else {
            saveButton.isEnabled = false
        }
    }
    
    // MARK: Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier != "showMap" {
            return
        }
        
        // Создали экземпляр MapViewController
        let mapVC = segue.destination as! MapViewController
        // Передаем currentPlace в mapViewContoller
        mapVC.place = currentPlace
    }
    
    func savePlace() {
        
        var image: UIImage?
        // Пишем условие на ImagePlaceholder если пользователь (не)установил изображение
        if imageIsChanged {
            image = placeImage.image
        } else { // Иначе ставим ImagePlaceholder
            image = #imageLiteral(resourceName: "image-placeholder")
        }
        
        let imageData = image?.pngData()
        
        let newPlace = Place(name: placeName.text!,
                             location: placeLocation.text,
                             type: placeType.text,
                             imageData: imageData,
                             rating: Double(ratingControl.rating))
        if currentPlace != nil {
            try! realm.write {
                currentPlace?.name = newPlace.name
                currentPlace?.location = newPlace.location
                currentPlace?.type = newPlace.type
                currentPlace?.imageData = newPlace.imageData
                currentPlace?.rating = newPlace.rating
            }
        } else {
            StorageManager.saveObject(newPlace)
        }
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true)
    }
    
    // Экран редактирования записи
    private func setupEditScreen() {
        if currentPlace != nil {
            
            setupNavigationBar()
            imageIsChanged = true
            
            // приводим значение data к типу image чтобы присвоить в аутлет placeImage
            guard let data = currentPlace?.imageData, let image = UIImage(data: data) else { return }
            
            // заполняем аутлеты
            placeImage.image = image
            placeImage.contentMode = .scaleAspectFill
            placeName.text = currentPlace?.name
            placeLocation.text = currentPlace?.location
            placeType.text = currentPlace?.type
            ratingControl.rating = Int(currentPlace.rating)
        }
    }
    
    private func setupNavigationBar() {
        if let topItem = navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        navigationItem.leftBarButtonItem = nil
        title = currentPlace?.name
        saveButton.isEnabled = true
    }
    
}



// MARK: Work with image
extension NewPlaceViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func chooseImagePicker(source: UIImagePickerController.SourceType) {
        if UIImagePickerController.isSourceTypeAvailable(source) {
            let imagePicker = UIImagePickerController()
            // Этот объект будет делегировать обязанности по выполнению данного метода
            imagePicker.delegate = self
            imagePicker.allowsEditing = true
            imagePicker.sourceType = source
            present(imagePicker, animated: true)
        }
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        // Обращаемся к ключу .editedImage который находится в .InfoKey нашего пикерконтроллера позволяя использовать отредактированное пользователем изображение
        placeImage.image = info[.editedImage] as? UIImage
        // Позволяет масштабировать изображение по содержимому UIImage
        placeImage.contentMode = .scaleAspectFill
        //  Обрезка по границе
        placeImage.clipsToBounds = true
        // Закрываем imagePickerController
        
        imageIsChanged = true
        
        dismiss(animated: true)
        
    }
}
