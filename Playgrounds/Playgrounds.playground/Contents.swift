import SwiftUI
import UIKit
import SwiftSoup
import PlaygroundSupport

let html = """
<p>The Pre-Raphaelites obsession with the wombat. <a href="https://mastodon.social/tags/australia" class="mention hashtag" rel="tag">#<span>australia</span></a> <a href="https://mastodon.social/tags/animals" class="mention hashtag" rel="tag">#<span>animals</span></a><br /><a href="https://publicdomainreview.org/essay/o-uommibatto-how-the-pre-raphaelites-became-obsessed-with-the-wombat/" target="_blank" rel="nofollow noopener noreferrer" translate="no"><span class="invisible">https://</span><span class="ellipsis">publicdomainreview.org/essay/o</span><span class="invisible">-uommibatto-how-the-pre-raphaelites-became-obsessed-with-the-wombat/</span></a></p>
"""



let doc: Document = try SwiftSoup.parseBodyFragment(html)
let body = doc.body()

let paras = try body?.select("p").array()

enum Token {
    case lineBreak
    case text(String)
    case hashTag(name: String, url: URL?)
    case link(url: URL?)
}

extension Token {
    var attributedString: AttributedString
    {
        switch self {
            case .lineBreak:
                return AttributedString("\n")
            case .text(let text):
                return AttributedString(text)
            case .hashTag(let name, let url):
                var hashTag = AttributedString("#\(name)")
                if let url {
                    hashTag.link = url
                    hashTag.foregroundColor = .pink
                    hashTag.font?.bold()
                }
                return hashTag
            case .link(let url):
                if let url {
                    var link = AttributedString(url.description)
                    var paraStyle = NSMutableParagraphStyle()
                    paraStyle.lineBreakMode = .byTruncatingTail
//                    link.paragraphStyle = paraStyle
                    link.link = url
                    return link
                } else {
                    return AttributedString("<<invalid url>>")
                }
        }
    }
}

func parseHashLink(_ node: Node) -> Token
{
    let innerSpan = node.getChildNodes().first { $0.nodeName() == "span" }
    let hashTagName = (try? innerSpan?.getChildNodes().first?.outerHtml()) ?? "NOSPAN"
    let hashTagLink = (try? node.attr("href")) ?? ""
    return .hashTag(name: hashTagName, url: URL(string: hashTagLink))
}

func parseWebLink(_ node: Node) -> Token
{
    let link = (try? node.attr("href")) ?? ""
    return .link(url: URL(string: link))
}

func parseAnchor(_ node: Node) -> Token
{
    if let relAttr = try? node.attr("rel"),
       relAttr == "tag"
    {
        return parseHashLink(node)
    }
    return parseWebLink(node)
}

func parseNode(_ node: Node) -> Token
{
    switch node.nodeName()
    {
        case "br":
            return .lineBreak
        case "a":
            return parseAnchor(node)
        default:
            let text = (try? node.outerHtml()) ?? ""
            return .text(text)
    }
}

var text = ""

var tokens = [Token]()

for p in paras ?? [] {
    for child in p.getChildNodes() {
        tokens.append(parseNode(child))
    }
}

let attributedString = tokens.reduce(AttributedString()) {
    $0 + $1.attributedString
}

PlaygroundPage.current.setLiveView(Text(attributedString).frame(width: 300))
