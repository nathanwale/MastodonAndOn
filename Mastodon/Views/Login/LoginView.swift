//
//  LoginView.swift
//  Mastodon
//
//  Created by Nathan Wale on 5/12/2023.
//

import SwiftUI

struct LoginView: View 
{
    @State var username = ""
    @State var password = ""
    @State var instance = MastodonInstance.defaultHost
    @State var isEditingInstance = false
    
    let instances = MastodonInstance.defaultHosts
    
    /// Most instances to display in list
    let instanceListMaxSize = 20
        
    var body: some View
    {
        VStack
        {
            Text("Log in")
                .font(.largeTitle)
            panel
            loginButton
        }
    }
    
    var panel: some View
    {
        List
        {
            Section("Instance Server")
            {
                instanceInput
                if shouldShowInstanceList {
                    instanceSelection
                }
            }
            Section("Account")
            {
                usernameField
                passwordField
            }
        }
    }
    
    /// Combined free input and list selection for instances
    var instanceInput: some View
    {
        HStack
        {
            TextField("Server", text: $instance)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onChange(of: instance) {
                    isEditingInstance = true
                }
        }
    }
    
    /// Username input field
    var usernameField: some View
    {
        TextField("Username", text: $username)
            .textInputAutocapitalization(.never)
            .autocorrectionDisabled()
    }
    
    /// Password input field
    var passwordField: some View
    {
        SecureField("Password", text: $password)
    }
    
    /// Log in button
    var loginButton: some View
    {
        Button("Log in")
        {
            print("Logging into \(instance), as \(username), with a password that's \(password.count) characters")
        }
    }
    
    /// Server instance selector
    var instanceSelection: some View
    {
        VStack
        {
            ForEach(filteredInstances, id: \.self)
            {
                instance in
                Button(instance)
                {
                    self.instance = instance
                    isEditingInstance = false
                }
            }
            if filteredInstances.count > instanceListMaxSize {
                Text("...")
            }
        }
        .frame(maxWidth: .infinity)
        .padding()
        .background(Color.secondary.opacity(0.1))
    }
    
    /// instances filtered by field input
    var filteredInstances: [String]
    {
        let filtered = instances.filter {
            $0.hasPrefix(instance)
        }
        
        if filtered.count > instanceListMaxSize {
            return Array(filtered[...instanceListMaxSize])
        } else {
            return filtered
        }
    }
    
    /// should we show the instance list
    var shouldShowInstanceList: Bool
    {
        // don't show if instance matches one in the list exactly
        // ...or if the instance string is empty
        // ...or if the instance doesn't match anything in the list
        !(filteredInstances.contains(instance)
            || instance.isEmpty
            || filteredInstances.isEmpty)
    }
}

#Preview {
    LoginView()
}
