//
//  Beer.swift
//  Brewery Tour
//
//  Created by Alexander Pojman on 12/14/16.
//  Copyright © 2016 Alexander Pojman. All rights reserved.
//

import Foundation

class Beer {
    var name: String
    var description: String
    var ABV: Float
    var style: Style
    
    init(name: String, description: String, ABV: Float, style: Style) {
        self.name = name
        self.description = description
        self.ABV = ABV
        self.style = style
    }
}
extension Beer {
    enum Style: String {
        case cider,bock,amber,lager
        
    }
}
