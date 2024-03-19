//
//  StatusComposer.swift
//  Mastodon
//
//  Created by Nathan Wale on 15/3/2024.
//

import SwiftUI

struct StatusComposer: View 
{
    /// Content of post
    @State var content = ""
    
    /// Character count
    @State var remainingCharacters = StatusCharacterCounter.maxCharacters
    
    /// Character counter
    let counter = StatusCharacterCounter()
    
    /// Count characters
    func updateCharacterCount()
    {
        remainingCharacters = counter.remainingCharacters(content)
    }
    
    /// Remaining characters message
    var remainingCharactersMessage: String
    {
        let characters = (remainingCharacters.magnitude == 1)
            ? "character"
            : "characters"
        
        if remainingCharacters >= 0 {
            return "\(remainingCharacters) \(characters) left"
        } else {
            return "\(remainingCharacters.magnitude) \(characters) too many!"
        }
    }
    
    // MARK: - subviews
    var body: some View
    {
        VStack
        {
            headerText
            contentTextField
            postButton
        }
        .padding()
    }
    
    /// Header text
    var headerText: some View
    {
        Text("New post")
            .font(.headline)
    }
    
    /// Text field for post content
    var contentTextField: some View
    {
        TextField("Post content", text: $content, axis: .vertical)
            .textFieldStyle(.roundedBorder)
            .lineLimit(7, reservesSpace: true)
            .onKeyPress(phases: .up) {
                _ in
                updateCharacterCount()
                return .ignored
            }
    }
    
    /// Button for posting post
    var postButton: some View
    {
        HStack
        {
            Text(remainingCharactersMessage)
            Spacer()
            Button("Post!", systemImage: Icon.send.rawValue)
            {
                print("Posting:")
                print(content)
            }
            .disabled(remainingCharacters < 0)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    StatusComposer()
}
