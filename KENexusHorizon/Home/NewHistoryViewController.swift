//
//  NewHistoryViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 20.08.2024.
//

import UIKit



class NewHistoryViewController: UIViewController {
    
    weak var delegate: HomeViewControllerDelegate?
    var mainView = AddNewHistoryView()
    
    //редактирование
    var isNew = false
    var index = 0
    var history: Hostory?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view = mainView
        mainView.controller = self
        checkIsNew()
    }
    
    func checkIsNew() {
        if isNew == true {
            mainView.delButton.alpha = 0
            mainView.delButton.isEnabled = false
            mainView.saveButton.alpha = 0.5
            mainView.saveButton.isEnabled = false
        } else {
            
            mainView.nameTextField?.text = history?.name
            mainView.selectedCat = history?.intrument ?? "Category"
            mainView.dateTextField?.text = history?.date
            mainView.timeTextField?.text = history?.time
            
            mainView.delButton.alpha = 1
            mainView.delButton.isEnabled = true
            mainView.saveButton.alpha = 1
            mainView.saveButton.isEnabled = true
        }
    }
    
    func saveHistory(name: String, date: String, time: String, category: String) {
        let history = Hostory(name: name, intrument: category, date: date, time: time)
        
        if isNew == true {
            historyArr.append(history)
        } else {
            historyArr[index] = history
        }
        saveArray()
    }
    
    
    func delete() {
        historyArr.remove(at: index)
        saveArray()
    }
    
    
    func saveArray() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(historyArr) {
            UserDefaults.standard.set(encoded, forKey: "Hist")
        }
        delegate?.reloadCollection()
        delegate = nil
        self.dismiss(animated: true)
    }
    

   

}
