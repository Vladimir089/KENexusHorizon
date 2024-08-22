//
//  DetailNoteViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 22.08.2024.
//

import UIKit

class DetailNoteViewController: UIViewController {
    
    var index = 0
    weak var delegate: NotesViewControllerDelegate?
    
    
    var nameLabel: UILabel?
    var jobStatusLabel: UILabel?
    var levelLabel: UILabel?
    var collection: UICollectionView?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
    }
    
    func createInterface() {
        
        
        let hideView = UIView()
        hideView.backgroundColor = .white.withAlphaComponent(0.3)
        hideView.layer.cornerRadius = 2.5
        view.addSubview(hideView)
        hideView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
            make.height.equalTo(5)
            make.width.equalTo(36)
        }
        
        let editButton = UIButton(type: .system)
        editButton.setTitle("Edit", for: .normal)
        editButton.setTitleColor(.white, for: .normal)
        editButton.titleLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        view.addSubview(editButton)
        editButton.snp.makeConstraints { make in
            make.right.top.equalToSuperview().inset(15)
        }
        
        let buttonIntrument: UIButton = {
            let button = UIButton()
            button.isUserInteractionEnabled  = false
            button.setTitle(notesArr[index].instrument, for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
            button.setTitleColor(.white, for: .normal)
            button.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
            button.layer.cornerRadius = 10
            button.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            return button
        }()
        view.addSubview(buttonIntrument)
        buttonIntrument.snp.makeConstraints { make in
            make.height.equalTo(21)
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(editButton.snp.bottom).inset(-15)
        }
        
        nameLabel = UILabel()
        nameLabel?.text = notesArr[index].name
        nameLabel?.font = .systemFont(ofSize: 34, weight: .semibold)
        nameLabel?.numberOfLines = 2
        nameLabel?.textAlignment = .left
        nameLabel?.textColor = .white
        view.addSubview(nameLabel!)
        nameLabel?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(buttonIntrument.snp.bottom).inset(-15)
        })
        
        
        let jobStatLabel = UILabel()
        jobStatLabel.text = "Job status"
        jobStatLabel.font = .systemFont(ofSize: 13, weight: .regular)
        jobStatLabel.textColor = UIColor(red: 216/255, green: 216/255, blue: 217/255, alpha: 1)
        view.addSubview(jobStatLabel)
        jobStatLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(nameLabel!.snp.bottom).inset(-15)
        }
        
        jobStatusLabel = UILabel()
        jobStatusLabel?.text = notesArr[index].job
        jobStatusLabel?.font = .systemFont(ofSize: 15, weight: .semibold)
        jobStatusLabel?.textColor = .white
        view.addSubview(jobStatusLabel!)
        jobStatusLabel?.snp.makeConstraints({ make in
            make.left.equalToSuperview().inset(15)
            make.top.equalTo(jobStatLabel.snp.bottom).inset(-5)
        })
        
        let levelTextLabel = UILabel()
        levelTextLabel.text = "Difficulty level"
        levelTextLabel.font = .systemFont(ofSize: 13, weight: .regular)
        levelTextLabel.textColor = UIColor(red: 216/255, green: 216/255, blue: 217/255, alpha: 1)
        view.addSubview(levelTextLabel)
        levelTextLabel.snp.makeConstraints { make in
            make.left.equalTo(view.snp.centerX).offset(10)
            make.top.equalTo(nameLabel!.snp.bottom).inset(-15)
        }
        
        
        levelLabel = UILabel()
        levelLabel?.text = notesArr[index].level
        levelLabel?.font = .systemFont(ofSize: 16, weight: .semibold)
        levelLabel?.textColor = UIColor(red: 255/255, green: 0/255, blue: 104/255, alpha: 1)
        view.addSubview(levelLabel!)
        levelLabel?.snp.makeConstraints({ make in
            make.left.equalTo(levelTextLabel.snp.left)
            make.top.equalTo(levelTextLabel.snp.bottom).inset(-5)
        })
        
        collection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.showsVerticalScrollIndicator = false
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "1")
            collection.backgroundColor = .clear
            layout.scrollDirection = .vertical
            collection.delegate = self
            collection.dataSource = self
            return collection
        }()
        view.addSubview(collection!)
        collection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview()
            make.top.equalTo(levelLabel!.snp.bottom).inset(-15)
        })
        
    }

}


extension DetailNoteViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return notesArr[index].imagies.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "1", for: indexPath)
        cell.subviews.forEach { $0.removeFromSuperview() }
        cell.layer.cornerRadius = 8
        cell.backgroundColor = .white
        cell.clipsToBounds = true
        
        let imageView = UIImageView(image: UIImage(data: notesArr[index].imagies[indexPath.row]))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        cell.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.width.equalToSuperview()
            make.center.equalToSuperview()
        }
        
        
        return cell
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: 112, height: 158)
    }
    
}
