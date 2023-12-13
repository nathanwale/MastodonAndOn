//
//  ConnectionStatusView.swift
//  Mastodon
//
//  Created by Nathan Wale on 11/12/2023.
//

import SwiftUI

struct ConnectionStatusView: View 
{
    let state: SelectInstanceView.ConnectionState
    let host: String?
    let instance: MastodonInstance?
    let connectionAction: () async -> ()
    
    var body: some View
    {
        HStack(alignment: .top, spacing: 20.0)
        {
            Image(systemName: icon.rawValue)
            message
            button
        }
    }
    
    var icon: Icon
    {
        switch state {
            case .untried:
                Icon.serverConnect
            case .waiting:
                Icon.serverConnect
            case .success:
                Icon.serverSuccess
            case .failure:
                Icon.serverProblem
        }
    }
    
    @ViewBuilder
    var button: some View
    {
        switch state {
            case .untried:
                initiateConnectionButton
            case .waiting:
                waitingIndicator
            case .success:
                continueLoginButton
            case .failure:
                connectionFailureButton
        }
    }
    
    @ViewBuilder
    var message: some View
    {
        switch state {
            case .untried:
                initiateConnectionMessage
            case .waiting:
                waitingMessage
            case .success:
                successMessage
            case .failure:
                failureMessage
        }
    }
    
    // MARK: - buttons
    /// Initiate connection button
    var initiateConnectionButton: some View
    {
        Button("Connect", systemImage: Icon.serverConnect.rawValue)
        {
            Task {
                await connectionAction()
            }
        }
        .buttonStyle(.borderedProminent)
    }
    
    /// Waiting to connect
    var waitingIndicator: some View
    {
        ProgressView()
    }
    
    /// Connection success
    var continueLoginButton: some View
    {
        Button("Continue")
        {
            print("Continuing with login")
        }
        .buttonStyle(.borderedProminent)
    }
    
    /// Connection failure
    var connectionFailureButton: some View
    {
        // retry button
        Button("Retry", systemImage: Icon.serverRetry.rawValue)
        {
            print("Retrying...")
        }
        .buttonStyle(.borderedProminent)
    }
    
    
    // MARK: - messages
    // initiate connection message
    var initiateConnectionMessage: some View
    {
        Text("Specify the Mastodon server you wish to log into")
    }
    
    // waiting to connect message
    var waitingMessage: some View
    {
        Text("Connecting...")
    }
    
    // connection success message
    var successMessage: some View
    {
        VStack(alignment: .leading)
        {
            Text("Connected to **\(instance!.title)**")
            Text("Continue to log in with your username and password")
        }
    }
    
    // failure message
    var failureMessage: some View
    {
        VStack(alignment: .leading)
        {
            let host = host!
            // status
            Text("Connection to **`\(host)`** failed")
            Divider()
            // suggestions
            Text("Perhaps:").font(.headline)
            Text("• Check the spelling of the server")
            Text("• Visit [\(host)](\(host)) to see if their website is functional")
        }
    }
}

#Preview("Initiate")
{
    ConnectionStatusView(
        state: .success,
        host: MastodonInstance.defaultHost,
        instance: MastodonInstance.sample)
    {
        print("Connecting...")
    }
}
