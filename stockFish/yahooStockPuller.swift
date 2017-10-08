//
//  yahooStockPuller.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation


struct yahooPuller{
    
    var structure = stockStruct()
    
    
    
        
    func getStockNameFromYahoo(yahoosymbol: String) -> String{
        
        var stockName:String?
        
        let URLstring = completeYahooURL(yahoosymbol, "n") //.. "n" is name
        stockName = downloadDataWithURL(yahoourlstring: URLstring)
        
        
        //FIXME:  toDelete
//        print("URLstring: \(URLstring))")
//        print("thats the point where it breaks: \(String(describing: stockName))")
        
        return stockName!
    }
    
   
    
    
    func getLastPrice(yahoosymbol: String) -> String {
        
        var lastPrice:String?
        
        let URLstring = completeYahooURL(yahoosymbol, "b")//.. "l1" last price b is bid
        lastPrice = downloadDataWithURL(yahoourlstring: URLstring)
        
        
        return lastPrice!
        
    }
    
    func getPriceToPay (yahoosymbol: String)-> String{
        
        var pricetopay: String?
        
        let URLstring = completeYahooURL(yahoosymbol, "l1")//.. "l1" last price b is bid
        pricetopay = downloadDataWithURL(yahoourlstring: URLstring)
        
        return pricetopay!
    }
    
    //MARK: format yahoo link
    func completeYahooURL (_ symbol: String,_ value: String)->String
        
    {
//        print(#function, #line)
        
        let yahooURLstring =  "http://download.finance.yahoo.com/d/quotes.csv?s=\(symbol)&f=\(value)"
        //"http://download.finance.yahoo.com/d/quotes.csv?s=AAPL&f=n"
         //"http://download.finance.yahoo.com/d/quotes.csv?s=USDEUR=AAPL&f=n"
        return yahooURLstring
    }
    
    func downloadDataWithURL(yahoourlstring: String)->(String)
    {
        
        var dataFromURL: String?
        
        let yahooURL = URL(string: yahoourlstring)
        
        if let stringForValue = try? String(contentsOf: yahooURL!, encoding: String.Encoding.ascii) as NSString
        {
            dataFromURL = stringForValue as String
            
        }
        
        dataFromURL = dataStringProcesser(dataFromURL: dataFromURL!)
              
        
        return dataFromURL ?? "no data available"
    }
    
    func dataStringProcesser (dataFromURL: String)->String{
        var processedStringData:String?
        
        
        processedStringData = dataFromURL.replacingOccurrences(of: "\"|\n", with: "", options: .regularExpression)
        
        return processedStringData ?? dataFromURL
    }
    
    //http://download.finance.yahoo.com/d/quotes.csv?s=USDEUR=X&f=l1
    
    
    func getExchangeRates (priceInDollar: String)->String
        
    {print(#function, #line)
        
       let exchangeString = "http://download.finance.yahoo.com/d/quotes.csv?s=USDEUR=X&f=l1"
        var exchangeStringValue = ""
        
        if let url = URL(string: exchangeString) {
            do{ exchangeStringValue = try NSString(contentsOf: url, usedEncoding: nil) as String}
            catch let error as NSError{
                
                print("Error: \(error)",#line)
                print("func getExchangeRates: -contents could not be loaded")
                
            }
            
        } else {
            
            print("func getExchangeRates: -the URL was bad!")
            
        }
        
        let neuerPreis = structure.removeCharacters(priceInDollar)
        exchangeStringValue = structure.removeCharacters(exchangeStringValue)
    
        
        var priceInEuro: String?
        
        priceInEuro != nil ? (String(Double(exchangeStringValue)!*Double(neuerPreis)!)) : "no value available"
        
        
//        (String(Double(exchangeStringValue)!*Double(neuerPreis)!)) != nil ? priceInEuro : "no value available"
        
//        priceInEuro = String(Double(exchangeStringValue)!*Double(neuerPreis)!)
        
        if priceInEuro != nil {
            
        }else{
            priceInEuro = "no value available"
        }
        
        print("priceInEuro: \(String(describing: priceInEuro))")
        return priceInEuro!
    }
    
}










