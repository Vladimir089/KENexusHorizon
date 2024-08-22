//
//  NotesViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 21.08.2024.
//

import UIKit

var notesArr: [Note] = []

protocol NotesViewControllerDelegate: AnyObject {
    func reloadTable()
}

class NotesViewController: UIViewController {
    
    var mainView: NotesView?
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        showNavigationBar()
        self.title = "Notes"
        self.navigationController?.navigationBar.titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        self.navigationController?.navigationBar.tintColor = UIColor.white
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        mainView = NotesView()
        mainView?.controller = self
        self.view = mainView
        notesArr = loadAthleteArrFromFile() ?? []
        mainView?.checkArr()
    }
    
    func loadAthleteArrFromFile() -> [Note]? {
        let fileManager = FileManager.default
        guard let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else {
            print("Unable to get document directory")
            return nil
        }
        let filePath = documentDirectory.appendingPathComponent("notes.plist")
        do {
            let data = try Data(contentsOf: filePath)
            let athleteArr = try JSONDecoder().decode([Note].self, from: data)
            return athleteArr
        } catch {
            print("Failed to load or decode athleteArr: \(error)")
            return nil
        }
    }
    
    
    @objc func createNewNote() {
        openNewHistory(isNew: true, index: 0, item: nil)
    }
    
    func openNewHistory(isNew: Bool, index: Int, item: Note?) {
        let vc = NewNoteViewController()
        vc.delegate = self
        vc.isNew = isNew
        
        if isNew == true {
            vc.index = index
            vc.note = item
            vc.instrument = mainView?.selectedCat ?? "All"
        }
        
        self.present(vc, animated: true)
        
    }
    
    
    func openDetail(index: Int) {
        let vc = DetailNoteViewController()
        vc.delegate = self
        vc.index = index
        print(notesArr[index])
        self.present(vc, animated: true)
    }
   
}


extension NotesViewController: NotesViewControllerDelegate {
    func reloadTable() {
        mainView?.checkArr()
    }
    

    
    
}
