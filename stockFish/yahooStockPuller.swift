//
//  yahooStockPuller.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation


struct yahooPuller{
    
    
        
    func getStockName(yahoosymbol: String) -> String{
        
        var stockName:String?
        
        let URLstring = completeYahooURL(yahoosymbol, "n") //.. "n" is name
        stockName = downloadDataWithURL(yahoourlstring: URLstring)
        
        
        return stockName!
    }
    
    func getLastPrice(yahoosymbol: String) -> String {
        
        var lastPrice:String?
        
        let URLstring = completeYahooURL(yahoosymbol, "l1")//.. "l1" last price
        lastPrice = downloadDataWithURL(yahoourlstring: URLstring)
        
        
        return lastPrice!
        
    }
    
    
    //MARK: format yahoo link
    func completeYahooURL (_ symbol: String,_ value: String)->String
        
    {print(#function, #line)
        
        let yahooURLstring =  "http://download.finance.yahoo.com/d/quotes.csv?s=\(symbol)&f=\(value)"
        
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
    
}










