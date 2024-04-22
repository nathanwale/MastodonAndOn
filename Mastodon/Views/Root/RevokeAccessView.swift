//
//  RevokeTokenView.swift
//  Mastodon
//
//  Created by Nathan Wale on 19/4/2024.
//

import SwiftUI

struct RevokeAccessView: View
{
    /// Revocation has finished
    @State var revocationComplete = false
    
    /// Instance host
    let host: String
    
    /// Access token
    let accessToken: AccessToken
    
    /// Revocation request
    var request: RevokeAccessRequest {
        .init(host: host, accessToken: accessToken)
    }
    
    /// Completion closure
    let complete: () -> ()
    
    var body: some View
    {
        if revocationComplete {
            Text("Log out successful")
        } else {
            ProgressView()
                .task {
                    do {
                        try Config.shared.clearLoginDetails()
                        _ = try await request.send()
                    } catch {
                        print(error)
                    }
                    revocationComplete = true
                    complete()
                }
            Text("Logging out...")
        }
    }
}
