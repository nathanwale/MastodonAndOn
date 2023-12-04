//: [Previous](@previous)

import Foundation

let idWithHCard = "110693860790938673"
let status = MastodonStatus.previews.first { $0.id == idWithHCard }!
let content = (status.reblog ?? status).content

let parsedContent = ParsedStatusContent(html: content!)
parsedContent.tokens
parsedContent.attributedString
