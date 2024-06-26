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
    
    /// Display confirm logout dialogue
    @State var showingLogoutConfirmation = false
    
    /// Logout callback
    let logout: () -> ()
        
    
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
                    if !user.fields.isEmpty {
                        fields
                    }
                    
                    // User Statuses
                    StatusListRequestView(request: statusRequest, scrollable: false)
                }
            }
        }
        // Allow banner image to extend into top
        .ignoresSafeArea(.all, edges: .top)
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
                .padding(.trailing, 10)
            
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
            Text(readableStatLabel(value: value))
                .font(.headline)
        }
    }
    
    /// Stat count label: 1.2K, 3.2M, etc.
    func readableStatLabel(value: Int) -> String
    {
        // Formatter
        let formatter = NumberFormatter()
        if value > 1_000_000 {
            formatter.maximumSignificantDigits = 3
            let number = formatter.string(from: Double(value) / 1_000_000.0 as NSNumber) ?? "000"
            return "\(number)M"
        } else if value > 10_000 {
            formatter.maximumSignificantDigits = 3
            let number = formatter.string(from: Double(value) / 1000.0 as NSNumber) ?? "000"
            return "\(number)K"
        } else {
            formatter.groupingSize = 3
            formatter.usesGroupingSeparator = true
            return formatter.string(from: value as NSNumber) ?? "000"
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
            .scaledToFill()
            .frame(height: 200)
            .clipped()
            .opacity(0.5)
            .background {
                Color.black
            }
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
#Preview("@nwale") {
    UserProfileView(
        user: MastodonAccount.sample,
        host: MastodonInstance.defaultHost
    ) {
        print("Logged out")
    }
}

#Preview("@ComicContext") {
    let request = AccountRequestByIdentifier(identifier: "109245238866201828", host: "mstdn.social")
    
    return UserProfileRequestView(userRequest: request) {
        print("Logged out")
    }
}
