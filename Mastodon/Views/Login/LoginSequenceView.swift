//
//  LoginSequenceView.swift
//  Mastodon
//
//  Created by Nathan Wale on 15/4/2024.
//

import SwiftUI

///
/// Show progress of log in, and present the appropriate view
///
struct LoginSequenceView: View
{
    @State var accessToken: AccessToken?
    @State var activeUserId: MastodonAccountId?
    @State var connectedInstance: MastodonInstance?
    
    @State var progress: Progress = .enterInstance
    
    // MARK: - subviews
    var body: some View
    {
        progressMap
        progressStepView
    }
    
    /// Progress step view
    @ViewBuilder
    var progressStepView: some View
    {
        switch progress 
        {
            case .enterInstance:
                SelectInstanceView(connectedInstance: $connectedInstance)
            case .enterUsernameAndPassword:
                UserLoginView(
                    host: connectedInstance?.domain ?? MastodonInstance.defaultHost,
                    accessToken: $accessToken)
            case .complete:
                Text("Complete")
        }
    }
    
    /// Progress map
    var progressMap: some View
    {
        HStack(alignment: .bottom)
        {
            Spacer()
            progressLabel(.enterInstance)
            Icon.ellipsis.image
                .font(.title)
                .foregroundColor(.gray)
                .padding()
            progressLabel(.enterUsernameAndPassword)
            Spacer()
        }
        .padding(.horizontal)
    }
    
    /// Progress label
    func progressLabel(_ step: Progress) -> some View
    {
        VStack
        {
            let isSelected = step == progress
            let textColour: Color = isSelected ? .primary : .primary.opacity(0.5)
            
            // Selection indicator
            if isSelected {
                Icon.chevronDown.image
                    .padding(.bottom, 1)
            }
            
            // Label
            Text(step.label)
                .multilineTextAlignment(.center)
                .foregroundColor(textColour)
            
        }
    }
}


// MARK: - inner types
extension LoginSequenceView
{
    enum Progress
    {
        case enterInstance
        case enterUsernameAndPassword
        case complete
        
        /// Label for UI
        var label: String
        {
            switch self
            {
                case .enterInstance:
                    "Choose Mastodon\n Instance"
                case .enterUsernameAndPassword:
                    "Username &\n Password"
                case .complete:
                    "Complete"
            }
        }
    }
}


// MARK: - previews
#Preview("Choose instance")
{
    LoginSequenceView()
}

#Preview("Username and Password")
{
    LoginSequenceView(progress: .enterUsernameAndPassword)
}
