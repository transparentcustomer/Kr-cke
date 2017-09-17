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
    
    
    var brain = stockBrain()
    
    
    var insertedYahooSymbol: String?
    var insertedYahooSymbolNumber = "no Number given"
    var structure = stockStruct()
   

    
    var stockTableViewData = [[String:String]](){
        didSet{
            
            updateUI() //.. every time the model (data) changes - the view get reloaded
        }
    }
    
    //MARK: - Actions
    @IBAction func update(_ sender: NSButton) {
        
        print("I have \(myMoney.stringValue) bucks")
        
        if brain.automaticUpdate == false
        {
            //FIXME: progess indcator broken
            
            progress.isHidden = false
            progress.startAnimation(nil)
            
            
            stockTableViewData = brain.getUpdates()
            
            
            progress.stopAnimation(nil)
            progress.isHidden = true
            print("automatic update is off")
            updateUI()
        }else if brain.automaticUpdate == true
        {
            //FIXME: progess indcator broken
            
            progress.isHidden = false
            progress.startAnimation(nil)
            
            
            stockTableViewData = brain.getUpdates()
            
            
            progress.stopAnimation(nil)
            progress.isHidden = true
            print("automatic update is on")
            updateUI()
            
        }
        
        
    }
    
    @IBAction func updateOnOff(_ sender: NSButton)
    {
        
        if sender.state == NSOnState
        {
            
            brain.automaticUpdate = true
            
        }else if sender.state == NSOffState
        {
            
            brain.automaticUpdate = false
        }
        
    }
    
    
    
    
    
    
    @IBAction func addStock(_ sender: NSButton)
    {
        //FIXME: CLEANUP the MESS
        
        var symbolArray = brain.useCSV()
        
        let restrictedSymbolArray = symbolArray[27300...symbolArray.count-1].reversed()
        
        //.. tot 27607
        
        
        //FIXME: DispatchQueue - corretly placed and efficient???
        
        //MARK: 🍩 automatic insertion
        if stockCode.stringValue == "test"
        {
            stockCode.stringValue.removeAll()
            
            let symbolArray = restrictedSymbolArray
            
            
            for symbol in symbolArray
            {
                stockTableViewData = brain.fillStockArray(symbol, insertedYahooSymbolNumber)
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
            dataFromURLasArray?.remove(at: (dataFromURLasArray?.count)!-1)
            
            
            //seperateStockInfo
            
            dataFromURLasArray = dataFromURLasArray?.reversed()
            
            for (index, seperatecomponents) in dataFromURLasArray!.enumerated(){
                
                let indexArray = index
                //let indexArray = ((dataFromURLasArray?.count)!-index)
                let (seperateComponents) = seperatecomponents.components(separatedBy: ",N/A,")
                
                var theName         = seperateComponents[0]
                let theLastPrice    = seperateComponents[1]
                
                
                
                theName = theName.replacingOccurrences(of: "\"", with: "", options: .regularExpression)
                
                
                stockTableViewData[indexArray].updateValue(theName, forKey: "name")
                stockTableViewData[indexArray].updateValue(theLastPrice, forKey: "lastprice")
                
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
                        let insertedYahooSymbol = symbol
                        self.stockTableViewData = (self.brain.fillStockArray(insertedYahooSymbol, self.insertedYahooSymbolNumber))
                        
                        
                    }
                    
                    
                    
            }
            
        }else if !stockCode.stringValue.isEmpty
        {//MARK: 🍩  serperate insertion
            
            insertedYahooSymbol         = stockCode.stringValue
            
            if numberOffStocks.stringValue != ""{
                insertedYahooSymbolNumber   = numberOffStocks.stringValue
            }else{
                insertedYahooSymbolNumber   = "no number"
            }
            
            
            stockTableViewData = (brain.fillStockArray(insertedYahooSymbol!, insertedYahooSymbolNumber))
            
            
            
        }
    }
    
    @IBAction func clearTable(_ sender: NSButton) {
        
        stockTableViewData.removeAll()
        brain.yahooStockDataArray.removeAll()
        stockCode.stringValue.removeAll()
        updateUI()
    }
    
    @IBAction func removeRow(_ sender: NSButton)
    {
        
        if stockTableView.isRowSelected(stockTableView.selectedRow)
        {
            stockTableViewData.remove(at: stockTableView.selectedRow)
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
extension stockFishController:NSTableViewDataSource, NSTableViewDelegate{
    
    func numberOfRows(in stockTableView: NSTableView) -> Int {
        return stockTableViewData.count
    }
    
    func tableView(_ stockTableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        
        
        var result:NSTableCellView
        result  = stockTableView.make(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        result.textField?.stringValue = stockTableViewData[row][(tableColumn?.identifier)!]!
        
        
        let newTextColor = NSColor.red
        
        if tableColumn?.identifier == "code"{
            result.textField?.textColor = newTextColor
        }
        if tableColumn?.identifier == "change"{
            
            //result.textField?.textColor = structure.newTextColor
            print("structure.newTextColor- change: \(structure.newTextColor)")
            
           print("magic number: \(brain.win)")
            
            if Double(brain.win) < 0 {
                result.textField?.textColor = NSColor.red
                print("red")
            }else if Double(brain.win) > 0{
                result.textField?.textColor = NSColor.green
                print("green")
            }

            
            
            
            
        }
        
        print("tableView function")
        
        return result
    }
    
}

