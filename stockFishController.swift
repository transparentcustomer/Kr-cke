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
    
    //..
    /*
     implement
     */
    var brain = stockBrain()
    
    var stockTableViewData = [[String:String]](){
        didSet{
            print("the model changed")
            stockTableView.reloadData() //.. every time the model (data) changes - the view get reloaded
        }
    }
    
    //MARK: - Actions
    @IBAction func update(_ sender: NSButton) {
        brain.getUpdates()
    }
    @IBAction func addStock(_ sender: NSButton)
    {
        if stockCode.stringValue.isEmpty   {}else{
            
            let insertedYahooSymbol = stockCode.stringValue
            stockTableViewData = (brain.fillStockArray(insertedYahooSymbol))
        }
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

