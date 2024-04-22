//
//  UserLoginView.swift
//  Mastodon
//
//  Created by Nathan Wale on 14/12/2023.
//

import SwiftUI
import AuthenticationServices

///
/// Attempts OAuth sign-in
///
struct UserLoginView: View
{
    /// Authentication session
    @Environment(\.webAuthenticationSession) private var authenticationSession
    
    /// Host to sign in to
    let host: String
    
    /// Sign-in Configuration
    var signIn: SignIn
    {
        SignIn(host: host)
    }
    
    /// Call on success with access token
    let continueWithToken: (AccessToken) async -> ()
    
    /// Call on failure with error
    let onFailure: (Error) -> ()
    
    // body view
    var body: some View
    {
        VStack
        {
            ProgressView()
            Text("Taking you to")
            Text(host).monospaced().bold()
            Text("for authentication...")
        }
        .onAppear {
            beginSignIn()
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
                print("Beginning OAuth authentication...")
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
                
                let accessToken = try await accessRequest.fetchAccessToken()
                
                await continueWithToken(accessToken)
                
            } catch {
                // error
                onFailure(error)
            }
        }
    }
}
