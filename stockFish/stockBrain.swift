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
    var pricepaid = ""
    var yahooSymbolArray : [String] = []
    
    private var yahooSymbol:    String?
    var moneySpendForStock:Double = 0
    
    var yahooStockDataArray =   [[String:String]]()
    
    //MARK: - filling of model with symbols
    mutating func fillYahooDataArray(_ yahoosymbol: String, stockNumber: String,pricepaid: String ) -> [[String:String]]
    {
        
        yahooStockDataArray.insert(
            [
                "code"      : yahoosymbol,
                "name"      : "no info",
                "lastprice" : "no info",
                
                "pricepaid" : pricepaid,
                "number"    : stockNumber,
                "win"       : "0",
                "change"    : "no info"
                
            ], at: 0)
        
        return yahooStockDataArray
    }
    
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
            
        } catch let err as NSError {
            // do something with Error
            print(err)
            print("there is an error in processing the CSV file")
        }
        return yahooSymbolArray
    }
    
    //MARK: - get Yahoo Info:
    
    var automateUpdateTurnedOn = false

    mutating func getUpdates() -> ([[String : String]])
    { //.. to get stock names and price values
        
        
        
        

        for (index,var item) in yahooStockDataArray.enumerated()
        {

            //FIXME: 🔥 .. beware of cycling //.. in the case of no stock belonging to a symbol
            let symbol          = item["code"]!
            var stockName       :String?
            var stockLastPrice  :String?
            var lastpriceResult :String?
         
            //MARK: 🔫 get the name
            if item["name"] == "no info"
            {
                
                stockName       =  stockPuller.getStockNameFromYahoo(yahoosymbol: symbol)
                stockLastPrice  = stockPuller.getExchangeRates(priceInDollar: (stockPuller.getLastPrice(yahoosymbol: symbol)))
                stockLastPrice = String(structure.round2(valueToRoundOnTwoDecimals: Double(stockLastPrice!)!))
                
                yahooStockDataArray[index].updateValue(stockName!,      forKey: "name")
                yahooStockDataArray[index].updateValue(stockLastPrice!, forKey: "lastprice")
                
                lastpriceResult = (yahooStockDataArray[index])["lastprice"]

                
            }
            
            if item["pricepaid"] == "no info"
            {
               
                //FIXME: 🦄 needs to be fixed first
                
                var pricepaidResult = stockPuller.getPriceToPay(yahoosymbol: symbol)
                pricepaidResult = String(structure.round2(valueToRoundOnTwoDecimals: Double(pricepaidResult)!))
                 print("pricepaid == no info 🦄 \(pricepaidResult)")
                
                win = (Double(lastpriceResult!)!-Double(pricepaidResult)!)
                win = Double(structure.round2(valueToRoundOnTwoDecimals: win))!
                
                let winInPercent = String(structure.round2(valueToRoundOnTwoDecimals: (100*win/Double(pricepaidResult)!)))
                
                yahooStockDataArray[index].updateValue("\(String(win)) (\(winInPercent)%)", forKey: "change")
                
                
                yahooStockDataArray[index].updateValue(pricepaidResult, forKey: "pricepaid")
                structure.newTextColor = structure.changeChangeColor(String(win))
                
            }else{
                print("pricepaid == no info-else")
                
                
                var pricepaidResult = (yahooStockDataArray[index])["pricepaid"]
                
                pricepaidResult = String(structure.round2(valueToRoundOnTwoDecimals: Double(pricepaidResult!)!))

                win = (Double(lastpriceResult!)!-Double(pricepaidResult!)!)
                win = Double(structure.round2(valueToRoundOnTwoDecimals: win))!
                
                let winInPercent = String(structure.round2(valueToRoundOnTwoDecimals: (100*win/Double(pricepaidResult!)!)))
                
                
                yahooStockDataArray[index].updateValue("\(String(win)) (\(winInPercent)%)", forKey: "change")
                
                
                structure.newTextColor = structure.changeChangeColor(String(win))
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
    
    //MARK: - structureFunctions
    //MARK: - implementation calculator funcrions
    
//    private enum Operation{
//        
//        case stringValue(String)
////        case constant (Double)
////        case unaryOperation((Double) -> Double)
////        case binaryOperation((Double, Double) -> Double)
////        case equals
////        case reset
//        
//    }
//    
//    private var operations: Dictionary<String,Operation> = [
//        
//        "code"      : stockCode,
//        "name"      : "no info",
//        "lastprice" : "no info",
//        
//        "pricepaid" : pricepaid,
//        "number"    : stockNumber,
//        "win"       : "0",
//        "change"    : "no info"
//        
//        
//        
////        "π": Operation.constant(Double.pi),
////        "e": Operation.constant(M_E),
////        "√": Operation.unaryOperation(sqrt),
////        "cos": Operation.unaryOperation(cos),
////        "±": Operation.unaryOperation({-$0}),
////        
////        "×": Operation.binaryOperation({$0*$1}),
////        "÷": Operation.binaryOperation({$0/$1}),
////        "+": Operation.binaryOperation({$0+$1}),
////        "−": Operation.binaryOperation({$0-$1}),
////        "x²": Operation.unaryOperation({$0*$0}),
////        "=": Operation.equals
//    ]
//    
//    mutating func performOperation(_ symbol: String)
//    {
//        if let operation = operations[symbol]{
//            switch operation {
//            case .constant(let value):
//                accumulator = value
//            case .unaryOperation(let function):
//                if accumulator != nil {
//                    accumulator =  function(accumulator!)
//                }
//            case .binaryOperation(let function):
//                if accumulator != nil{
//                    pendingBinaryOperation = PendingBinaryOperation(function: function, firstOperand: accumulator!)
//                    accumulator = nil
//                }
//                
//            case .equals:
//                performPendingBinaryOperation()
//            default:
//                
//                break
//            }
//            
       }
//    
//    }
//    
//}
