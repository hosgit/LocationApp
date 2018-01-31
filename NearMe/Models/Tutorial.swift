//
//  Tutorial.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import Foundation
import UIKit
class Tutorial
{
    var image:UIImage?
    
    init(imageName:String)
    {
        let image  = UIImage(named: imageName)
        self.image = image
    }
}
