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
    var stockSymbolArray = [String]()
    var yahooStockDataArray = [[String:String]]()
    
    var stockTableViewData = [[String:String]]()
    
    //FIXME: ..toDelete
    /*
         mutating func getStockValues (_ stockCode: String?){
             yahooSymbol = stockCode
     
             if stockCode != "" {
                 stockSymbolArray.insert( (yahooSymbol ?? "no symb found"), at: 0) //.. nil-coalescing operator
                 print("shit")
     
             }else{print("no symbol inserted")}
     
     
             print("stockSymbolArray: \(stockSymbolArray)")
         }
     */
    
    mutating func fillStockArray(_ stockCode: String) -> [[String:String]] {
        print("test")
        yahooStockDataArray.insert([
            
            "code"      : stockCode,
            "name"      : "no info",
            "lastprice" : "no info"
            
            ], at: 0)
        
        return yahooStockDataArray
    }
    
    
    //MARK: - get Yahoo Info:
    func getUpdates(){
        print("yahooStockDataArray: \(yahooStockDataArray)")
    }
}
