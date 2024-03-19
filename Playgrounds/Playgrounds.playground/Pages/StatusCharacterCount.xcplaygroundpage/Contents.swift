//: [Previous](@previous)

import RegexBuilder

let post = """
I need to know what a custom emoji on Mastodon looks like for a project.
https://docs.joinmastodon.org/user/posting/#text
No one reads this, so I might as well do it here: 🏏 That's cricket!
I am @nwale@mastodon.social . If you're already on mastodon.social, you can reference me as @nwale !
:blobpeek: And blob cat peeking at you. Hope you&#39;re not doing anything you shouldn't. :fatyoshi:
"""

let expectedCount = 500-152
let urlSubstitutionValue = 23

var urlRegex = Regex
{
    Anchor.wordBoundary
    Capture {
        ChoiceOf {
            "http://"
            "https://"
        }
        ZeroOrMore(.whitespace.inverted)
    }
    Anchor.wordBoundary
}.ignoresCase()

var mentionRegex = Regex
{
    "@"
    OneOrMore(.word)
    Capture {
        "@"
        OneOrMore(.word)
        "."
        OneOrMore(.word)
    }
}

func characterCount(_ text: String) -> Int
{
    // Find weblinks
    let urlMatches = post.matches(of: urlRegex).map {
        String($0.output.0)
    }
    
    // Total URL character count
    let urlCharacterCount = urlMatches.joined().count
    
    // Substitution count for URLs
    let urlSubstitutionCount = urlMatches.count * urlSubstitutionValue
    
    // Find external instances in mentions
    let externalInstances = post.matches(of: mentionRegex).map {
        String($0.output.1)
    }
    
    // Count characters in external instances
    let externalInstanceCharacterCount = externalInstances.reduce(0) {
        $0 + $1.count
    }
    
    // Final count
    let finalCount = text.count
        - urlCharacterCount                 // Subtract URL char count
        + urlSubstitutionCount              // ...replace with substitution count
        - externalInstanceCharacterCount    // Subtract external instances in Mentions
    
    // Return final count
    return finalCount
}



print("")
print("Post count: \(characterCount(post))")
print(" Should be: \(expectedCount)")
