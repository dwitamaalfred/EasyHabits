//
//  EmptyStateHelper.swift
//  EasyHabits
//
//  Created by Dwitama Alfred on 21/01/22.
//

import Foundation
import UIKit
import Lottie


extension UITableView {
    
    func setEmptyMessage(_ message: String) {
//        let emptyStateView = UIView()
        var emptyStateView: AnimationView?
        emptyStateView = .init(name:"eazyHabitsEmptyState")
        emptyStateView!.contentMode = .scaleAspectFit
        emptyStateView?.animationSpeed = 1.5
        emptyStateView!.loopMode = .loop
        emptyStateView!.play()
        
        
        
//        let messageLabel = UILabel()
//        messageLabel.text = message
//        messageLabel.textColor = .gray
//        messageLabel.numberOfLines = 0
//        messageLabel.textAlignment = .center
//        messageLabel.sizeToFit()
//
//        let imageView = UIImageView()
//        imageView.image = UIImage(named: "emptyStateImage")
//
//        emptyStateView.addSubview(messageLabel)
//        emptyStateView.addSubview(imageView)
//
//        imageView.translatesAutoresizingMaskIntoConstraints = false
//        imageView.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor).isActive = true
//        imageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
//        imageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
//        imageView.topAnchor.constraint(equalTo: emptyStateView.topAnchor, constant: self.bounds.size.height / 4).isActive = true
//
//        messageLabel.translatesAutoresizingMaskIntoConstraints = false
//        messageLabel.centerXAnchor.constraint(equalTo: emptyStateView.centerXAnchor).isActive = true
//        messageLabel.widthAnchor.constraint(equalToConstant: self.bounds.size.width/2).isActive = true
//        messageLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
//        messageLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 30).isActive = true
//
    
        self.backgroundView = emptyStateView
//        self.separatorStyle = .none
        
        
    }

    func restore() {
        self.backgroundView = nil
    }
}

extension UIColor {
    static var habitBlue:UIColor {
        return UIColor(red: 0.369, green: 0.545, blue: 0.855, alpha: 1)
    }
}
