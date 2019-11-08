//
//  PhotoExtension.swift
//  VirtualTourist
//
//  Created by Lola M on 7/25/19.
//  Copyright © 2019 Udacity. All rights reserved.
//

import Foundation
import UIKit

extension Photos {
    func set(image: UIImage) {
        self.imageData = image.pngData()
    }
    
    func getImage() -> UIImage? {
        return imageData == nil ? nil: UIImage(data: imageData!)
    }
    
    public override func awakeFromInsert() {
        super.awakeFromInsert()
        creationDate = Date()
    }
}

