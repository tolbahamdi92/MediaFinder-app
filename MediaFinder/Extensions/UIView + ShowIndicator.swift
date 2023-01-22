//
//  UIView + ShowIndicator.swift
//  MediaFinder
//
//  Created by Tolba on 23/06/1444 AH.
//

import UIKit
extension UIView {
    func showLoader(indicator: inout UIActivityIndicatorView) {
        indicator = UIActivityIndicatorView.init(frame: CGRect(x: (self.frame.width / 2) - 30, y: (self.frame.height / 2) - 30, width: 60, height: 60))
        indicator.style = .large
        indicator.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0) .withAlphaComponent(0.7)
        indicator.startAnimating()
        self.addSubview(indicator)
    }
    
    func hideLoader(indicator: UIActivityIndicatorView) {
        DispatchQueue.main.async {
            indicator.stopAnimating()
            indicator.hidesWhenStopped = true
        }
    }
}
