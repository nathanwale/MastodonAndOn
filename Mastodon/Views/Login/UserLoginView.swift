//
//  UserLoginView.swift
//  Mastodon
//
//  Created by Nathan Wale on 14/12/2023.
//

import SwiftUI

struct UserLoginView: View 
{
    let host: String
    
    @State var username: String = ""
    @State var password: String = ""
    
    // body
    var body: some View
    {
        VStack
        {
            message
            usernameField
            passwordField
            loginButton
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
}


// MARK: - previews
#Preview {
    UserLoginView(host: MastodonInstance.defaultHost)
        .padding()
}
