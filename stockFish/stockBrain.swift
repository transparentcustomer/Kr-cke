//
//  stockBrain.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation

let yahooSymbolPLIST = Bundle.main.path(forResource: "symbolData", ofType: "plist")!

struct stockBrain
{
    
    var stockPuller = yahooPuller()
    
    private var yahooSymbol:    String?
    
    var yahooStockDataArray =   [[String:String]]()
    
    //MARK: - filling of model with symbols
    mutating func fillStockArray(_ stockCode: String) -> [[String:String]]
    {
        
        yahooStockDataArray.insert(
            [
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
            
            if let path = Bundle.main.path(forResource: "yahooSymbols", ofType: "csv")
            {
                //.. STORE CONTENT OF FILE IN VARIABLE:
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                
                yahooSymbols = data.components(separatedBy: "\r") //.. removal of return commands from String
                
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
        
        
        
        for (index,var item) in yahooStockDataArray.enumerated()
        {
            print("shitshitshit\(item)")
            //FIXME: 🔥 .. beware of cycling //.. in the case of no stock belonging to a symbol
            let symbol          = item["code"]!
            var stockName       :String?
            var stockLastPrice  :String?
            
            
           
            
            
            //MARK: get the name
            if item["name"] == "no info"
            {
                
                print("shitshitshit\(item)")
                
                stockName       =  stockPuller.getStockName(yahoosymbol: symbol)
                stockLastPrice  =  stockPuller.getLastPrice(yahoosymbol: symbol)
                
                yahooStockDataArray[index].updateValue(stockName!,      forKey: "name")
                yahooStockDataArray[index].updateValue(stockLastPrice!, forKey: "lastprice")
                
                print("\(yahooStockDataArray.count-index-1) operations remain")
            }
            
        }
        return yahooStockDataArray
    }
    mutating func searchCSVforBrokenSymbols()
    {
        print("test searchCSVforBrokenSymbols")
        
        var emptySymbolCount = 0
        var brokenSymbList = [String]()
        var repairedSymbList = [String]()
        
        for (index,var item) in yahooStockDataArray.enumerated()
        {
            
            
            let symbol          = item["code"]!
            var stockName       :String?
            
            
            
            
            //MARK: get the name
            if item["name"] == "no info"
            {
                
                stockName       =  stockPuller.getStockName(yahoosymbol: symbol)
                
                yahooStockDataArray[index].updateValue(stockName!,      forKey: "name")
                
                
                if stockName == ""
                {
                    print("the symbol \(symbol) is empty - its on position \(index+1)")
                    emptySymbolCount = emptySymbolCount+1
                    brokenSymbList.insert(symbol, at: 0)
                    
                    
                }else {
                    repairedSymbList.insert(symbol, at: 0)
                }
                print("\(yahooStockDataArray.count-index) of \(yahooStockDataArray.count) remain")
            }
            
        }
        print("\(String(describing: emptySymbolCount)) symbols are 💩")
        print("brokenSymbList: \(brokenSymbList)")
        brokenSymbList = brokenSymbList.reversed()
        
        repairedSymbList = repairedSymbList.reversed()
        for item in brokenSymbList
        {
         print(item)
        }
        print("")
        print("repairedSymbList: xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx")
        for item in repairedSymbList
        {
            print(item)
        }
    }
}
