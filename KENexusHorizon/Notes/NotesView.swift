//
//  NotesView.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 21.08.2024.
//

import UIKit

class NotesView: UIView {
    
    var controller: NotesViewController?
    
    var categoryCollection: UICollectionView?
    var selectedCat = "All"
    var selectedLevel = "Archive"
    var sortedHistoryArr = historyArr
    
    var midView: UIView?
    var itemsSegmented = ["Archive", "Repetition", "Learned"]
    var segmentedControl: UISegmentedControl?
    
    var noHistView = noHistoryView()

    override init(frame: CGRect) {
        super .init(frame: frame)
        backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
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
    
    var mainCollection: UICollectionView?
    
    func createInterface() {
        
        let topView: UIView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 40/255, green: 18/255, blue: 27/255, alpha: 1)
            view.layer.cornerRadius = 24
            let label = UILabel()
            label.text = "Improve and\ncreate with us"
            label.numberOfLines = 2
            label.font = .systemFont(ofSize: 22, weight: .bold)
            label.textColor = .white
            view.addSubview(label)
            label.snp.makeConstraints { make in
                make.left.equalToSuperview().inset(30)
                make.centerY.equalToSuperview()
            }
            let imageViewCorneredRock = UIImageView(image: .corneredRock)
            imageViewCorneredRock.contentMode = .scaleAspectFit
            view.addSubview(imageViewCorneredRock)
            imageViewCorneredRock.snp.makeConstraints { make in
                make.right.equalToSuperview()
                make.centerY.equalToSuperview()
                make.height.width.equalTo(140)
            }
            return view
        }()
        addSubview(topView)
        topView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(safeAreaLayoutGuide.snp.top)
            make.height.equalTo(120)
        }
        
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
        addSubview(categoryCollection!)
        categoryCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(topView.snp.bottom).inset(-5)
            make.height.equalTo(58)
        })
        
        
        addSubview(hisView)
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
        addNewHisButton.addTarget(self, action: #selector(createNew), for: .touchUpInside)
        
        midView = {
            let view = UIView()
            view.backgroundColor = UIColor(red: 40/255, green: 18/255, blue: 27/255, alpha: 1)
            view.layer.cornerRadius = 20
            return view
        }()
        addSubview(midView!)
        midView?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalTo(hisView.snp.bottom).inset(-5)
            make.height.equalTo(228)
        })
        
        segmentedControl = UISegmentedControl(items: itemsSegmented)
        let normalTextAttributes: [NSAttributedString.Key: Any] = [
            .foregroundColor: UIColor.white]
        segmentedControl?.setTitleTextAttributes(normalTextAttributes, for: .normal)
        segmentedControl?.selectedSegmentTintColor = UIColor(red: 99/255, green: 99/255, blue: 102/255, alpha: 1)
        segmentedControl?.selectedSegmentIndex = 0
        segmentedControl?.addTarget(self, action: #selector(selectSegmented), for: .valueChanged)
        midView?.addSubview(segmentedControl!)
        segmentedControl?.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.top.equalToSuperview().inset(15)
            make.height.equalTo(24)
        }
        
        midView?.addSubview(noHistView)
        noHistView.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(3)
            make.bottom.equalToSuperview().inset(3)
            make.top.equalTo(segmentedControl!.snp.bottom).inset(-3)
        }
        
        mainCollection = {
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
        midView?.addSubview(mainCollection!)
        mainCollection?.snp.makeConstraints({ make in
            make.left.right.equalToSuperview().inset(3)
            make.bottom.equalToSuperview().inset(3)
            make.top.equalTo(segmentedControl!.snp.bottom).inset(-3)
        })
        
        
        checkArr()
    }
    
    @objc func createNew() {
        controller?.createNewNote()
    }
    
    func checkArr() {
        if notesArr.count > 0 {
            noHistView.alpha = 0
            mainCollection?.alpha = 1
            midView?.snp.remakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(hisView.snp.bottom).inset(-5)
                make.bottom.equalToSuperview()
            })
            mainCollection?.reloadData()
        } else {
            noHistView.alpha = 1
            mainCollection?.alpha = 0
            midView?.snp.remakeConstraints({ make in
                make.left.right.equalToSuperview().inset(15)
                make.top.equalTo(hisView.snp.bottom).inset(-5)
                make.height.equalTo(228)
            })
        }
    }
    
    @objc func selectSegmented() {
        selectedLevel = itemsSegmented[segmentedControl?.selectedSegmentIndex ?? 0]
        print(selectedLevel)
    }
    
}


extension NotesView: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
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
            selectedCat = intrumentsArr[indexPath.row]
            categoryCollection?.reloadData()
            
            
            //sortArray()
            
        } // else {
//
//            var index = 0
//            let hist = sortedHistoryArr[indexPath.row]
//            
//            for i in historyArr {
//                if hist.date == i.date, hist.intrument == i.intrument, i.name == hist.name, hist.time == i.time {
//                    openNewHistoryPage(isNew: false, index: index)
//                    return
//                } else {
//                    index += 1
//                }
//            }
//    
//        }
        
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
