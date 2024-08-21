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
        }
        
        self.present(vc, animated: true)
        
    }
    
   
}


extension NotesViewController: NotesViewControllerDelegate {
    func reloadTable() {
        mainView?.checkArr()
    }
    
    
}
