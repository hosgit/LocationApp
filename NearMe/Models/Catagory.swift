//
//  Catagory.swift
//  NearMe
//
//  Created by Hos on 16/12/17.
//  Copyright © 2017 Hos. All rights reserved.
//

import Foundation
enum LocationType
{
    case washroom
    case garbage
    case indraCanteen
}

class Catagory
{
    var type:LocationType = .washroom
    
    init(type:LocationType)
    {
        self.type = type
    }
}
