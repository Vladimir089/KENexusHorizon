//
//  LoadViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 19.08.2024.
//

import UIKit
import SnapKit

class LoadViewController: UIViewController {
    
    var timer: Timer?
    var stat = 0
    
    var progLabel: UILabel?

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 255/255, green: 0/255, blue: 104/255, alpha: 1)
        createInerface()
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(actionTImer), userInfo: nil, repeats: true) //поменять на 0.07
    }
    
    @objc func actionTImer() {
        stat += 1
        progLabel?.text = "\(stat)%"
        if stat == 100 {
            timer?.invalidate()
            timer = nil
            nextPage()
        }
    }
    
    func nextPage() {
        if isBet == false {
            if UserDefaults.standard.object(forKey: "tab") != nil {
                self.navigationController?.setViewControllers([HomeViewController()], animated: true)
            } else {
               self.navigationController?.setViewControllers([OnbUserViewController()], animated: true)
            }
        } else {
            
        }
    }
    

    func createInerface() {
        let imageView = UIImageView(image: .log)
        imageView.contentMode = .scaleAspectFit
        view.addSubview(imageView)
        imageView.snp.makeConstraints { make in
            make.height.equalTo(107)
            make.width.equalTo(216)
            make.center.equalToSuperview()
        }
        
        let loadIndicator = UIActivityIndicatorView()
        view.addSubview(loadIndicator)
        loadIndicator.color = .white
        loadIndicator.startAnimating()
        loadIndicator.snp.makeConstraints { make in
            make.height.width.equalTo(22)
            make.top.equalTo(imageView.snp.bottom).inset(-200)
            make.centerX.equalToSuperview().offset(-22)
        }
        
        progLabel = UILabel()
        progLabel?.text = "0%"
        progLabel?.textColor = .white
        progLabel?.font = .systemFont(ofSize: 17, weight: .regular)
        view.addSubview(progLabel!)
        progLabel?.snp.makeConstraints({ make in
            make.left.equalTo(loadIndicator.snp.right).inset(-5)
            make.centerY.equalTo(loadIndicator)
        })
    }

}



extension UIViewController {
    func hideNavigationBar() {
        self.navigationController?.setNavigationBarHidden(true, animated: true)
    }
    
    func showNavigationBar() {
        self.navigationController?.setNavigationBarHidden(false, animated: true)
    }
}


extension UIImage {
    func resize(targetSize: CGSize) -> UIImage {
        let size = self.size
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio,  height: size.height * widthRatio)
        }
        UIGraphicsBeginImageContextWithOptions(newSize, false, UIScreen.main.scale)
        self.draw(in: CGRect(origin: .zero, size: newSize))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
}
