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
    @State var state: AuthState = .needInstance
    
    @State var error: Error?
    
    let onComplete: (String, MastodonAccountId, AccessToken) -> ()
    
    
    func onAcquireToken(host: String, accessToken: AccessToken) async
    {
        do {
            // Save token and active host...
            try KeychainToken.accessToken.updateOrInsert(accessToken)
            Config.shared.activeInstanceHost = host
            
            // Request account associated to this access token
            let accountRequest = VerifyAccessTokenRequest(
                host: host,
                accessToken: accessToken)
            
            let activeAccount = try await accountRequest.send()
            
            // Store active account ID
            Config.shared.activeAccountIdentifier = activeAccount.id
            
            print("Access Token: \(accessToken), Host: \(host), Active Account ID: \(activeAccount.id ?? "???")")
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
        switch state {
            case .needInstance:
                SelectInstanceView() {
                    host in
                    state = .needAccessToken(host: host)
                }
            case .needAccessToken(let host):
                UserLoginView(host: host) {
                    await onAcquireToken(host: host, accessToken: $0)
                } onFailure: {
                    error = $0
                }

            case .complete(let host, let accountId, let token):
                EmptyView().onAppear {
                    onComplete(host, accountId, token)
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
                .padding(.top, 5)
            
            // Messages
            VStack(alignment: .leading)
            {
                Text("There was an error posting").font(.headline)
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
        print($0, $1, $2)
    }
}

#Preview("Username and Password")
{
    LoginSequenceView() {
        print($0, $1, $2)
    }
}
