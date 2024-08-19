//
//  HomeViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 19.08.2024.
//

import UIKit

var intrumentsArr = ["All", "Guitar", "Piano", "Electric guitar"]

class HomeViewController: UIViewController {
    
    var selectedCat = "All"
    var categoryCollection: UICollectionView?
    var tapsOnOneCategor = 0
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        hideNavigationBar()
    }

    override func viewDidLoad() {
        UserDefaults.standard.set("d", forKey: "tab")
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
    }
    

    func createInterface() {
        
        
        let oneImageView = UIImageView(image: .homeImageOne)
        oneImageView.contentMode = .scaleAspectFit
        oneImageView.layer.cornerRadius = 24
        oneImageView.clipsToBounds = true
        view.addSubview(oneImageView)
        oneImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
            make.height.equalTo(176)
            make.width.equalTo(163)
        }
        let oneLabel = UILabel()
        oneLabel.font = .systemFont(ofSize: 22, weight: .bold)
        oneLabel.textColor = .white
        oneLabel.numberOfLines = 4
        oneLabel.text = " Improve\n and\n create\n with us"
        oneImageView.addSubview(oneLabel)
        oneLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-25)
            make.centerY.equalToSuperview()
        }
        
        let buttonSettings: UIButton = {
            let button = UIButton(type: .system)
            button.setBackgroundImage(.homeImageThree, for: .normal)
            button.setImage(.settings.resize(targetSize: CGSize(width: 24, height: 24)), for: .normal)
            button.tintColor = .white
            button.layer.cornerRadius = 20
            button.clipsToBounds = true
            return button
        }()
        view.addSubview(buttonSettings)
        buttonSettings.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.width.equalTo(64)
            make.left.equalTo(oneImageView.snp.right).inset(-5)
            make.top.equalTo(view.safeAreaLayoutGuide.snp.top)
        }
        
        let notesBitton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
            button.setTitle("Notes", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 20
            return button
        }()
        view.addSubview(notesBitton)
        notesBitton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.centerY.equalTo(buttonSettings)
            make.left.equalTo(buttonSettings.snp.right).inset(-5)
            make.right.equalToSuperview().inset(15)
        }
        
        let twoImageView = UIImageView(image: .homeImageTwo)
        twoImageView.contentMode = .scaleAspectFit
        twoImageView.isUserInteractionEnabled = true
        twoImageView.layer.cornerRadius = 20
        twoImageView.clipsToBounds = true
        view.addSubview(twoImageView)
        twoImageView.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.left.equalTo(oneImageView.snp.right).inset(-5)
            make.top.equalTo(notesBitton.snp.bottom).inset(-5)
            make.bottom.equalTo(oneImageView.snp.bottom)
        }
        
        let labelOnTwoImageLabel: UILabel = {
            let label = UILabel()
            label.text = "Add a new\ninstrument"
            label.font = .systemFont(ofSize: 17, weight: .semibold)
            label.textColor = .white
            label.numberOfLines = 2
            return label
        }()
        twoImageView.addSubview(labelOnTwoImageLabel)
        labelOnTwoImageLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.left.equalToSuperview().inset(20)
        }
        
        
        let addNewInstButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
            button.layer.cornerRadius = 25
            button.setImage(.plus.resize(targetSize: CGSize(width: 24, height: 24)), for: .normal)
            button.tintColor = .white
            return button
        }()
        twoImageView.addSubview(addNewInstButton)
        addNewInstButton.snp.makeConstraints { make in
            make.height.width.equalTo(50)
            make.right.equalToSuperview().inset(20)
            make.centerY.equalToSuperview()
        }
        addNewInstButton.addTarget(self, action: #selector(openSettingsCategor), for: .touchUpInside)
        
        categoryCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = UIColor(red: 17/255, green: 17/255, blue: 17/255, alpha: 1)
            layout.scrollDirection = .horizontal
            collection.layer.cornerRadius = 20
            layout.estimatedItemSize = UICollectionViewFlowLayout.automaticSize
            layout.sectionInset = UIEdgeInsets(top: 0, left: 15, bottom: 0, right: 15)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(categoryCollection!)
        categoryCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(58)
            make.top.equalTo(twoImageView.snp.bottom).inset(-5)
        })
    }
   
    
    @objc func openSettingsCategor(isEdit: Bool) {
        //доделать редактирование и добавление категорий
    }

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return intrumentsArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if  collectionView == categoryCollection {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
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
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "12423432423", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollection {
            selectedCat = intrumentsArr[indexPath.row]
            categoryCollection?.reloadData()
            if selectedCat == intrumentsArr[indexPath.row] {
                tapsOnOneCategor += 1
            }
        }
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  collectionView == categoryCollection {
            let text = intrumentsArr[indexPath.item]
            let width = calculateDynamicWidth(for: text)
            return CGSize(width: width, height: 34)
        } else {
            return CGSize(width: 111111, height: 111111)
        }
    }
    
    private func calculateDynamicWidth(for text: String) -> CGFloat {
        
        let font = UIFont.systemFont(ofSize: 13)
        let size = CGSize(width: CGFloat.greatestFiniteMagnitude, height: 34)
        let attributes = [NSAttributedString.Key.font: font]
        let boundingRect = text.boundingRect(with: size, options: .usesLineFragmentOrigin, attributes: attributes, context: nil)
        return boundingRect.width + 30
    }
    
    
}
