//: Playground - noun: a place where people can play

import Cocoa


let file: FileHandle? = FileHandle(forWritingAtPath: "output.txt")

if file != nil {
    // Set the data we want to write
    let data = ("Silentium est aureum" as NSString).data(using: String.Encoding.utf8.rawValue)
    
    // Write it to the file
    file?.write(data!)
    
    // Close the file
    file?.closeFile()
}
else {
    print("Ooops! Something went wrong!")
}