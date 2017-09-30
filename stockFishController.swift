//
//  stockFishController.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Cocoa

class stockFishController: NSViewController {
    
    @IBOutlet weak var stockTableView: NSTableView!
    @IBOutlet weak var stockCode: NSTextField!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var myMoney: NSTextField!
    @IBOutlet weak var numberOffStocks: NSTextField!
    @IBOutlet weak var pricePaid: NSTextField!
    
    
    var brain = stockBrain()
    
    
    var insertedYahooSymbol: String?
    var insertedYahooSymbolNumber = "no Number given"
    var structure = stockStruct()
   
    var pricepaid: String?

    
    var yahooDataArray = [[String:String]](){
        didSet{
            
            updateUI() //.. every time the model (data) changes - the view get reloaded
        }
    }
    
    //MARK: - Actions
    @IBAction func update(_ sender: NSButton) {
        
        print("I have \(myMoney.stringValue) bucks")
        
        if brain.automateUpdate == false
        {
            //FIXME: progess indcator broken
            
            progress.isHidden = false
            progress.startAnimation(nil)
            
            yahooDataArray = brain.getUpdates()
            
            progress.stopAnimation(nil)
            progress.isHidden = true
            print("automatic update is off")
            updateUI()
        }else if brain.automateUpdate == true
        {
            //FIXME: progess indcator broken
            
            progress.isHidden = false
            progress.startAnimation(nil)
            
            yahooDataArray = brain.getUpdates()
            
            progress.stopAnimation(nil)
            progress.isHidden = true
            print("automatic update is on")
            updateUI()
            
        }
        
        
    }
    
    //.. func to automate the update with time interval
    @IBAction func updateOnOff(_ sender: NSButton)
    {
        
        if sender.state == NSControl.StateValue.on
        {
            brain.automateUpdate = true
            
        }else if sender.state == NSControl.StateValue.off
        {
            brain.automateUpdate = false
        }
    }

    
    @IBAction func addStock(_ sender: NSButton)
    {
        //FIXME: CLEANUP the MESS
        
        var symbolArray = brain.extractStockSymbolsFromCSV()
        
                
        if pricePaid.stringValue != "" {
            pricepaid = pricePaid.stringValue
        }else{
            pricepaid = "no info"
        }
        
        
        let restrictedSymbolArray = symbolArray[27300...symbolArray.count-1].reversed()
        
        //.. tot 27607
        
        
        //FIXME: DispatchQueue - corretly placed and efficient???
        
        //MARK: 🍩 automatic insertion
        
        
        if !stockCode.stringValue.isEmpty //MARK: 🍩  serperate insertion
        {
            
            insertedYahooSymbol = stockCode.stringValue
            
            if numberOffStocks.stringValue != ""{insertedYahooSymbolNumber = numberOffStocks.stringValue
            }else{ insertedYahooSymbolNumber   = "no number"}
            
            yahooDataArray = (brain.fillYahooDataArray(insertedYahooSymbol!, stockNumber: insertedYahooSymbolNumber, pricepaid: pricepaid!))
            print("🔮\(yahooDataArray)")
        }else if stockCode.stringValue == "test"
        {
            stockCode.stringValue.removeAll()
            
            let symbolArray = restrictedSymbolArray
            
            
            for symbol in symbolArray
            {
                
                yahooDataArray = brain.fillYahooDataArray(symbol, stockNumber: insertedYahooSymbolNumber, pricepaid: pricepaid!)
            }
            
            var symbolArrayString = ""
            
            for symbol in symbolArray
            {
                print("symbol: \(symbol)")
                
                if symbolArrayString == "" {
                    symbolArrayString = symbolArrayString+symbol
                }else{
                    symbolArrayString = symbolArrayString+","+symbol
                }
            }
            
            
            print("symbolArrayString: \(String(describing: symbolArrayString))")
            
            let multiLastPriceURLstring = "http://download.finance.yahoo.com/d/quotes.csv?s=\(symbolArrayString)&f=n,l1"
            print("multiLastPriceURLstring: \(multiLastPriceURLstring)")
            //"http://download.finance.yahoo.com/d/quotes.csv?s=AAPL,ABC,MMM&f=n,l1"
            
            var dataFromURL: String?
            
            let yahooURL = URL(string: multiLastPriceURLstring)
            
            if let stringForValue = try? String(contentsOf: yahooURL!, encoding: String.Encoding.utf8)
                
            {dataFromURL = stringForValue as String}
            
            var dataFromURLasArray = dataFromURL?.components(separatedBy: "\n")
            
            //MARK: process the data
            
            
            //dataFromURLasArray?.remove(at: (dataFromURLasArray?.count)!-1)
            
            
            //seperateStockInfo
            
            dataFromURLasArray = dataFromURLasArray?.reversed()
            
            for (index, seperatecomponents) in dataFromURLasArray!.enumerated(){
                
                let indexArray = index
                //let indexArray = ((dataFromURLasArray?.count)!-index)
                let (seperateComponents) = seperatecomponents.components(separatedBy: ",N/A,")
                
                var theName         = seperateComponents[0]
                let theLastPrice    = seperateComponents[1]
                
                
                
                theName = theName.replacingOccurrences(of: "\"", with: "", options: .regularExpression)
                
                
                yahooDataArray[indexArray].updateValue(theName, forKey: "name")
                yahooDataArray[indexArray].updateValue(theLastPrice, forKey: "lastprice")
                
                print("restrictedSymbolArray: \(restrictedSymbolArray)")
                
                
                
            }
            
            print("number of symbols: \(restrictedSymbolArray.count+1)")
            print("number of names: \(restrictedSymbolArray.count)")
            print("number of prices: \(restrictedSymbolArray.count)")
            
        }else if self.stockCode.stringValue.isEmpty
        {
            DispatchQueue.main.async
                { [unowned self] in
                    
                    for symbol  in  restrictedSymbolArray
                    {
                        self.insertedYahooSymbol = symbol
                        self.yahooDataArray = (self.brain.fillYahooDataArray(self.insertedYahooSymbol!, stockNumber: self.insertedYahooSymbolNumber, pricepaid: self.pricepaid!))
                    
                    }
    
            }
            
        }
    }
    
    @IBAction func clearTable(_ sender: NSButton) {
        
        yahooDataArray.removeAll()
        brain.yahooStockDataArray.removeAll()
        stockCode.stringValue.removeAll()
        updateUI()
    }
    
    @IBAction func removeRow(_ sender: NSButton)
    {
        
        if stockTableView.isRowSelected(stockTableView.selectedRow)
        {
            yahooDataArray.remove(at: stockTableView.selectedRow)
            updateUI()
        }
        
    }
    
    
    
    @IBAction func test(_ sender: NSButton)
    {
        brain.searchCSVforBrokenSymbols()
        updateUI()
    }
    
    func updateUI(){
        
        stockTableView.reloadData()
        
    }
    
    //MARK: -
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        self.stockTableView.reloadData()
        
        
        
    }
    
}



//MARK: - TableViewFunctions:





extension stockFishController:NSTableViewDataSource, NSTableViewDelegate
{

    func numberOfRows(in stockTableView: NSTableView) -> Int {
        
        
        print("yahooDataArray.count\(yahooDataArray.count)")

        
        return yahooDataArray.count
        
    }

    
    
    func tableView(_ stockTableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{

        print("😭😭😭")
        var cellInStockTableView:NSTableCellView
        
        cellInStockTableView  = stockTableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView

        var reihe = yahooDataArray[row]
        print("reihe\(reihe[(tableColumn?.identifier.rawValue)!])")
        //FIXME: 👾
//        cellInStockTableView.textField?.stringValue = yahooDataArray[row][(tableColumn?.identifier)!]!
        cellInStockTableView.textField?.stringValue = yahooDataArray[row][(tableColumn?.identifier.rawValue)!]!


        let setRedAsTextColor = NSColor.red

        if (tableColumn?.identifier)!.rawValue == "code"{
            cellInStockTableView.textField?.textColor = setRedAsTextColor

            print("👺\(cellInStockTableView.textField?.stringValue)")

        }
        if (tableColumn?.identifier)!.rawValue == "change"{

            //result.textField?.textColor = structure.newTextColor
            print("structure.newTextColor- change: \(structure.newTextColor)")

           print("magic number: \(brain.win)")

            if Double(brain.win) < 0 {
                cellInStockTableView.textField?.textColor = NSColor.red
                print("red")
            }else if Double(brain.win) > 0{
                cellInStockTableView.textField?.textColor = NSColor.green
                print("green")
            }else{
                print("andereFarbe")
            }





        }

        print("tableView function")

        
        return cellInStockTableView
    }

}


