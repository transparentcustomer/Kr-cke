//: Playground - noun: a place where people can play

import Cocoa



//let file: FileHandle? = FileHandle(forWritingAtPath: "output.txt")
//
//if file != nil {
//    // Set the data we want to write
//    let data = ("Silentium est aureum" as NSString).data(using: String.Encoding.utf8.rawValue)
//    
//    // Write it to the file
//    file?.write(data!)
//    
//    // Close the file
//    file?.closeFile()
//}
//else {
//    print("Ooops! Something went wrong!")
//}
//
//
//var someValue = "133.85"
//
//Double(someValue)!*5
//
//let str = "$4,102.33"
//
//let formatter = NumberFormatter()
//formatter.numberStyle = .currency
//
//if let number = formatter.number(from: str) {
//    let amount = number.decimalValue
//    print(amount)
//}
//
//
//var gameTimer: Timer!
//
//@objc func runTimedCode(){
//    print("Selarie")
//}
//gameTimer = Timer.scheduledTimer(timeInterval: 5, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: true)

var wert: String?

wert = "dog"

let weisnicht =  ""

if let soma = wert{
 weisnicht = soma
}


switch weisnicht {
case "cat", "Löwe" :
    print("Es ist eine Pussy oder eine Große Pussy")
case "Echse":
    print("Es ist eine Amphibie")
case "dog" :
    print("Es ist wirklich ein Hund")
default:
    print("Es wird schon irgendwas sein")
}




//gameTimer.invalidate()
