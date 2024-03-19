//
//  StatusCharacterCounter.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/3/2024.
//

import RegexBuilder

///
/// Count the characters in a Status according to Mastodon's rules
/// Mastodon counts all URLs as 23 Characters
/// Mentions are also stripped of the instance component
/// (ie. in `@name@example.social`, only the `@name` part is counted)
///
struct StatusCharacterCounter
{
    /// Maximum characters for a post
    static let maxCharacters = 500
    
    /// How many characters a URL is worth
    let urlSubstitutionValue = 23

    /// Regex for finding URLs. In Mastodon, URLs must start with `http://` or `https://`
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

    /// Regex for finding mentions with an external instance, and capturing the instance
    /// eg.: will find `@name@example.social` and capture the `@example.social` part
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

    /// The character count according to Mastodon's counting algorithm
    func count(_ text: String) -> Int
    {
        // Find weblinks
        let urlMatches = text.matches(of: urlRegex).map {
            String($0.output.0)
        }
        
        // Total URL character count
        let urlCharacterCount = urlMatches.joined().count
        
        // Substitution count for URLs
        let urlSubstitutionCount = urlMatches.count * urlSubstitutionValue
        
        // Find external instances in mentions
        let externalInstances = text.matches(of: mentionRegex).map {
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
    
    /// Remaining character allowance
    func remainingCharacters(_ text: String) -> Int
    {
        Self.maxCharacters - count(text)
    }
}
