//
//  HomeViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 19.08.2024.
//

import UIKit

var intrumentsArr = ["All", "Guitar", "Piano", "Electric guitar"]
var historyArr: [Hostory] = []

protocol HomeViewControllerDelegate: AnyObject {
    func reloadCollection()
}

class HomeViewController: UIViewController {
    
    var selectedCat = "All"
    var categoryCollection: UICollectionView?
    var tapsOnOneCategor = 0
    var noHostoryView = noHistoryView()
    
    var historyCollection: UICollectionView?
    var sortedHistoryArr = historyArr
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.title = ""
        hideNavigationBar()
    }

    override func viewDidLoad() {
        intrumentsArr = loadCategories()
        historyArr = loadHistoryArray() ?? []
        sortedHistoryArr = historyArr
        UserDefaults.standard.set("d", forKey: "tab")
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
    }
    
    func loadHistoryArray() -> [Hostory]? {
        if let savedHistoryData = UserDefaults.standard.object(forKey: "Hist") as? Data {
            let decoder = JSONDecoder()
            if let loadedHistoryArr = try? decoder.decode([Hostory].self, from: savedHistoryData) {
                return loadedHistoryArr
            }
        }
        return nil
    }
    
    
    @objc func openNotes() {
        self.navigationController?.pushViewController(NotesViewController(), animated: true)
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
        buttonSettings.addTarget(self, action: #selector(opnSettings), for: .touchUpInside)
        
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
        notesBitton.addTarget(self, action: #selector(openNotes), for: .touchUpInside)
        
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
        addNewInstButton.addTarget(self, action: #selector(editForButton), for: .touchUpInside)
        
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
        
        let hisView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 40/255, green: 18/255, blue: 27/255, alpha: 1)
            view.layer.cornerRadius = 20
            let label = UILabel()
            label.text = "History"
            label.textColor = .white
            label.font = .systemFont(ofSize: 22, weight: .bold)
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.centerY.equalToSuperview()
                make.left.equalToSuperview().inset(15)
            }
            return view
        }()
        view.addSubview(hisView)
        hisView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(52)
            make.top.equalTo(categoryCollection!.snp.bottom).inset(-5)
        }
        
        let addNewHisButton: UIButton = {
            let button = UIButton()
            button.setImage(.plus.resize(targetSize: CGSize(width: 20, height: 20)), for: .normal)
            return button
        }()
        hisView.addSubview(addNewHisButton)
        addNewHisButton.snp.makeConstraints { make in
            make.height.width.equalTo(24)
            make.centerY.equalToSuperview()
            make.right.equalToSuperview().inset(15)
        }
        
        
        
        addNewHisButton.addTarget(self, action: #selector(createNewHistory), for: .touchUpInside)
        
        historyCollection = {
            let layout = UICollectionViewFlowLayout()
            let collection = UICollectionView(frame: .zero, collectionViewLayout: layout)
            collection.backgroundColor = UIColor(red: 40/255, green: 18/255, blue: 27/255, alpha: 1)
            layout.scrollDirection = .vertical
            collection.layer.cornerRadius = 20
            layout.sectionInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
            collection.register(UICollectionViewCell.self, forCellWithReuseIdentifier: "2")
            collection.delegate = self
            collection.dataSource = self
            collection.showsVerticalScrollIndicator = false
            return collection
        }()
        view.addSubview(historyCollection!)
        historyCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(hisView.snp.bottom).inset(-5)
            make.bottom.equalToSuperview()
        })
        
        
        view.addSubview(noHostoryView)
        noHostoryView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(hisView.snp.bottom).inset(-5)
            make.height.equalTo(188)
        }
        
        
        checkHistArray()
    }
    
   
    @objc func opnSettings() {
        let vc = SettingsViewController()
        self.present(vc, animated: true)
    }
    
    
    @objc func createNewHistory() {
        openNewHistoryPage(isNew: true, index: nil)
    }
    
    func openNewHistoryPage(isNew: Bool, index: Int?) {
        let vc = NewHistoryViewController()
        vc.delegate = self
        vc.isNew = isNew
        if isNew == false {
            vc.index = index ?? 0
            vc.history = historyArr[index ?? 0]
        }
        self.present(vc, animated: true)
    }
    
    func checkHistArray() { //поменять провекру на уже отсортированный массив а не на весь
        sortArray()
        
        if sortedHistoryArr.count > 0 {
            noHostoryView.alpha = 0
            historyCollection?.alpha = 1
        } else {
            noHostoryView.alpha = 1
            historyCollection?.alpha = 0
        }
    }
    
    func loadCategories() -> [String] {
        if let a = UserDefaults.standard.array(forKey: "categories") as? [String]  {
            return a
        } else {
            return ["All", "Guitar", "Piano", "Electric guitar"]
        }
    }
    
    @objc func hideKBandOther() {
        view.endEditing(true)
    }
   
    @objc func editForButton() {
        openSettingsCategor(isEdit: false)
    }
    
    @objc func openSettingsCategor(isEdit: Bool) {
        
        let alertController = UIAlertController(title: "Add a instrument", message: nil, preferredStyle: .alert)
        alertController.addTextField()
        
        
        if isEdit == true {
            alertController.textFields?.first?.text = selectedCat
        }
       
        
        
        if isEdit == false {
            let cancelAction = UIAlertAction(title: "Close", style: .default) { action in
                self.dismiss(animated: true)
            }
            alertController.addAction(cancelAction)
        } else {
            let deletelAction = UIAlertAction(title: "Delete", style: .default) { action in
                var indexDel = 0
                for i in intrumentsArr {
                    if i == self.selectedCat {
                        intrumentsArr.remove(at: indexDel)
                        self.selectedCat = intrumentsArr.first ?? "All"
                        self.categoryCollection?.reloadData()
                        self.checkHistArray()
                        self.dismiss(animated: true)
                    }
                    indexDel += 1
                }
            }
            alertController.addAction(deletelAction)
        }
        
        let saveAction = UIAlertAction(title: "Save", style: .default) { action in
            if isEdit == false {
                intrumentsArr.append(alertController.textFields?.first?.text ?? "Category")
                self.selectedCat = alertController.textFields?.first?.text ?? "Category"
                self.categoryCollection?.reloadData()
                self.checkHistArray()
                self.dismiss(animated: true)
            } else {
                var indexred = 0
                for i in intrumentsArr {
                    if i == self.selectedCat {
                        intrumentsArr[indexred] = alertController.textFields?.first?.text ?? "Category"
                        self.selectedCat = alertController.textFields?.first?.text ?? "Category"
                        self.categoryCollection?.reloadData()
                        self.checkHistArray()
                        self.dismiss(animated: true)
                    }
                    indexred += 1
                }
            }
        }
        alertController.addAction(saveAction)
        UserDefaults.standard.setValue(intrumentsArr, forKey: "categories")
        UserDefaults.standard.synchronize()
        
        
        self.present(alertController, animated: true)
    }
    
    func sortArray() {
        sortedHistoryArr = []
        for i in historyArr {
            if i.intrument == selectedCat {
                sortedHistoryArr.append(i)
            }
        }
        if selectedCat == "All" {
            sortedHistoryArr = historyArr
        }
        historyCollection?.reloadData()
    }

}


extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if collectionView == categoryCollection {
            return intrumentsArr.count
        } else {
            return sortedHistoryArr.count //пменять на сортированный массив
        }
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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "2", for: indexPath)
            cell.subviews.forEach { $0.removeFromSuperview() }
            cell.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
            cell.layer.cornerRadius = 12
            
            let item = sortedHistoryArr[indexPath.row]
            
            let categoryButt = UIButton()
            categoryButt.isEnabled = false
            categoryButt.setTitle(item.intrument, for: .normal)
            categoryButt.contentEdgeInsets = UIEdgeInsets(top: 5, left: 10, bottom: 5, right: 10)
            categoryButt.setTitleColor(.white, for: .normal)
            categoryButt.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
            categoryButt.layer.cornerRadius = 10
            categoryButt.titleLabel?.font = .systemFont(ofSize: 11, weight: .semibold)
            cell.addSubview(categoryButt)
            categoryButt.snp.makeConstraints { make in
                if item.intrument != "Category" {
                    make.top.right.equalToSuperview().inset(15)
                    make.height.equalTo(21)
                    make.width.equalTo(calculateDynamicWidth(for: item.intrument))
                } else {
                    make.width.equalTo(0)
                    make.height.equalTo(0)
                }
            }
            
            let nameLabel = UILabel()
            nameLabel.text = item.name
            nameLabel.numberOfLines = 2
            nameLabel.textAlignment = .left
            nameLabel.textColor = .white
            nameLabel.font = .systemFont(ofSize: 15, weight: .regular)
            cell.addSubview(nameLabel)
            nameLabel.snp.makeConstraints { make in
                make.top.left.equalToSuperview().inset(15)
                make.right.equalTo(categoryButt.snp.left).inset(-15)
            }
            
            let dateLabelText = UILabel()
            dateLabelText.text = "Date"
            dateLabelText.font = .systemFont(ofSize: 13, weight: .regular)
            dateLabelText.textColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
            cell.addSubview(dateLabelText)
            dateLabelText.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.top.equalTo(cell.snp.centerY)
            }
            
            let timeLabelText = UILabel()
            timeLabelText.text = "Time"
            timeLabelText.font = .systemFont(ofSize: 13, weight: .regular)
            timeLabelText.textColor = UIColor(red: 216/255, green: 216/255, blue: 216/255, alpha: 1)
            cell.addSubview(timeLabelText)
            timeLabelText.snp.makeConstraints { make in
                make.left.equalTo(cell.snp.centerX)
                make.top.equalTo(cell.snp.centerY)
            }
            
            let dateLabel = UILabel()
            dateLabel.text = item.date
            dateLabel.font = .systemFont(ofSize: 15, weight: .semibold)
            dateLabel.textColor = .white
            cell.addSubview(dateLabel)
            dateLabel.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(15)
                make.bottom.equalToSuperview().inset(22)
                make.right.equalTo(cell.snp.centerX).inset(-10)
            }
            
            let timelabel = UILabel()
            timelabel.text = item.time
            timelabel.font = .systemFont(ofSize: 15, weight: .semibold)
            timelabel.textColor = .white
            cell.addSubview(timelabel)
            timelabel.snp.makeConstraints { make in
                make.left.equalTo(timeLabelText.snp.left)
                make.bottom.equalToSuperview().inset(22)
                make.right.equalToSuperview().inset(15)
            }
            
            return cell
        }
       
    }
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == categoryCollection {
            if selectedCat == intrumentsArr[indexPath.row], selectedCat != "All" {
                openSettingsCategor(isEdit: true)
            } else {
                selectedCat = intrumentsArr[indexPath.row]
                categoryCollection?.reloadData()
                
                
                sortArray()
            }
            checkHistArray()
        } else {
            
            var index = 0
            let hist = sortedHistoryArr[indexPath.row]
            
            for i in historyArr {
                if hist.date == i.date, hist.intrument == i.intrument, i.name == hist.name, hist.time == i.time {
                    openNewHistoryPage(isNew: false, index: index)
                    return
                } else {
                    index += 1
                }
            }
    
        }
        
    }
   
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if  collectionView == categoryCollection {
            let text = intrumentsArr[indexPath.item]
            let width = calculateDynamicWidth(for: text)
            return CGSize(width: width, height: 34)
        } else {
            return CGSize(width: collectionView.frame.width - 30, height: 134)
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


extension HomeViewController: HomeViewControllerDelegate {
    func reloadCollection() {
        checkHistArray()
        historyCollection?.reloadData()
    }
    
    
}
