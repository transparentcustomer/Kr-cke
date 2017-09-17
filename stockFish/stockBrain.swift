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
    var structure = stockStruct()
    
    var win: Double = 0
    
    private var yahooSymbol:    String?
    var moneySpendForStock:Double = 0
    
    var yahooStockDataArray =   [[String:String]]()
    
    //MARK: - filling of model with symbols
    mutating func fillStockArray(_ stockCode: String,_ stockNumber: String ) -> [[String:String]]
    {
        
        var insertedArrayInfo = [String:String]()
        
        yahooStockDataArray.insert(
            [
                "code"      : stockCode,
                "name"      : "no info",
                "lastprice" : "no info",
                
                //"pricepaid" : "133.85",
                "pricepaid" : "134.85",
                "number"    : stockNumber,
                "win"       : "0",
                "change"    : "no info"
                
                
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
    
    var automaticUpdate = false
    mutating func getUpdates() -> ([[String : String]])
    { //.. to get stock names and price values
        
        
        
        for (index,var item) in yahooStockDataArray.enumerated()
        {
            print("shitshitshit\(item)")
            //FIXME: 🔥 .. beware of cycling //.. in the case of no stock belonging to a symbol
            let symbol          = item["code"]!
            var stockName       :String?
            var stockLastPrice  :String?
            
            
            
            
            
            //MARK: 🔫 get the name
            if item["name"] == "no info"
            {
                
                print("shitshitshit\(item)")
                
                stockName       =  stockPuller.getStockName(yahoosymbol: symbol)
                
                stockLastPrice  = stockPuller.getExchangeRates(priceInDollar: (stockPuller.getLastPrice(yahoosymbol: symbol)))
                //stockLastPrice  =  stockPuller.getLastPrice(yahoosymbol: symbol)
                
                var blabla = stockPuller.getExchangeRates(priceInDollar: stockLastPrice!)
                print("blabla Euro: \(blabla)")
                
                yahooStockDataArray[index].updateValue(stockName!,      forKey: "name")
                yahooStockDataArray[index].updateValue(stockLastPrice!, forKey: "lastprice")
                //                var win = Double(stockLastPrice!)
                //FIXME: 🔫 CRASH - cannot properly convert into double
                print("00: \(String(describing: (yahooStockDataArray[index])["lastprice"]))")
                print("01: \(String(describing: (yahooStockDataArray[index])["pricepaid"]))")
                
                var lastpriceResult = (yahooStockDataArray[index])["lastprice"]
                var pricepaidResult = (yahooStockDataArray[index])["pricepaid"]
                
                print("K-Wurst: \(String(describing: (yahooStockDataArray[index])["lastprice"])))")
                print("K-Wurst02: \(structure.removeCharacters(String(describing: (yahooStockDataArray[index])["lastprice"])))")
                
                print("\(Double("5.5")!*4))")
                var test02 = (Double(lastpriceResult!)!*4)-500
                
                print(test02)
                
                
                
                
                
                
                win = Double(lastpriceResult!)!-Double(pricepaidResult!)!
                print("win: \(win)")
                yahooStockDataArray[index].updateValue(String(win), forKey: "change")
                
                
               structure.newTextColor = structure.changeChangeColor(String(win))
                
                print("indexblbbls: \(String(describing: (yahooStockDataArray[index])["name"]))")
                
                print("lastprice: \(String(describing: (yahooStockDataArray[index])["lastprice"]))")
                print("lastprice: \(String(describing: item["lastprice"]))")
                print("pricepaid: \(String(describing: item["pricepaid"]))")
                
                
                
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
