//
//  yahooStockPuller.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation


struct yahooPuller{
    
    
    func getLastPrice (){
        /*{print(#function, #line, "for:", portGetOfK("code"))
         
         print("indexIndiStock: \(indexIndiStock)", #line)
         
         let letzterPreis = (portfolioData.object(at: indexIndiStock) as AnyObject).value(forKey: "lastprice")
         let quantity = (portfolioData.object(at: indexIndiStock) as AnyObject).value(forKey: "quantity")
         print(quantity == nil)
         print("letzter Preis: \(String(describing: letzterPreis)) vs", #line)
         //        print("portGetOfK(lastprice): \(portGetOfK("lastprice").isEmpty) ", #line)
         
         ///last stock price of a chosen symbol (with l1)
         if letzterPreis == nil && loadDefaults.isEmpty == true {
         
         print("--01--there was no last price yet",#line)
         
         let name = "\(getDreamValue(valuecode: formCoDict!["name"]! as! String))"
         guard name != "N/A\n"   else { throw ErrorHandling.stockError.wrongSymbol }
         
         let lastprice = "\(getDreamValue(valuecode: formCoDict!["lastprice"]! as! String))"
         guard lastprice != "N/A\n"   else { throw ErrorHandling.stockError.stockExchangeClosed }
         
         let selectedDict = portfolioData.object(at: indexIndiStock) as! Dictionary<String, String>
         
         for pair in (selectedDict) { wortbuch.updateValue(pair.value, forKey: pair.key) }
         
         updateWortbuch(wantedvalueArray: ["name","currency","lastprice"])
         
         wortbuch.updateValue(dateModulator(), forKey: "lastupdate")
         
         print(#function,#line)
         //            calcNumbers()
         
         portfolioData.removeObject(at: indexIndiStock)
         portfolioData.insert(wortbuch, at: indexIndiStock)
         wortbuch.removeAll()
         
         
         
         print("brain.loadDefaults.isEmpty: \(loadDefaults.isEmpty)", #line)
         
         
         }
         
         //        else if letzterPreis == nil && loadDefaults.isEmpty == true && quantity == nil
         //        {print("--03--load new symbols",#line)
         //
         //            //
         //        }
         else if portGetOfK("lastprice") != "\(updateDefaults(stockSymbol: portGetOfK("code"), wantedvalue: "lastprice"))"
         {print("--02--",#line)
         
         
         //            let name = "\(getDreamValue(valuecode: formCoDict!["name"]! as! String))"
         //            guard name != "N/A\n"   else { throw errorHandling.stockError.wrongSymbol }
         
         
         if (loadDefaults.isEmpty)
         
         {
         print("")
         print("load defaults is empty", #line)
         
         let selectedDict = portfolioData.object(at: indexIndiStock) as! Dictionary<String, String>
         for pair in (selectedDict) { wortbuch.updateValue(pair.value, forKey: pair.key) }
         
         wortbuch.updateValue("\(updateDefaults(stockSymbol: portGetOfK("code"), wantedvalue: "lastprice"))", forKey: "lastprice")
         wortbuch.updateValue(dateModulator(), forKey: "lastupdate")
         
         print(#function,#line)
         calcNumbers()
         
         portfolioData.removeObject(at: indexIndiStock)
         portfolioData.insert(wortbuch, at: indexIndiStock)
         
         }else{
         print("load defaults is not empty", #line)
         //                print("loadDefaults:\(loadDefaults)")
         portfolioData.removeAllObjects()
         //                print("loadDefaults:\(loadDefaults)")
         for (index,var item) in (loadDefaults.enumerated())
         {
         let updatedprice = "\(updateDefaults(stockSymbol: item["code"]! , wantedvalue: "lastprice"))"
         item.updateValue(updatedprice, forKey: "lastprice")
         item.updateValue(dateModulator(), forKey: "lastupdate")
         _ = [item]
         portfolioData.insert(item, at: index)
         print("line:", #line, "- brain.portfolioData: \(portfolioData)" )
         //                    calcNumbers()
         }
         }
         }
         
         
         
         
         
         else if letzterPreis != nil && loadDefaults.isEmpty == true
         {
         print("")
         }else{
         print("no way")
         }
         
         
         
         ///shows the last update of the last price
         if (portfolioData.object(at: indexIndiStock) as AnyObject).value(forKey: "lastupdate") == nil{
         setLast(object: dateModulator(),                    key: "lastupdate")
         //        symbolArray["lastprice"]?.append(portfolioData[indexIndiStock].objectForKey("lastprice")! as! String)
         }else
         {
         
         }
         
         }*/
    }
    
    func getStockName(yahoosymbol: String) -> String{
        
        var stockName:String?
        
        
        
        var URLstring = completeYahooURL(yahoosymbol)
        //FIXME: ..toDelete
        //..print("URL to get the name for: \(yahoosymbol): \(URLstring)")
        
        stockName = downloadDataWithURL(yahoourlstring: URLstring)
        
        
        return stockName!
    }
    
    
    //MARK: format yahoo link
    func completeYahooURL (_ symbol: String)->String
        
    {print(#function, #line)
        
        let symbolLetter = "n"
        let yahooURLstring =  "http://download.finance.yahoo.com/d/quotes.csv?s=\(symbol)&f=\(symbolLetter)"
        
        
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
        
        let processedData = dataStringProcesser(dataFromURL: dataFromURL!)
        
        dataFromURL = processedData
        print("processedDataFromURL:\(String(describing: dataFromURL))")
        
        return dataFromURL ?? "no data available"
    }
    
    func dataStringProcesser (dataFromURL: String)->String{
        var processedStringData:String?
        
      
        processedStringData = dataFromURL.replacingOccurrences(of: "\"|\n", with: "", options: .regularExpression)

        return processedStringData ?? dataFromURL
    }
    
}










