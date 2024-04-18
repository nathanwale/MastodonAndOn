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
    /// Auth State
    @State var state: AuthState = .needInstance
    
    /// Error if exists
    @State var error: Error?
    
    /// Call on completion of log in
    let onComplete: () -> ()
    
    /// Fetch account ID, set next state if successful
    func fetchAccountId(host: String, accessToken: AccessToken) async
    {
        do {
            // Request account associated to this access token
            let accountRequest = VerifyAccessTokenRequest(
                host: host,
                accessToken: accessToken)
            
            let account = try await accountRequest.send()
            
            // Set state to complete
            state = .complete(host: host, accountId: account.id, token: accessToken)
        } catch {
            print(error)
            self.error = error
        }
    }
    
    /// Store log in details
    func storeDetails(host: String, accessToken: AccessToken, accountId: MastodonAccountId)
    {
        do {
            // Store login details
            try Config.shared.storeLoginDetails(
                instanceHost: host,
                accessToken: accessToken,
                accountId: accountId)
            
            print("Access Token: \(accessToken), Host: \(host), Active Account ID: \(accountId)")
        } catch {
            print(error)
            self.error = error
        }
    }
    
    
    // MARK: - subviews
    var body: some View
    {
        if let error {
            errorView(error)
        }
        titleView
        stateView
    }
    
    /// Title view
    var titleView: some View
    {
        HStack
        {
            Text("Please sign in to your Mastodon account").font(.title)
            Spacer()
        }
        .padding(.leading)
    }
    
    /// State view
    @ViewBuilder
    var stateView: some View
    {
        switch state {
            case .needInstance:
                SelectInstanceView() {
                    host in
                    state = .needAccessToken(host: host)
                }
            case .needAccessToken(let host):
                UserLoginView(host: host) {
                    token in
                    await fetchAccountId(host: host, accessToken: token)
                } onFailure: {
                    error = $0
                }

            case .complete(let host, let accountId, let token):
                EmptyView().onAppear {
                    storeDetails(host: host, accessToken: token, accountId: accountId)
                    onComplete()
                }
        }
    }
    
    /// Error view
    func errorView(_ error: Error) -> some View
    {
        HStack(alignment: .top)
        {
            //
            Icon.error.image
                .font(.title)
                .padding(5)
            
            // Messages
            VStack(alignment: .leading)
            {
                Text("There was an error attempting to sign in").font(.headline)
                Text(error.localizedDescription)
            }
        }
        .padding()
        .background(Color.yellow.opacity(0.5))
    }
    
}


// MARK: - inner types
extension LoginSequenceView
{
    enum AuthState
    {
        case needInstance
        case needAccessToken(host: String)
        case complete(host: String, accountId: MastodonAccountId, token: AccessToken)
    }
}


// MARK: - previews
#Preview("Choose instance")
{
    LoginSequenceView() {
        print("Done")
    }
}

#Preview("Error")
{
    LoginSequenceView(error: SampleError()) {
        print("Done")
    }
}

