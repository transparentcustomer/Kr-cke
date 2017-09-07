//
//  stockBrain.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation

let yahooSymbolPLIST = Bundle.main.path(forResource: "symbolData", ofType: "plist")!

struct stockBrain{
    
    var stockPuller = yahooPuller()
    
    private var yahooSymbol:    String?
    
    var yahooStockDataArray =   [[String:String]]()
    
    //    var stockTableViewData = [[String:String]]()
    
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
    
    
    
    func useCSV()-> Array<String>
    {
        //FIXME: CLEANUP the MESS
        var yahooSymbols : [String] = []
        do {
            // This solution assumes  you've got the file in your bundle
            if let path = Bundle.main.path(forResource: "yahooSymbols", ofType: "csv"){
                // STORE CONTENT OF FILE IN VARIABLE
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                
                //                var readData =  [String]()
                yahooSymbols = data.components(separatedBy: "\r")
                
                
                //                let kommastring = symbolString.replacingOccurrences(of: "\r", with: "💩")
                
                print("yahooSymbols: \(yahooSymbols[3])")
                
                
            }
        } catch let err as NSError {
            // do something with Error}
            print(err)
            print("there is an error in processing the CSV file")
        }
        
        
        return yahooSymbols
    }
    
    
    //MARK: - get Yahoo Info:
    mutating func getUpdates() -> ([[String : String]])
    { //.. to get stock names and price values
        //FIXME: ..toDelete
        //print("yahooStockDataArray: \(yahooStockDataArray)")
        
        
        
        for (index,var item) in yahooStockDataArray.enumerated()
        {
            
            //FIXME:  .. beware of cycling //.. in the case of no stock belonging to a symbol
            let symbol          = item["code"]!
            var stockName       :String?
            var stockLastPrice  :String?
            
            //MARK: get the name
            if item["name"] == "no info" {
                
                stockName       =  stockPuller.getStockName(yahoosymbol: symbol)
                stockLastPrice  =  stockPuller.getLastPrice(yahoosymbol: symbol)
                //FIXME: ..toDelete
                //print("\(String(describing: item["code"]!)) has no name yet")
                
                yahooStockDataArray[index].updateValue(stockName!,      forKey: "name")
                yahooStockDataArray[index].updateValue(stockLastPrice!, forKey: "lastprice")
                
            }
            
            
            
            
            
            
            //FIXME: ..toDelete
            //print("Diagnose: \(diagnose)")
            
        }
        print("yahooStockDataArray: \(yahooStockDataArray)")
        return yahooStockDataArray
    }
    
    
    
}
