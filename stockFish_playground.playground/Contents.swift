//: Playground - noun: a place where people can play

import Cocoa


var str = "Hello playground this is a test"

//var arsch = str.components(separatedBy: " ")
//
//var ari = [[String]]()
//
//for word in arsch {
//    ari.insert([word], at: 0)
//    print("\(ari[0])")
//}
//
//print("\(ari[0])")
//print("\(arsch[0])")


let stringNumbers = "1 2 10"
var arrayIntegers = stringNumbers.components(separatedBy: " ").flatMap { Int($0) }

arrayIntegers[0]

let stringLetter = "Alle meine Hasen"
var arrayLetter = stringLetter.components(separatedBy: " ").flatMap { String($0) }

arrayLetter[0]
var array = ["1|First", "2|Second", "3|Third"]

let newarray = array.map { $0.componentsSeparatedByString(", ")[1] }