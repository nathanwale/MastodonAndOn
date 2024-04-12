//
//  UserLoginView.swift
//  Mastodon
//
//  Created by Nathan Wale on 14/12/2023.
//

import SwiftUI
import AuthenticationServices
import SafariServices

struct UserLoginView: View 
{
    @Environment(\.webAuthenticationSession) private var authenticationSession
    @Environment(\.openURL) var openUrl
    
    let host: String
    
    @State var token: AccessToken? = nil
    
    var signIn: SignIn
    {
        SignIn(host: host)
    }
    
    @State var username: String = ""
    @State var password: String = ""
    
    // body
    var body: some View
    {
        VStack
        {
            Button("Sign in")
            {
                beginSignIn()
            }
            .buttonStyle(.borderedProminent)
            
            Divider()
            
            Text("Token").font(.title)
            Text(token ?? "Waiting for token...")
        }
    }
    
    /// message
    var message: some View
    {
        Text("Logging in to **`\(host)`**")
    }
    
    /// Username input field
    var usernameField: some View
    {
        TextField("Username", text: $username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
            .textFieldStyle(.roundedBorder)
    }
    
    /// Password input field
    var passwordField: some View
    {
        SecureField("Password", text: $password)
            .textFieldStyle(.roundedBorder)
    }
    
    /// Log in button
    var loginButton: some View
    {
        HStack
        {
            Spacer()
            Button("Log in")
            {
                print("Logging into \(host), as \(username), with a password that's \(password.count) characters")
            }
            .buttonStyle(.borderedProminent)
        }
    }
    
    /// Begin sign in
    func beginSignIn()
    {
        // ensure URL isn't nil
        guard let url = signIn.authUrl else {
            print("Invalid url: \(signIn.authUrl?.description ?? "Is nil")")
            return
        }
        
        // Async task to request auth
        Task
        {
            do {
                // get URL from authentication session
                let returnedUrl = try await authenticationSession.authenticate(
                    using: url,
                    callbackURLScheme: signIn.callbackScheme)
                
                print("Returned url: \(returnedUrl.absoluteString)")
                
                // get token from returned URL
                let urlComponents = URLComponents(string: returnedUrl.absoluteString)
                let queryItems = urlComponents?.queryItems
                
                // get auth token from URL
                let authCode = queryItems?.first {
                    $0.name == "code"
                }?.value
                
                // request access token
                let accessRequest = AccessTokenRequest(
                    host: host,
                    authCode: authCode!,
                    redirectUri: signIn.callbackUrl!)
                
                token = try await accessRequest.fetchAccessToken()
                
                // did we get the token?
                if let token {
                    // Save token and active host...
                    try KeychainToken.accessToken.updateOrInsert(token)
                    Config.shared.activeInstanceHost = host
                    
                    // Request account associated to this access token
                    let accountRequest = VerifyAccessTokenRequest(
                        host: host,
                        accessToken: token)
                    
                    let activeAccount = try await accountRequest.send()
                    
                    // Store active account ID
                    Config.shared.activeAccountIdentifier = activeAccount.id
                    
                    print("Access Token: \(token)")
                } else  {
                    print("Access token unavailable")
                }

            } catch {
                // error
                print(error)
            }
        }
    }
}


// MARK: - previews
#Preview {
    UserLoginView(host: MastodonInstance.defaultHost)
        .padding()
}
