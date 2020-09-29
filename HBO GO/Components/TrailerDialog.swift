//
//  TrailerDialog.swift
//  HBO GO
//
//  Created by Riki on 7/20/20.
//  Copyright © 2020 SanMyaNwe. All rights reserved.
//

import UIKit
import WebKit

class TrailerDialog: UIView {
    
    private var player: WKWebView!
    
    private lazy var lbTitle: UILabel = {
        let label = UILabel()
        label.textColor = .primaryColor
        label.font = UIFont(name: "Kefa", size: 20)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    } ()
    
    private lazy var btnClose: UIButton = {
        let button = UIButton()
        button.setTitle("Close", for: .normal)
        button.setTitleColor(.primaryColor, for: .normal)
        button.titleLabel?.font = UIFont(name: "Kefa", size: 18)
        button.addTarget(self, action: #selector(onClose), for: .touchUpInside)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    } ()
    
    private lazy var blurEffectView: UIVisualEffectView = {
           let blurEffect = UIBlurEffect(style: .dark)
           let blurEffectView = UIVisualEffectView(effect: blurEffect)
           blurEffectView.alpha = 0.75
           blurEffectView.frame = UIScreen.main.bounds
           blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
           return blurEffectView
    } ()
    
    init(for title: String, id: String) {
        let screenSize: CGSize = UIScreen.main.bounds.size
        
        let width: CGFloat = screenSize.width * 0.95
        let height: CGFloat = width * ( 3 / 4 )
        
        let xOffset: CGFloat = ( screenSize.width - width ) / 2
        let yOffset: CGFloat = ( screenSize.height - height ) / 2
            
        let initFrame = CGRect(x: xOffset, y: yOffset, width: width, height: height)
        
        super.init(frame: initFrame)
        sharedInit(key: id, title: title)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    private func sharedInit(key: String, title: String) {
        setUpViews()
        
        lbTitle.text = title
        let videoLink = "https://www.youtube.com/embed/\(key)"
        if let videoUrl: URL = URL(string: videoLink){
            let request: URLRequest = URLRequest(url: videoUrl)
            player.load(request)
        }
        
    }
    
    private func setUpViews() {
        player = WKWebView()
        player.frame = CGRect(x: 0, y: 50, width: self.bounds.size.width, height: self.bounds.height - 50)
        player.clipsToBounds = true
        player.layer.maskedCorners = [.layerMinXMaxYCorner, .layerMaxXMaxYCorner]
        player.layer.cornerRadius = 12
        
        self.backgroundColor = .secondaryColor
        self.layer.cornerRadius = 12
        
        self.addSubview(player)
        self.addSubview(lbTitle)
        self.addSubview(btnClose)
        
        NSLayoutConstraint.activate([
            btnClose.topAnchor.constraint(equalTo: self.topAnchor, constant: 8),
            btnClose.widthAnchor.constraint(equalToConstant: 80),
            btnClose.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16),
            
            lbTitle.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16),
            lbTitle.trailingAnchor.constraint(equalTo: btnClose.leadingAnchor, constant: 8),
            lbTitle.centerYAnchor.constraint(equalTo: btnClose.centerYAnchor)
        ])
        
    }
    
    func play() {
        let window = UIApplication.shared.windows.filter { $0.isKeyWindow }.first!
        window.addSubview(blurEffectView)
        window.addSubview(self)
    }
    
    @objc fileprivate func onClose() {
        blurEffectView.removeFromSuperview()
        self.removeFromSuperview()
    }
    
}
