//
//  AddNewHistoryView.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 20.08.2024.
//

import UIKit

class AddNewHistoryView: UIView {
    
    var selectedCat = "Category"
    var nameTextField, dateTextField, timeTextField: UITextField?
    weak var controller: NewHistoryViewController?
    

    override init(frame: CGRect) {
     super .init(frame: frame)
        backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let saveButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Save", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    
    let delButton: UIButton = {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
        button.layer.cornerRadius = 20
        button.setTitle("Delete", for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
        button.setTitleColor(.white, for: .normal)
        return button
    }()

    
    
    func createInterface() {
        
        let hideView: UIView = {
            let view = UIView()
            view.backgroundColor = .white.withAlphaComponent(0.3)
            view.layer.cornerRadius = 2.5
            return view
        }()
        addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        
        addSubview(saveButton)
        saveButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(15)
        }
        
        
        let nameLabel = createLabels(text: "Name")
        addSubview(nameLabel)
        nameLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(saveButton.snp.bottom).inset(-15)
        }
        
        nameTextField = createTextField(placeholder: "Name")
        addSubview(nameTextField!)
        nameTextField?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel.snp.bottom).inset(-10)
            make.height.equalTo(53)
        })
        
        
        
        let collection: UICollectionView = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = .clear
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "3")
            collection.delegate = self
            collection.dataSource = self
            layout.scrollDirection = .horizontal
            collection.layer.cornerRadius = 16
            collection.showsHorizontalScrollIndicator = false
            collection.isUserInteractionEnabled = true
            return collection
        }()
        addSubview(collection)
        collection.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(nameTextField!.snp.bottom).inset(-15)
            make.height.equalTo(34)
        }
        
        let dateLabel = createLabels(text: "Date")
        addSubview(dateLabel)
        dateLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(collection.snp.bottom).inset(-15)
        }
        
        dateTextField = createTextField(placeholder: "Date")
        let datePicker = UIDatePicker()
        datePicker.datePickerMode = .date
        if #available(iOS 13.4, *) {
            datePicker.preferredDatePickerStyle = .wheels
        }
        datePicker.addTarget(self, action: #selector(dateChanged(_:)), for: .valueChanged)
        
        // Назначение пикера даты в качестве inputView для текстового поля
        dateTextField?.inputView = datePicker
        
        // Добавление toolbar с кнопкой "Готово"
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        toolbar.setItems([doneButton], animated: true)
        
        dateTextField?.inputAccessoryView = toolbar
        addSubview(dateTextField!)
        dateTextField?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.height.equalTo(53)
            make.right.equalTo(snp.centerX).offset(-15)
            make.top.equalTo(dateLabel.snp.bottom).inset(-10)
        })
        
        let timeLabel = createLabels(text: "Time")
        addSubview(timeLabel)
        timeLabel.snp.makeConstraints { make in
            make.left.equalTo(snp.centerX).offset(15)
            make.top.equalTo(collection.snp.bottom).inset(-15)
        }
        
        timeTextField = createTextField(placeholder: "Time")
        addSubview(timeTextField!)
        timeTextField?.snp.makeConstraints({ make in
            make.left.equalTo(timeLabel.snp.left)
            make.right.equalTo(snp.right).inset(15)
            make.top.equalTo(timeLabel.snp.bottom).inset(-10)
            make.height.equalTo(53)
        })
        
        addSubview(delButton)
        delButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(dateTextField!.snp.bottom).inset(-15)
            make.height.equalTo(50)
        }
        saveButton.addTarget(self, action: #selector(saveHist), for: .touchUpInside)
        delButton.addTarget(self, action: #selector(deleteHistory), for: .touchUpInside)
        
    }
    
    @objc func deleteHistory() {
        controller?.delete()
    }
    
    @objc func saveHist() {
        let name: String = nameTextField?.text ?? "Name"
        let date: String = dateTextField?.text ?? "Date"
        let time: String = timeTextField?.text ?? "Time"
        controller?.saveHistory(name: name, date: date, time: time, category: selectedCat)
    }
    
    func checkSaveButton() {
        if nameTextField?.text?.count ?? 0 > 0, dateTextField?.text?.count ?? 0 > 0, timeTextField?.text?.count ?? 0 > 0 {
            saveButton.alpha = 1
            saveButton.isEnabled = true
        } else {
            saveButton.alpha = 0.5
            saveButton.isEnabled = false
        }
    }
    
    
    
    
    @objc func dateChanged(_ datePicker: UIDatePicker) {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        dateFormatter.dateFormat = "MMMM, dd"
        dateTextField?.text = dateFormatter.string(from: datePicker.date)
        checkSaveButton()
    }
    
    @objc func donePressed() {
        dateTextField?.resignFirstResponder()
    }
    
    
    func createTextField(placeholder: String) -> UITextField {
        let textField = UITextField()
        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.leftViewMode = .always
        textField.rightView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 10))
        textField.rightViewMode = .always
        textField.placeholder = placeholder
        textField.borderStyle = .none
        textField.backgroundColor = UIColor(red: 41/255, green: 41/255, blue: 42/255, alpha: 1)
        textField.layer.borderColor = UIColor.black.cgColor
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 12
        textField.textColor = .white
        textField.delegate = self
        return textField
    }
    
    
    func createLabels(text: String) -> UILabel {
        let label = UILabel()
        label.text = text
        label.textColor = .white
        label.font = .systemFont(ofSize: 17, weight: .bold)
        return label
    }
    
    
}


extension AddNewHistoryView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intrumentsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "3", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.backgroundColor = UIColor(red: 106/255, green: 79/255, blue: 90/255, alpha: 1)
        let label = UILabel()
        label.text = intrumentsArr[indexPath.row]
        label.textColor = .white
        label.font = .systemFont(ofSize: 13, weight: .regular)
        cell.layer.cornerRadius = 16
        label.sizeToFit()
        
        
        if selectedCat == intrumentsArr[indexPath.row] {
            label.font = .systemFont(ofSize: 13, weight: .semibold)
            cell.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
        } else {
            label.font = .systemFont(ofSize: 13, weight: .regular)
            cell.backgroundColor = UIColor(red: 106/255, green: 79/255, blue: 90/255, alpha: 1)
        }
        
        
                
        cell.addSubview(label)
        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        selectedCat = intrumentsArr[indexPath.row]
        checkSaveButton()
        collectionView.reloadData()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = intrumentsArr[indexPath.item]
        let width = calculateDynamicWidth(for: text)
        return CGSize(width: width, height: 34)
    }
    
    private func calculateDynamicWidth(for text: String) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: 13)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 34)
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return boundingRect.width + 30
    }
    
    
}


extension AddNewHistoryView: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        endEditing(true)
        checkSaveButton()
        return true
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        checkSaveButton()
        return true
    }
    
    func textFieldDidChangeSelection(_ textField: UITextField) {
        checkSaveButton()
    }
    
}
