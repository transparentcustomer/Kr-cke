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
    
    //..
    /*
     implement
     */
    var brain = stockBrain()
    
    var stockTableViewData = [[String:String]](){
        didSet{
            print("the model changed")
            updateUI() //.. every time the model (data) changes - the view get reloaded
        }
    }
    
    //MARK: - Actions
    @IBAction func update(_ sender: NSButton) {
        //FIXME: progess indcator broken
        progress.isHidden = false
        progress.startAnimation(nil)
        
        stockTableViewData = brain.getUpdates()
        
        
        progress.stopAnimation(nil)
        progress.isHidden = true
        
        updateUI()
        
    }
    @IBAction func addStock(_ sender: NSButton)
    {
        //FIXME: CLEANUP the MESS
        
        var symbolArray = brain.useCSV()
        print("there are \(symbolArray.count) possible symbols available")
        let restrictedSymbolArray = symbolArray[1777..<1788]
        
        print("number of symbols in the list: \(restrictedSymbolArray.count)")
        
        //MARK: automatic insertion
        if stockCode.stringValue.isEmpty{
            print("this happens if something is empty")
            print("symbolArray\(symbolArray)")
            
            for symbol  in  restrictedSymbolArray{
                
                let insertedYahooSymbol = symbol
                stockTableViewData = (brain.fillStockArray(insertedYahooSymbol))
            }
        }
        
        //MARK: serperate insertion
        if !stockCode.stringValue.isEmpty   {
            
            let insertedYahooSymbol = stockCode.stringValue
            stockTableViewData = (brain.fillStockArray(insertedYahooSymbol))
        }
    }
    
    @IBAction func clearTable(_ sender: NSButton) {
        
        stockTableViewData.removeAll()
        updateUI()
    }
    
    @IBAction func removeRow(_ sender: NSButton) {
        stockTableViewData.remove(at: stockTableView.selectedRow)
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
        return result
    }
    
}

