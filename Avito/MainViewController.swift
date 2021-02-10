//
//  MainViewController.swift
//  Avito
//
//  Created by Nikita Entin on 11.01.2021.
//

import UIKit

class MainViewController: UIViewController {
    
   private var items = [InfoModel]()
   private var selectedCellIndex = [IndexPath]()
   
    @IBOutlet weak var mainTitle: UILabel!
    @IBOutlet weak var xMarkImage: UIImageView!
    @IBOutlet weak var buttonLabel: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        xMarkImage.image = UIImage(named: "xmark")
        buttonLabel.layer.cornerRadius = 5
        collectionView.layer.cornerRadius = 5
        collectionView.dataSource = self
        collectionView.delegate = self
        
        loadJson(fileName: "avitoData")
        
        mainTitle.text = items[0].result.title
        
    }
    //MARK:- парсинг данных типа json
    private func loadJson(fileName: String) {
        if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
            do {
                let data = try Data(contentsOf: url)
                let decoder = JSONDecoder()
                let info = try decoder.decode(InfoModel.self, from: data)
                items = [info]
            } catch let error {
                print(error)
            }
        }
    }
    
    @IBAction func chooseOption(_ sender: Any) {
        
        if items[0].result.list[0].isSelected == true {
            showAlert(title: items[0].result.list[0].title, message: nil)
        }
        if items[0].result.list[1].isSelected == true  {
            showAlert(title: items[0].result.list[1].title, message: nil)
        }
        
        showAlert(title: "Выберите товар", message: nil)
    }
}


extension MainViewController: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        var listOfItems = items[0].result.list[indexPath.item]
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "element", for: indexPath) as? MainCollectionViewCell  {
            
            cell.layer.cornerRadius = 5
            cell.backgroundColor = .systemGray6
            cell.priceLabel.text = listOfItems.price
            cell.titleLabel.text = listOfItems.title
            cell.descLabel.text = listOfItems.description
            
            if selectedCellIndex.contains(indexPath) {
                cell.checkmark.isHidden = false
                listOfItems.isSelected = true
            } else {
                cell.checkmark.isHidden = true
                listOfItems.isSelected = false
            }
            cell.checkmark.image = UIImage(named: "checkmark")
            let data = try? Data(contentsOf: listOfItems.icon.iconSize)
            if let imageData = data {
                cell.imageView.image = UIImage(data: imageData)
            }
            return cell
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
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
   private func showAlert(title: String?, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(action)
        present(alert, animated: true, completion: nil)
        
    }
}
