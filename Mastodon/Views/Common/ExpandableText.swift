//
//  ExpandableText.swift
//  Mastodon
//
//  Created by Nathan Wale on 25/9/2023.
//

import SwiftUI

///
/// An expandable text view that truncates the text to a set number of lines,
/// and then is expanded when the user taps on it.
/// - text: The text to display
/// - lines: The number of lines to truncate at
///
struct ExpandableText: View
{
    // Is the text expanded?
    @State var expanded = false
    
    // Has the text been truncated
    @State private var isTruncated: Bool?
    
    // Text to display
    var text: String
    
    // Number of lines to display before truncation
    var lines = 1
    
    // assign text at init
    init(_ text: String) 
    {
        self.text = text
    }
    
    // Is the text truncated?
    func setTruncated() -> some View
    {
        ViewThatFits(in: .vertical)
        {
            Text(text)
                .hidden()
                .onAppear() {
                    guard isTruncated == nil else { return }
                    isTruncated = false
//                    print("Text fits in one line")
                }
            Color.clear
                .hidden()
                .onAppear() {
                    guard isTruncated == nil else { return }
                    isTruncated = true
//                    print("Text DOESN'T fit in one line")
                }
        }
    }
    
    var body: some View
    {
        HStack
        {
            Text(text)
                .lineLimit(expanded ? nil : lines)
                .background(setTruncated())
            moreIndicator
            Spacer()
        }
        .onTapGesture {
            expanded.toggle()
        }
    }
    
    @ViewBuilder
    var moreIndicator: some View
    {
        if let isTruncated = isTruncated,
           isTruncated && !expanded
        {
            Icon.showText.image
        }
    }
}

#Preview 
{
    VStack
    {
        ExpandableText("""
    This is some long text, that may get truncated if it's too long. This is to let the user know there is something to read here, without taking too much room of the UI. If they want to read the full text, then they can press on it to expand it.
    """)
        Divider()
        ExpandableText("An example of a short one.")
    }
    .padding(10)
}
