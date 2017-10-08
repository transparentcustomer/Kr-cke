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
    //MARK: - Pointers:
    var stockPuller = yahooPuller()
    var structure = stockStruct()
    
    //MARK: - variables:
    //MARK: 🤔 whatelse can be made private?
    private var yahooSymbol:    String?
    var win: Double = 0
    var pricepaid           : String?
    var numberToBuy         : String?
    var insertedYahooSymbol : String?
    var yahooSymbolArray    : [String]?
    
    var automateUpdateTurnedOn = false
    //FIXME: delete ⚰️
    //    var yahooSymbolArray    : [String] = []
    var yahooStockDataArray =   [[String:String]]()
    
    
    var moneySpendForStock:Double = 0
    
    //MARK: - add stock to tableView 🍩  serperate insertion
    mutating func addStockSingleInsertion()->[[String:String]]{
        
        if !((insertedYahooSymbol?.isEmpty)!)
        {
            //FIXME: 💩 breaks with unknown symbols
            yahooStockDataArray = (fillArrayAfterPushingAddStock(insertedYahooSymbol!, stockNumber: numberToBuy!, pricepaid: pricepaid! ))
            
            print("🔮\(yahooStockDataArray)")
        }
        return yahooStockDataArray
        
    }
    
    //MARK: - filling of model with symbols
    mutating func fillArrayAfterPushingAddStock(_ yahoosymbol: String, stockNumber: String,pricepaid: String ) -> [[String:String]]
    {
        yahooStockDataArray.insert(
            [
                "code"      : yahoosymbol,
                "name"      : "no info",
                "lastprice" : "no info",
                "pricepaid" : pricepaid.isEmpty     ?   "0": pricepaid,
                "number"    : stockNumber.isEmpty   ?   "0": stockNumber,
                "win"       : "0",
                "change"    : "no info"
                
            ], at: 0)
        print("🔮🔮\(yahooStockDataArray)")
        return yahooStockDataArray
    }
    
    //MARK: - get stock Smbols for CSV file
    
    mutating func extractStockSymbolsFromCSV()-> Array<String>
    {
        //FIXME: CLEANUP the MESS
        
        do {
            
            if let path = Bundle.main.path(forResource: "yahooSymbols", ofType: "csv")
            {
                //.. STORE CONTENT OF FILE IN VARIABLE:
                let data = try String(contentsOfFile:path, encoding: String.Encoding.utf8)
                yahooSymbolArray = data.components(separatedBy: "\r") //.. removal of return commands from String
            }
            
        } catch let fehler as NSError {
            // do something with Error
            print(fehler)
            print("there is an error in processing the CSV file")
        }
        return yahooSymbolArray!
    }
    
    //MARK: - get Yahoo Info:
    
    mutating func getSeperateValues(stockinfo: String, Index: Int){
        
        let stocksymbol = ((yahooStockDataArray[Index])["code"]!)
        
        switch stockinfo{
            
        case "name":
            
            if (((yahooStockDataArray[Index])[stockinfo]!) == "no info")
            {
                let stockname = stockPuller.getStockNameFromYahoo(yahoosymbol: stocksymbol)
                yahooStockDataArray[Index].updateValue(stockname,      forKey: stockinfo)
            }
            
        case "lastprice":
            
            if (((yahooStockDataArray[Index])[stockinfo]!) == "no info")
            {
                let stockLastPrice = stockPuller.getLastPrice(yahoosymbol: stocksymbol)
                yahooStockDataArray[Index].updateValue(stockLastPrice,      forKey: stockinfo)
            }
            
        case "pricepaid":
            
            
            if !((yahooStockDataArray[Index])[stockinfo]!).isEmpty
            {
                
                if !(pricepaid?.isEmpty)!
                {
                    yahooStockDataArray[Index].updateValue(pricepaid!, forKey: stockinfo)
                    
                }else{
                    var pricepaidResult  = stockPuller.getPriceToPay(yahoosymbol: stocksymbol)
                    pricepaidResult = String(structure.round2(valueToRoundOnTwoDecimals: Double(pricepaidResult)!))
                    yahooStockDataArray[Index].updateValue(pricepaidResult, forKey: stockinfo)
                }
                
            }else{
                
                print("👁👁👁👁👁👁")
                
            }
            
            
        case "change":
            
            if ((((yahooStockDataArray[Index])[stockinfo]!) == "no info") && (((yahooStockDataArray[Index])["lastprice"]!) != "N/A"))
            {
                
                win = Double((yahooStockDataArray[Index])["lastprice"]!)!-Double((yahooStockDataArray[Index])["pricepaid"]!)!
                
                yahooStockDataArray[Index].updateValue(String(win),      forKey: stockinfo)
                
            }else{
                yahooStockDataArray[Index].updateValue("☠️",      forKey: stockinfo)
            }
            
        default:
            print("default 👀 not used")
        }
    }
    
    
    mutating func getUpdates() -> ([[String : String]])
    { //.. to get stock names and price values
        
        for (index,var item) in yahooStockDataArray.enumerated()
        {
            
            
            //FIXME: 🔥 .. beware of cycling //.. in the case of no stock belonging to a symbol
            let symbol          = item["code"]! // cant be empty
            
            // take the stockinfo (name,price) - the key and executes a function:
            for dicpair in item{  getSeperateValues(stockinfo: dicpair.key, Index: index) }
            
            
            
            print("yahooStockDataArray: \(yahooStockDataArray)")
            
            
            
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
                
                stockName       =  stockPuller.getStockNameFromYahoo(yahoosymbol: symbol)
                
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

