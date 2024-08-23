//
//  NewNoteViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 21.08.2024.
//

import UIKit

class NewNoteViewController: UIViewController, UIImagePickerControllerDelegate ,UINavigationControllerDelegate {
    
    weak var delegate: NotesViewControllerDelegate?
    weak var secondDelegate: DetailNoteViewControllerDelegate?
    var isNew = true
    
    var index = 0
    var note: Note?
    
    var saveButton: UIButton?
    var jobSelectedLabel: UILabel?
    var levelSelectedLabel: UILabel?
    var mainCollection: UICollectionView?

    
    var nameTextField: UITextField?
    var selectedJob = "Average"
    var selectedLevel = "Beginner"
    var instrument = "All"
    var images: [Data] = []

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
        checkISNew()
        checkSaveButton()
        
    }
    
    func checkISNew() {
        if isNew == false {
            nameTextField?.text = notesArr[index].name
            selectedJob = notesArr[index].job
            selectedLevel = notesArr[index].level
            instrument = notesArr[index].instrument
            images = notesArr[index].imagies
            
            jobSelectedLabel?.text = selectedJob
            levelSelectedLabel?.text = selectedLevel
            mainCollection?.reloadData()
        }
    }
    
    
    func createInterface() {
        
        let hideView: UIView = {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.3)
            view.layer.cornerRadius = 2.5
            return view
        }()
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(5)
            make.width.equalTo(36)
        }
        
        saveButton = {
            let button = UIButton(type: .system)
            button.setTitle("Save", for: .normal)
            button.setTitleColor(.white, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            return button
        }()
        view.addSubview(saveButton!)
        saveButton?.snp.makeConstraints({ make in
            make.top.right.equalToSuperview().inset(15)
        })
        saveButton?.addTarget(self, action: #selector(saveItem), for: .touchUpInside)
        
        
        let nameLabel = createLabels(text: "Name")
        view.addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(saveButton!.snp.bottom).inset(-15)
        }
        
        nameTextField = createTextField()
        view.addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(53)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
        })
        
        let jobStatusLabel = createLabels(text: "Job status")
        view.addSubview(jobStatusLabel)
        jobStatusLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-20)
        }
        
        let levelLabel = createLabels(text: "Difficulty level")
        view.addSubview(levelLabel)
        levelLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-20)
        }
        
        
        let jobButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 42/255, alpha: 1)
            button.layer.cornerRadius = 12
            
            let imageView = UIImageView(image: .arrowDown)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(16)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(15)
            }
            
            return button
        }()
        view.addSubview(jobButton)
        jobButton.snp.makeConstraints { make in
            make.height.equalTo(53)
            make.left.equalToSuperview().inset(15)
            make.right.equalTo(view.snp.centerX).offset(-15)
            make.top.equalTo(jobStatusLabel.snp.bottom).inset(-10)
        }
        jobButton.addTarget(self, action: #selector(openMenuJobStatus(sender:) ), for: .touchUpInside)
        
        jobSelectedLabel = UILabel()
        jobSelectedLabel?.text = selectedJob
        jobSelectedLabel?.textColor = .white
        jobButton.addSubview(jobSelectedLabel!)
        jobSelectedLabel?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        })
        
        let levelButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 42/255, alpha: 1)
            button.layer.cornerRadius = 12
            
            let imageView = UIImageView(image: .arrowDown)
            imageView.contentMode = .scaleAspectFit
            button.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalTo(16)
                make.centerY.equalToSuperview()
                make.right.equalToSuperview().inset(15)
            }
            
            return button
        }()
        view.addSubview(levelButton)
        levelButton.snp.makeConstraints { make in
            make.height.equalTo(53)
            make.left.equalTo(levelLabel.snp.left)
            make.right.equalToSuperview().inset(15)
            make.top.equalTo(jobStatusLabel.snp.bottom).inset(-10)
        }
        levelButton.addTarget(self, action: #selector(openMenuLevel(sender:)), for: .touchUpInside)
        
        levelSelectedLabel = UILabel()
        levelSelectedLabel?.text = selectedLevel
        levelSelectedLabel?.textColor = .white
        levelButton.addSubview(levelSelectedLabel!)
        levelSelectedLabel?.snp.makeConstraints({ make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(15)
        })
        
        mainCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            layout.scrollDirection = .vertical
            collection.showsVerticalScrollIndicator = false
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(jobButton.snp.bottom).inset(-15)
        })
        
        if isNew == false {
            let delButton = UIButton()
            delButton.setTitle("Delete", for: .normal)
            delButton.setTitleColor(.white, for: .normal)
            delButton.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            delButton.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
            delButton.layer.cornerRadius = 20
            view.addSubview(delButton)
            delButton.snp.makeConstraints { make in
                make.left.right.equalToSuperview().inset(15)
                make.height.equalTo(50)
                make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom)
            }
            delButton.addTarget(self, action: #selector(delItem), for: .touchUpInside)
        }
        
    }
    
    @objc func saveItem() {
        
        let name: String = nameTextField?.text ?? "Name"
        
        let note = Note(instrument: instrument, name: name, job: selectedJob, level: selectedLevel, imagies: images)
        
        if isNew == true {
            notesArr.append(note)
        } else {
            notesArr[index] = note
        }
        
       
         do {
             let data = try JSONEncoder().encode(notesArr)
             try saveAthleteArrToFile(data: data)
            
             
             delegate?.reloadTable()
             secondDelegate?.reload()
             self.dismiss(animated: true)
         } catch {
             print("Failed to encode or save athleteArr: \(error)")
         }
        
    }
    
    @objc func delItem() {
        notesArr.remove(at: index)
        do {
            let data = try JSONEncoder().encode(notesArr)
            try saveAthleteArrToFile(data: data)
           
            
           // delegate?.reloadTable()
            self.dismiss(animated: true)
            secondDelegate?.del()
        } catch {
            print("Failed to encode or save athleteArr: \(error)")
        }
    }
    
    func saveAthleteArrToFile(data: Data) throws {
        let fileManager = FileManager.default
        if let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first {
            let filePath = documentDirectory.appendingPathComponent("notes.plist")
            try data.write(to: filePath)
        } else {
            throw NSError(domain: "SaveError", code: 1, userInfo: [NSLocalizedDescriptionKey: "Unable to get document directory"])
        }
    }
    
   
    
    
    @objc func openMenuJobStatus(sender: UIButton) {
        var arrAction: [UIAction] = []
        let arrItems = ["Archive", "Repetition", "Learned"]
        
        for i in arrItems {
            let action = UIAction(title: i) { _ in
                self.selectedJob = i
                self.jobSelectedLabel?.text = self.selectedJob
            }
            arrAction.append(action)
        }
        checkSaveButton()
        let menu = UIMenu(title: "", children: arrAction)

        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
    @objc func openMenuLevel(sender: UIButton) {
        var arrAction: [UIAction] = []
        let arrItems = ["Beginner", "Intermediate", "Advanced"]
        checkSaveButton()
        for i in arrItems {
            let action = UIAction(title: i) { _ in
                self.selectedLevel = i
                self.levelSelectedLabel?.text = self.selectedLevel
            }
            arrAction.append(action)
        }

        let menu = UIMenu(title: "", children: arrAction)

        if #available(iOS 14.0, *) {
            sender.menu = menu
            sender.showsMenuAsPrimaryAction = true
        }
    }
    
    
    func checkSaveButton() {
        if nameTextField?.text?.count ?? 0 > 0, images.count > 0, selectedJob != "Average" {
            saveButton?.alpha = 1
            saveButton?.isEnabled = true
        } else {
            saveButton?.alpha = 0.5
            saveButton?.isEnabled = false
        }
    }
    
    func createLabels(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.font = .systemFont(ofSize: 17, weight: .semibold)
        label.textColor = .white
        return label
    }
    
    func createTextField() -> UITextField {
        let textField = UITextField()
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(red: 41/244, green: 41/255, blue: 42/255, alpha: 1)
        textField.textColor = .white
        textField.layer.cornerRadius = 12
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.delegate = self
        return textField
    }
    
    @objc func setImage() {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.sourceType = .photoLibrary
        imagePickerController.allowsEditing = false
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        if let pickedImage = info[.originalImage] as? UIImage {
            images.append(pickedImage.jpegData(compressionQuality: 1) ?? Data())
            updateCollection()
            checkSaveButton()
        }
    }
    
    func updateCollection() {
        mainCollection?.reloadData()
        checkSaveButton()
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
        checkSaveButton()
    }
    
    @objc func delCell(sender: UIButton) {
        
        images.remove(at: sender.tag)
        checkSaveButton()
        updateCollection()
    }
    
   
}


extension NewNoteViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        checkSaveButton()
        view.endEditing(true)
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkSaveButton()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSaveButton()
        return true
    }
}


extension NewNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 1 + images.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = .white
        cell.layer.cornerRadius = 8
        cell.clipsToBounds = true
        
        if indexPath.row == 0 {
            let imageView = UIImageView(image: .addImageCell)
            imageView.contentMode = .scaleAspectFit
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.center.equalToSuperview()
                make.height.equalTo(60)
                make.width.equalTo(75)
            }
        } else {
            let imageView = UIImageView(image: UIImage(data: images[indexPath.row - 1])?.resize(targetSize: CGSize(width: cell.bounds.width, height: cell.bounds.height)))
            imageView.contentMode = .scaleAspectFill
            cell.addSubview(imageView)
            imageView.snp.makeConstraints { make in
                make.height.width.equalToSuperview()
            }
            
            let delButt = UIButton()
            delButt.setImage(UIImage.delButt, for: .normal)
            delButt.tag = indexPath.row - 1
            cell.addSubview(delButt)
            delButt.snp.makeConstraints { make in
                make.height.width.equalTo(24)
                make.top.right.equalToSuperview().inset(6)
            }
            delButt.addTarget(self, action: #selector(delCell), for: .touchUpInside)
        }
        
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            checkSaveButton()
            setImage()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 112, height: 158)
    }
    
    
}
