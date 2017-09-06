//
//  stockBrain.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation



struct stockBrain{
    
    var stockPuller = yahooPuller()
    
    private var yahooSymbol:    String?
    var stockSymbolArray    =   [String]()
    var yahooStockDataArray =   [[String:String]]()
    
    var stockTableViewData = [[String:String]]()
    
    //FIXME: ..toDelete:
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
    
    
    //MARK: - filling of model with symbols
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
    func getUpdates()
    { //.. to get stock names and price values
        print("yahooStockDataArray: \(yahooStockDataArray)")
        
        
        
        for (index,var item) in yahooStockDataArray.enumerated()
        {
            //FIXME: ..toDelete
            //print("the index is: \(index) and the content: \(item["code"]!)")
            
            //FIXME:  .. beware of cycling //.. in the case of no stock belonging to a symbol
            
            let symbol = item["code"]!
            
            //MARK: get the name
            if item["name"] == "no info" {
                
                let diagnose =  stockPuller.getStockName(yahoosymbol: symbol)
                
                print("\(String(describing: item["code"]!)) has no name yet")
            }
            
            
            
            
            
            
            //FIXME: ..toDelete
            //print("Diagnose: \(diagnose)")
            
        }
        
    }
    
    
    
}
