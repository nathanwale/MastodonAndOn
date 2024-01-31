//
//  UserProfileView.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/1/2024.
//

import SwiftUI

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
    
    /// App Navigation
    @EnvironmentObject private var navigation: AppNavigation
    
    // Body
    var body: some View
    {
        VStack
        {
            bannerImage
            
            NavigationStack(path: $navigation.path)
            {
                ScrollView
                {
                    VStack(alignment: .leading)
                    {
                        nameHeader
                        Divider()
                        profileNote
                        statistics
                        fields
                        statusList
                    }
                }
            }
        }
        .ignoresSafeArea()
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
            }
        }
    
    }
}

#Preview {
    UserProfileView(user: MastodonAccount.sample, host: MastodonInstance.defaultHost, statuses: MastodonStatus.previews)
        .environmentObject(AppNavigation())
}
