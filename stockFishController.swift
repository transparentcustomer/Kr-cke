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
    

    
    var stockTableViewData = [[String:String]]()
    
    
    @IBAction func addStock(_ sender: NSButton)
    {
        stockTableViewData.insert([
            "code"      : stockCode.stringValue,
            "name"      : "no name",
            "lastprice" : "no price"
            
            ], at: 0)
        
        stockTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.stockTableView.delegate = self
        self.stockTableView.dataSource = self
        self.stockTableView.reloadData()
    }
    
}
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

