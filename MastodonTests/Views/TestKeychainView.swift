//
//  TestKeychainView.swift
//  MastodonTests
//
//  Created by Nathan Wale on 9/1/2024.
//

import SwiftUI

struct TestKeychainView: View 
{
    
    var accessToken: String? {
        try? KeychainToken.accessToken.retrieve()
    }
    
    var testKeychainToken: KeychainToken {
        KeychainToken(identifier: "test-view-token")
    }
    
    @State var testToken: String = ""
    @State var testTokenMessage = "Waiting..."
    @State var testTokenLoaded = false
    @State var tokenFieldValue = ""
    
    var body: some View
    {
        VStack(alignment: .leading)
        {
            Text("Keychain test")
                .font(.title)
            
            Divider()
            
            Text("Access token:")
                .font(.headline)
            if let accessToken {
                Text(accessToken)
            } else {
                Text("Token unavailable")
                    .italic()
            }
            
            Divider()
                .padding(.top, 20)
            
            Text("Custom test token:")
                .font(.headline)
            Text(testTokenMessage)
            if testTokenLoaded {
                Text(testToken).monospaced()
            }
            
            TextField("New token text", text: $tokenFieldValue)
                .textInputAutocapitalization(.never)
            HStack
            {
                Spacer()
                Button(testTokenLoaded ? "Update" : "Insert")
                {
                    updateTestToken()
                }
                .buttonStyle(.borderedProminent)
            }
        }
        .padding()
        .textFieldStyle(.roundedBorder)
        .onAppear(perform: retrieveTestToken)
    }
    
    func updateTestToken()
    {
        do {
            try testKeychainToken.update(tokenFieldValue)
            print("Updated token...")
            retrieveTestToken()
        } catch {
            print("Error storing test token: \(error)")
        }
    }
    
    func retrieveTestToken()
    {
        if let retrievedToken = try? testKeychainToken.retrieve() {
            testToken = retrievedToken
            tokenFieldValue = testToken
            testTokenMessage = "Retrieved token"
            testTokenLoaded = true
            print("Retrieved token:", testToken)
        } else {
            testTokenMessage = "No token on keychain"
        }
    }
}

#Preview {
    TestKeychainView()
}
