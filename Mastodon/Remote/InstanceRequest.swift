//
//  InstanceRequest.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/12/2023.
//

import Foundation

struct InstanceRequest: ApiRequest
{
    typealias Response = MastodonInstance
    
    var host: String
    let endpoint: Endpoint = .instance
}
