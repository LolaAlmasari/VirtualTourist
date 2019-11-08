//
//  Exxtension.swift
//  VirtualTourist
//
//  Created by Lola M on 7/25/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController {
    func alert(title: String, message: String?) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "okay", style: .default, handler: nil))
        DispatchQueue.main.async {
            self.present(alert, animated: true, completion: nil)
        }
    }
}

