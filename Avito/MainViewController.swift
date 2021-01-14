//
//  MainViewController.swift
//  Avito
//
//  Created by Nikita Entin on 11.01.2021.
//

import UIKit

class MainViewController: UIViewController {
    
    //массив со свойстами из модели
    var items = [InfoModel]()
    
    // массив индексов выбранных ячеек
    var selectedCellIndex = [IndexPath]()
    
    //MARK:- объявление элементов интерфейса
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var xMarkImage: UIImageView! {
        didSet {
            xMarkImage.image = UIImage(named: "xmark")
        }
    }
    @IBOutlet weak var buttonLabel: UIButton! {
        didSet {
            buttonLabel.layer.cornerRadius = 5
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.layer.cornerRadius = 5
            collectionView.dataSource = self
            collectionView.delegate = self
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //парсинг данных из файла avitoData.json
        loadJson(fileName: "avitoData")
        
        mainTitle.text = items[0].result.title
        
    }
    //MARK:- парсинг данных типа json
    func loadJson(fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let info = try decoder.decode(InfoModel.self, from: data)
                // наполнение массива элементами после парсинга
                items = [info]
            } catch let error {
                print(error)
            }
        }
    }
    
    //MARK:- алерт при нажатии на кнопку
    @IBAction func chooseOption(_ sender: Any) {
        
        if items[0].result.list[0].isSelected == true {
            showAlert(title: items[0].result.list[0].title, message: nil)
        }
        if items[0].result.list[1].isSelected == true  {
            showAlert(title: items[0].result.list[1].title, message: nil)
        }
        
        //вызов по дефолту
        showAlert(title: "Выберите товар", message: nil)
    }
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "element", for: indexPath) as? MainCollectionViewCell  {
            
            // настройка элементов в CollectionViewCell
            cell.layer.cornerRadius = 5
            cell.backgroundColor = .systemGray6
            cell.priceLabel.text = items[0].result.list[indexPath.item].price
            cell.titleLabel.text = items[0].result.list[indexPath.item].title
            cell.descLabel.text = items[0].result.list[indexPath.item].description
            
            // галочка появляется и исчезает при выборе ячейки
            if selectedCellIndex.contains(indexPath) {
                cell.checkmark.isHidden = false
                items[0].result.list[indexPath.item].isSelected = true
            } else {
                cell.checkmark.isHidden = true
                items[0].result.list[indexPath.item].isSelected = false
            }
            cell.checkmark.image = UIImage(named: "checkmark")
            let data = try? Data(contentsOf: items[0].result.list[indexPath.item].icon.iconSize)
            if let imageData = data {
                cell.imageView.image = UIImage(data: imageData)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        // условие появления/непоявления галочки
        if selectedCellIndex.contains(indexPath) {
            if let index = selectedCellIndex.firstIndex(of: indexPath) {
                selectedCellIndex.remove(at: index)
            }
        } else if selectedCellIndex.count < 1 {
            selectedCellIndex.append(indexPath)
        }
        collectionView.reloadData()
    }
    
    //MARK:- создание алерта
    func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}
