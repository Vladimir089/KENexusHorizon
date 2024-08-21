//
//  NewNoteViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 21.08.2024.
//

import UIKit

class NewNoteViewController: UIViewController {
    
    weak var delegate: NotesViewControllerDelegate?
    var isNew = true
    
    var index = 0
    var note: Note?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
