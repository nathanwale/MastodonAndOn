//
//  WebSocketSubscription.swift
//  Mastodon
//
//  Created by Nathan Wale on 16/11/2023.
//

import Foundation

struct WebSocketStream
{
    let host: String
    let config: WebSocketStreamConfig
    
    var endpoint: String { "streaming" }
    var pathPrefix: String { "api" }
    var version: String { "v1" }
    var fullPath: String {
        "/\(pathPrefix)/\(version)/\(endpoint)"
    }
    
    
    
    var url: URL? {
        var components = URLComponents()
        components.scheme = "wss"
        components.host = host
        components.path = fullPath
        
        return components.url
    }
    
    var task: URLSessionWebSocketTask?
    
    mutating func open()
    {
        guard let url else { return }
            
        task = URLSession.shared.webSocketTask(with: url)
        guard let task else { return }
        
        task.resume()
//        let message = config.asJson
    }
}

struct WebSocketStreamConfig: Codable
{
    let requestType: RequestType
    let streamType: StreamType
    
    
    enum RequestType: Codable
    {
        case subscribe
        case unsubscribe
    }
    
    enum StreamType: Codable
    {
        case `public`
        case user
        case list
        case direct
    }
    
    var asJson: String
    {
        ""
    }
}
