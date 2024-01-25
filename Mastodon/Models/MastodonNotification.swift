//
//  MastodonNotification.swift
//  Mastodon
//
//  Created by Nathan Wale on 20/1/2024.
//

import Foundation

struct MastodonNotification: Codable, Identifiable
{
    typealias Identifier = String
    
    enum NotificationType: String, Codable
    {
        case mention = "mention"
        case status = "status"
        case reblog = "reblog"
        case follow = "follow"
        case followRequest = "follow_request"
        case favourite = "favourite"
        case poll = "poll"
        case update = "update"
    }
    
    let id: Identifier
    let type: NotificationType
    let createdAt: Date
    let account: MastodonAccount
    let status: MastodonStatus?
}
