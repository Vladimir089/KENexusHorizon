//
//  OnbUserViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 19.08.2024.
//

import UIKit

class OnbUserViewController: UIViewController {
    
    var tap = 0
    
    var imageView: UIImageView?
    var secondView = UIView()
    var label: UILabel?
    
    let arrViews: [UIImage] = [.page, .page]
    var oneImageView, twoImageView: UIImageView?

    override func viewDidLoad() {
        super.viewDidLoad()

        createInerface()
    }
    
    func createInerface() {
        imageView = UIImageView(image: .onbOne)
        imageView?.contentMode = .scaleAspectFit
        view.addSubview(imageView!)
        imageView?.snp.makeConstraints({ make in
            make.left.right.top.bottom.equalToSuperview()
        })
        
        
        secondView.layer.cornerRadius = 20
        secondView.backgroundColor = .white
        view.addSubview(secondView)
        secondView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
            make.height.equalTo(216)
        }
        
        label = UILabel()
        label?.text = "Edit the information at \n any time"
        label?.font = .systemFont(ofSize: 32, weight: .semibold)
        label?.textColor = .black
        label?.textAlignment = .center
        label?.numberOfLines = 2
        secondView.addSubview(label!)
        label?.snp.makeConstraints({ make in
            make.top.equalToSuperview().inset(15)
            make.left.right.equalToSuperview()
        })
        
        
        oneImageView = UIImageView()
        let redImage = arrViews[0].withRenderingMode(.alwaysTemplate)
        oneImageView?.image = redImage
        oneImageView?.tintColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
        
        oneImageView?.contentMode = .scaleAspectFit
        view.addSubview(oneImageView!)
        oneImageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(15)
            make.left.equalToSuperview().inset(100)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
        })
        
        
        twoImageView = UIImageView(image: arrViews[1])
        twoImageView?.contentMode = .scaleAspectFit
        view.addSubview(twoImageView!)
        twoImageView?.snp.makeConstraints({ make in
            make.height.width.equalTo(15)
            make.left.equalTo(oneImageView!.snp.right).inset(-5)
            make.bottom.equalTo(view.safeAreaLayoutGuide.snp.bottom).inset(40)
        })
        
        let nextButton: UIButton = {
            let button = UIButton(type: .system)
            button.backgroundColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
            button.setTitle("Next", for: .normal)
            button.titleLabel?.font = .systemFont(ofSize: 17, weight: .semibold)
            button.setTitleColor(.white, for: .normal)
            button.layer.cornerRadius = 20
            return button
        }()
        view.addSubview(nextButton)
        nextButton.snp.makeConstraints { make in
            make.height.equalTo(50)
            make.width.equalTo(159)
            make.centerY.equalTo(twoImageView!)
            make.right.equalToSuperview().inset(40)
        }
        
        nextButton.addTarget(self, action: #selector(nextPage), for: .touchUpInside)
        
    }
    
    @objc func nextPage() {
        tap += 1
        imageView?.image = UIImage.onbTwo
        
        let redImage = arrViews[0].withRenderingMode(.alwaysTemplate)
        twoImageView?.image = redImage
        twoImageView?.tintColor = UIColor(red: 180/255, green: 12/255, blue: 92/255, alpha: 1)
        oneImageView?.image = arrViews[0].withRenderingMode(.alwaysOriginal)
        label?.text = "All the notes in one place"
        
        UIView.animate(withDuration: 0.2) {
            self.secondView.snp.remakeConstraints { make in
                make.left.right.equalToSuperview()
                make.bottom.equalToSuperview()
                make.height.equalTo(178)
            }
            self.view.layoutIfNeeded()
        }
        if  tap == 2 {
            self.navigationController?.setViewControllers([HomeViewController()], animated: true)
        }
    }
    
    
   

}
