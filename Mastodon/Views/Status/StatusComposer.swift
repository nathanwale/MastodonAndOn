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
    
    /// Add a content warning?
    @State var hasContentWarning = false
    
    /// Content Warning Message
    @State var contentWarningMessage = ""
    
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
            header
            if hasContentWarning {
                contentWarningTextField
            }
            contentTextField
            postButton
        }
        .padding()
    }
    
    /// Header text
    var header: some View
    {
        HStack
        {
            Text("New post").font(.headline)
            Spacer()
            contentWarningSwitch
        }
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
    
    /// Content Warning Switch
    var contentWarningSwitch: some View
    {
        Toggle(isOn: $hasContentWarning)
        {
            Text("Add Warning")
        }
        .toggleStyle(.button)
    }
    
    /// Content warning text field
    var contentWarningTextField: some View
    {
        VStack(alignment: .leading)
        {
            HStack
            {
                Icon.contentWarning.image.font(.title)
                Text("Your content will be obscured, and show this warning.")
            }
            TextField("Content warning", text: $contentWarningMessage)
                .textFieldStyle(.roundedBorder)
        }
        .padding()
        .background(.primary.opacity(0.1))
    }
}

#Preview {
    StatusComposer()
}
