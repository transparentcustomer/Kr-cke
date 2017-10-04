//
//  stockFishController.swift
//  stockFish
//
//  Created by THECAT on 06.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Cocoa

class stockFishController: NSViewController {
    //MARK: - Outlets
    @IBOutlet weak var stockTableView: NSTableView!
    @IBOutlet weak var yahooSymbol: NSTextField!
    @IBOutlet weak var progress: NSProgressIndicator!
    @IBOutlet weak var myMoney: NSTextField!
    @IBOutlet weak var numberOffStocks: NSTextField!
    @IBOutlet weak var pricePaid: NSTextField!
    
    //MARK: - Pointers:
    var brain = stockBrain()
    var structure = stockStruct()
    //MARK: - variables:
    
//    var insertedYahooSymbol: String?
    var insertedYahooSymbolNumber = "no Number given"
    
    
    //    var pricepaid: String?
    
    var yahooDataArray = [[String:String]](){
        didSet{
            updateUI() //.. every time the model (data) changes - the view get reloaded
        }
    }
    
    //MARK: - Actions
    fileprivate func executeUpdate() {
        
        progress.isHidden = false
        progress.startAnimation(nil)
        yahooDataArray = brain.getUpdates()
        progress.stopAnimation(nil)
        progress.isHidden = true
        updateUI()
        
        brain.automateUpdateTurnedOn ?
            print("automatic update is on") :
            print("automatic update is off")
    }
    
    @IBAction func update(_ sender: NSButton) {executeUpdate()}
    
    //.. func to automate the update with time interval
    @IBAction func updateOnOff(_ sender: NSButton)
    {
        let buttonTurnedOn = sender.state == NSControl.StateValue.on
        buttonTurnedOn ? (brain.automateUpdateTurnedOn = true) : (brain.automateUpdateTurnedOn = false)
    }
    
    /*fileprivate func useYahooSymbol() {
        //FIXME: CLEANUP the MESS

//
//        (pricePaid.stringValue != brain.pricepaid) ? (brain.pricepaid = pricePaid.stringValue):(brain.pricepaid = "no info")
//        (numberOffStocks.stringValue != brain.numberToBuy) ? (brain.numberToBuy = numberOffStocks.stringValue):(brain.numberToBuy = "no info")
     
//        var symbolArray = brain.extractStockSymbolsFromCSV()
//
//        let restrictedSymbolArray = symbolArray[27300...symbolArray.count-1].reversed()
        //.. tot 27607
        
        //FIXME: DispatchQueue - corretly placed and efficient???
        
        //MARK: 🍩 automatic insertion
//        if !(brain.insertedYahooSymbol?.isEmpty)! //MARK: 🍩  serperate insertion
//        {
//            if numberOffStocks.stringValue != ""{insertedYahooSymbolNumber = numberOffStocks.stringValue
//            }else{ insertedYahooSymbolNumber   = "no number"}
//
//            yahooDataArray = (brain.fillYahooDataArray(brain.insertedYahooSymbol!, stockNumber: insertedYahooSymbolNumber, pricepaid: brain.pricepaid))
//            print("🔮\(yahooDataArray)")
//        }
//        else if  brain.insertedYahooSymbol == "test"
//        {
//            yahooSymbol.stringValue.removeAll()
//
//
//            let symbolArray = restrictedSymbolArray
//
//
//            for symbol in symbolArray
//            {
//
//                yahooDataArray = brain.fillYahooDataArray(symbol, stockNumber: insertedYahooSymbolNumber, pricepaid: brain.pricepaid)
//            }
//
//            var symbolArrayString = ""
//
//            for symbol in symbolArray
//            {
//                print("symbol: \(symbol)")
//
//                if symbolArrayString == "" {
//                    symbolArrayString = symbolArrayString+symbol
//                }else{
//                    symbolArrayString = symbolArrayString+","+symbol
//                }
//            }
//
//
//            print("symbolArrayString: \(String(describing: symbolArrayString))")
//
//            let multiLastPriceURLstring = "http://download.finance.yahoo.com/d/quotes.csv?s=\(symbolArrayString)&f=n,l1"
//            print("multiLastPriceURLstring: \(multiLastPriceURLstring)")
//            //"http://download.finance.yahoo.com/d/quotes.csv?s=AAPL,ABC,MMM&f=n,l1"
//
//            var dataFromURL: String?
//
//            let yahooURL = URL(string: multiLastPriceURLstring)
//
//            if let stringForValue = try? String(contentsOf: yahooURL!, encoding: String.Encoding.utf8)
//
//            {dataFromURL = stringForValue as String}
//
//            var dataFromURLasArray = dataFromURL?.components(separatedBy: "\n")
//
//            //MARK: process the data
//
//
//            //dataFromURLasArray?.remove(at: (dataFromURLasArray?.count)!-1)
//
//
//            //seperateStockInfo
//
//            dataFromURLasArray = dataFromURLasArray?.reversed()
//
//            for (index, seperatecomponents) in dataFromURLasArray!.enumerated(){
//
//                let indexArray = index
//                //let indexArray = ((dataFromURLasArray?.count)!-index)
//                let (seperateComponents) = seperatecomponents.components(separatedBy: ",N/A,")
//
//                var theName         = seperateComponents[0]
//                let theLastPrice    = seperateComponents[1]
//
//
//
//                theName = theName.replacingOccurrences(of: "\"", with: "", options: .regularExpression)
//
//
//                yahooDataArray[indexArray].updateValue(theName, forKey: "name")
//                yahooDataArray[indexArray].updateValue(theLastPrice, forKey: "lastprice")
//
//                print("restrictedSymbolArray: \(restrictedSymbolArray)")
//
//            }
//
//            print("number of symbols: \(restrictedSymbolArray.count+1)")
//            print("number of names: \(restrictedSymbolArray.count)")
//            print("number of prices: \(restrictedSymbolArray.count)")
//
//        }else if self.yahooSymbol.stringValue.isEmpty
//        {
//            DispatchQueue.main.async
//                { [unowned self] in
//
//                    for symbol  in  restrictedSymbolArray
//                    {
//                        self.brain.insertedYahooSymbol = symbol
//                        self.yahooDataArray = (self.brain.fillYahooDataArray(self.brain.insertedYahooSymbol!, stockNumber: self.insertedYahooSymbolNumber, pricepaid: self.brain.pricepaid))
//                    }
//            }
//
//        }
    }*/
    
    @IBAction func addStock(_ sender: NSButton)
    {
        brain.insertedYahooSymbol = yahooSymbol.stringValue
        
        (pricePaid.stringValue != brain.pricepaid) ? (brain.pricepaid = pricePaid.stringValue):(brain.pricepaid = "no info")
        
        
        (numberOffStocks.stringValue != brain.numberToBuy) ? (brain.numberToBuy = numberOffStocks.stringValue):(brain.numberToBuy = "no info")
        
        
        
        brain.addStockSeperateInsertion()
//       useYahooSymbol()
       
    }
    
    @IBAction func clearTable(_ sender: NSButton) {
        
        yahooDataArray.removeAll()
        brain.yahooStockDataArray.removeAll()
        yahooSymbol.stringValue.removeAll()
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
        
        return yahooDataArray.count
        
    }
    
    
    
    func tableView(_ stockTableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView?{
        
        print("😭😭😭")
        var cellInStockTableView:NSTableCellView
        
        cellInStockTableView  = stockTableView.makeView(withIdentifier: (tableColumn?.identifier)!, owner: self) as! NSTableCellView
        
        //FIXME: 👾
        //        cellInStockTableView.textField?.stringValue = yahooDataArray[row][(tableColumn?.identifier)!]!
        cellInStockTableView.textField?.stringValue = yahooDataArray[row][(tableColumn?.identifier.rawValue)!]!
        
        
        let setRedAsTextColor = NSColor.red
        
        if (tableColumn?.identifier)!.rawValue == "code"{
            cellInStockTableView.textField?.textColor = setRedAsTextColor
            
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

//FIXIT: - Recycle Code🛢:



