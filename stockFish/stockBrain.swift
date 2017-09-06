//
//  stockBrain.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation

struct stockBrain{
    
    private var yahooSymbol: String?
    
    var stockTableViewData = [[String:String]]()
    
    mutating func getStockValues (_ yahoosymbol: String){
        yahooSymbol = yahoosymbol
    }
    
    //MARK: - get Yahoo Info:
    
}
