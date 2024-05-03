//
//  UserProfileView.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import SwiftUI

struct UserProfileRequestView: View 
{
    /// Request to fetch user
    let userRequest: any AccountRequest
    
    /// Banner height
    let bannerHeight = 200

    /// Account when fetched, else nil
    @State var user: MastodonAccount?
    
    /// Error message if error, else nil
    @State var error: (any Error)?
    
    /// Logout callback
    let logout: () -> ()
    
    /// Fetch user
    func fetchUser() async
    {
        do {
            user = try await userRequest.send()
        } catch {
            self.error = error
            print(error.localizedDescription)
        }
    }
    
    var body: some View
    {
        if let user {
            // Our user object is ready, so display the profile view
            UserProfileView(user: user, host: userRequest.host, logout: logout)
        } else if error != nil {
            // We have an error, so display error info
            errorInfoView
        } else {
            // Nothing's happened yet,
            // so show some waiting text and begin fetching user
            requestWaitingView
                .task {
                    await fetchUser()
                }
        }
    }
    
    /// Request waiting view
    var requestWaitingView: some View
    {
        Text("Fetching user info...")
    }
    
    /// Error info view
    var errorInfoView: some View
    {
        VStack
        {
            Text("Couldn't fetch user info")
                .font(.title)
            Text(error?.localizedDescription ?? "")
        }
    }
}

struct UserProfileView: View 
{
    /// Account to display
    let user: MastodonAccount
    
    /// Instance host
    let host: String
    
    /// Status request
    var statusRequest: any MastodonStatusRequest {
        UserTimelineRequest(host: host, userid: user.id, accessToken: nil)
    }
    
    /// Status Source
    var statusSource: StatusSource {
        .init(statuses: [], request: statusRequest)
    }
    
    /// User Statuses
    @State var statuses: [MastodonStatus] = []
    
    /// Display confirm logout dialogue
    @State var showingLogoutConfirmation = false
    
    /// Logout callback
    let logout: () -> ()
    
    /// Fetch user statuses
    func fetchStatuses() async
    {
        do {
            statuses = try await statusRequest.send()
        } catch {
            print(error)
        }
    }
    
    
    // MARK: - subviews
    // Body
    var body: some View
    {
        VStack
        {
            // banner image doesn't scroll
            bannerImage
            
            // ... rest of the profile does
            ScrollView
            {
                VStack(alignment: .leading)
                {
                    logoutButton
                    nameHeader
                    Divider()
                    profileNote
                    statistics
                    fields
                    statusList
                }
            }
        }
        // Allow banner image to extend into top
        .ignoresSafeArea(.all, edges: .top)
        .task {
            if statuses.isEmpty {
                await fetchStatuses()
            }
        }
    }
    
    // Display name and account ID
    var nameHeader: some View
    {
        HStack(alignment: .bottom, spacing: 20)
        {
            avatarImage
            VStack(alignment: .leading)
            {
                Text(user.displayName)
                    .font(.title)
                Text("@\(user.acct)")
            }
        }
        .padding()
    }
    
    // Date created and post count, etc.
    var statistics: some View
    {
        HStack
        {
            // Date joined
            VStack(alignment: .leading)
            {
                let joinDate = user.createdAt.relativeFormatted
                Text("Joined")
                Text(joinDate)
            }
            
            Spacer()
            
            // Separator
            Divider()
            
            // Stats
            stat(value: user.statusesCount, label: "Statuses")
            stat(value: user.followersCount, label: "Followers")
            stat(value: user.followingCount, label: "Following")
        }
        .padding()
        .background(.secondary.opacity(0.25))
    }
    
    // Display a stat with a label
    func stat(value: Int, label: String) -> some View
    {
        VStack
        {
            Text(label)
                .font(.caption2)
            Text(String(value))
                .font(.title)
        }
    }
    
    // Account fields
    var fields: some View
    {
        VStack
        {
            ForEach(user.fields, id: \.name)
            {
                field in
                HStack
                {
                    Text(field.name)
                        .font(.headline)
                    Spacer()
                    CustomEmojiText(html: field.value, emojis: user.emojis)
                }
            }
        }
        .padding()
        .background(.secondary.opacity(0.25))
    }
    
    // Banner image
    var bannerImage: some View
    {
        WebImage(url: user.header)
            .frame(height: 200)
            .scaledToFill()
    }
    
    // Profile pic
    var avatarImage: some View
    {
        ProfileImage(url: user.avatar, size: .feature)
    }
    
    // Profile note
    var profileNote: some View
    {
        CustomEmojiText(html: user.note,
                        emojis: user.emojis)
            .font(.headline)
            .padding()
    }
    
    // User statuses
    var statusList: some View
    {

        VStack
        {
            ForEach(statuses)
            {
                status in
                StatusPost(status)
                    .padding(.top, 20)
            }
        }
    
    }
    
    // Logout button
    var logoutButton: some View
    {
        HStack
        {
            Spacer()
            Button {
                showingLogoutConfirmation = true
            } label: {
                Text("Logout")
                Icon.logout.image
            }
            .buttonStyle(.bordered)
            .padding(.trailing, 5)
        }
        .confirmationDialog(
            "Are you sure you want to log out?",
            isPresented: $showingLogoutConfirmation,
            titleVisibility: .visible) {
                Button {
                    logout()
                } label: {
                    Text("Log out")
                    Icon.logout.image
                }
            }
    }
}


// MARK: - previews
#Preview {
    UserProfileView(
        user: MastodonAccount.sample,
        host: MastodonInstance.defaultHost
    ) {
        print("Logged out")
    }
}
