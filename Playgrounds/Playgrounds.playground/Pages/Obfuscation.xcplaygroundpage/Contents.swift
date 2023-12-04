//: [Previous](@previous)

import Foundation

// Don't leave deobfuscated keys in the source, please
let stringToObfuscate = "CHANGE THIS, BUT CHANGE IT BACK BEFORE YOU COMMIT"
runObfuscation(stringToObfuscate)

// MARK: - model
func obfuscate(_ clearText: String) -> [UInt8]
{
    let clearData = [UInt8](clearText.data(using: .utf8)!)
    let random = (0..<clearData.count).map {
        _ in UInt8(arc4random_uniform(256))
    }
    
    let obfuscatedPrefix = zip(clearData, random).map(^)
    let obfuscated = obfuscatedPrefix + random
    return obfuscated
}

func deobfuscate(_ obfuscated: [UInt8]) -> String
{
    let a = obfuscated.prefix(obfuscated.count / 2)
    let b = obfuscated.suffix(obfuscated.count / 2)
    let deobfuscated = zip(a, b).map(^)
    return String(bytes: deobfuscated, encoding: .utf8)!
}



func runObfuscation(_ clearText: String)
{
    let obfuscated = obfuscate(clearText)
    print("Obfuscated as:", obfuscated)
    print("Deobfuscated as:", deobfuscate(obfuscated))
    print("Client secret:", Keys.clientSecret)
    print("Client key:", Keys.clientKey)
}

