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
    
    // Body
    var body: some View
    {
        VStack
        {
            bannerImage
            
            VStack(alignment: .leading)
            {
                VStack(alignment: .leading)
                {
                    nameHeader
                    Divider()
                    profileNote
                    statistics
                    fields
                    statuses
                }
            }
            .padding()
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
    }
    
    // Date created and post count, etc.
    var statistics: some View
    {
        HStack
        {
            VStack(alignment: .leading)
            {
                let joinDate = user.createdAt.relativeFormatted
                Text("Joined")
                Text(joinDate)
            }
            Spacer()
            Text("/")
                .font(.title)
                .foregroundStyle(.secondary.opacity(0.5))
            stat(value: user.statusesCount, label: "Statuses")
            stat(value: user.followersCount, label: "Followers")
            stat(value: user.followingCount, label: "Following")
        }
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
                    HtmlView(html: field.value)
                }
            }
        }
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
        CustomEmojiText(user.note,
                        emojis: user.emojis)
    // User statuses
    var statuses: some View
    {
        StatusList(source: statusSource)
            .scrollDisabled(true)
            .scrollClipDisabled()
    }
}

#Preview {
    UserProfileView(user: MastodonAccount.sample, host: MastodonInstance.defaultHost)
        .environmentObject(AppNavigation())
}
