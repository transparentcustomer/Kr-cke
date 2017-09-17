//
//  stockStructure.swift
//  stockFish
//
//  Created by THECAT on 17.09.17.
//  Copyright © 2017 THECAT. All rights reserved.
//

import Foundation
import Cocoa


class stockStruct {
    
    
    func removeCharacters(_ characterString:String)-> String{
        
        var processedString: String?
        
         processedString = characterString.replacingOccurrences(of: "\"|\n", with: "", options: .regularExpression)
        
        return processedString!
    }
    
     var newTextColor = NSColor.blue
    
    func changeChangeColor(_ changevalue: String)->NSColor{
        print("changeChangeColor")
        var changeWert = Double(changevalue)!
        
        if changeWert > 0{
            newTextColor = NSColor.red
            print("changeChangeColor-red")
        }else if changeWert < 0
        {
            newTextColor = NSColor.green
             print("changeChangeColor-green")
        }
        return newTextColor
    }
    
}
