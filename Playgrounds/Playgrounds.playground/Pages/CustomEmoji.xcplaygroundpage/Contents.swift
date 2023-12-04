//: [Previous](@previous)

import Foundation
import RegexBuilder


var string = "Hello! :smile:! How's it :frown:going?"

let matches = string.matches(of: /:(.*):/.repetitionBehavior(.reluctant))

var lower = string.startIndex
var upper = string.endIndex
var result = ""
for match in matches {
    upper = match.range.lowerBound
    result += string[lower..<upper]
    result += "<<EMOJI: \(match.output.1)>>"
    lower = match.range.upperBound
}
result += string[lower..<string.endIndex]
result

//var text = Regex
//{
//    NegativeLookahead(":")
//    Capture
//    {
//        OneOrMore(.reluctant)
//        {
//            /./
//        }
//    }
//}
//
//var emojiToken = Regex
//{
//    ":"
//    Capture {
//        /.*^:/
//    }
//    ":"
//}
//
//var regex = Regex
//{
//    OneOrMore
//    {
//        ChoiceOf {
//            emojiToken
//            text
//        }
//    }
//}
//
//let matches = string.matches(of: regex)
//matches.count
//
//string.split(separator: ":")
