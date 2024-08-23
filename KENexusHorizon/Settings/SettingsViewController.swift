//
//  SettingsViewController.swift
//  KENexusHorizon
//
//  Created by Владимир Кацап on 23.08.2024.
//

import UIKit
import StoreKit
import WebKit

class SettingsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor(red: 25/255, green: 4/255, blue: 14/255, alpha: 1)
        createInterface()
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
            make.height.equalTo(5)
            make.width.equalTo(36)
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(5)
        }
        
        let settingsLabel = UILabel()
        settingsLabel.text = "Settings"
        settingsLabel.textColor = .white
        settingsLabel.font = .systemFont(ofSize: 34, weight: .bold)
        view.addSubview(settingsLabel)
        settingsLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().inset(15)
        }
        
        
        let shareButton = createButton(title: "Share app")
        view.addSubview(shareButton)
        shareButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(79)
            make.top.equalTo(settingsLabel.snp.bottom).inset(-20)
        }
        shareButton.addTarget(self, action: #selector(shareApps), for: .touchUpInside)
        
        let rateButton = createButton(title: "Rate Us")
        view.addSubview(rateButton)
        rateButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(79)
            make.top.equalTo(shareButton.snp.bottom).inset(-15)
        }
        rateButton.addTarget(self, action: #selector(rateApps), for: .touchUpInside)
        
        let policyButton = createButton(title: "Usage Policy")
        view.addSubview(policyButton)
        policyButton.snp.makeConstraints { make in
            make.left.right.equalToSuperview().inset(15)
            make.height.equalTo(79)
            make.top.equalTo(rateButton.snp.bottom).inset(-15)
        }
        policyButton.addTarget(self, action: #selector(policy), for: .touchUpInside)
    }
    
    
    func createButton(title: String) -> UIButton {
        let button = UIButton(type: .system)
        button.backgroundColor = UIColor(red: 40/255, green: 18/255, blue: 27/255, alpha: 1)
        button.layer.cornerRadius = 12
        button.setTitle(title, for: .normal)
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
        button.setTitleColor(.white, for: .normal)
        return button
    }
    
    @objc func rateApps() {
        if #available(iOS 10.3, *) {
            SKStoreReviewController.requestReview()
        } else {
            if let url = URL(string: "id") {
                if UIApplication.shared.canOpenURL(url) {
                    UIApplication.shared.open(url, options: [:], completionHandler: nil)
                }
            }
        }
    }
    
    @objc func shareApps() {
        let appURL = URL(string: "id")!
        let activityViewController = UIActivityViewController(activityItems: [appURL], applicationActivities: nil)
        
        // Настройка для показа в виде popover на iPad
        if let popoverController = activityViewController.popoverPresentationController {
            popoverController.sourceView = self.view
            popoverController.sourceRect = CGRect(x: self.view.bounds.midX, y: self.view.bounds.midY, width: 0, height: 0)
            popoverController.permittedArrowDirections = []
        }

        self.present(activityViewController, animated: true, completion: nil)
    }
    
    @objc func policy() {
        let webVC = WebViewController()
        webVC.urlString = "pol"
        present(webVC, animated: true, completion: nil)
    }

}



class WebViewController: UIViewController, WKNavigationDelegate {
    var webView: WKWebView!
    var urlString: String?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        webView.navigationDelegate = self
        view = webView
        
        // Загружаем URL
        if let urlString = urlString, let url = URL(string: urlString) {
            webView.load(URLRequest(url: url))
        }
    }
}
