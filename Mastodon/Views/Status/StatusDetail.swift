//
//  StatusDetail.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/9/2023.
//

import SwiftUI

///
/// View Status content and ancestors and replies
/// - status: The Status to display
/// - context: optional Context to use, otherwise will attempt to fetch from server
///
struct StatusDetail: View
{
    /// The Status to display
    let status: MastodonStatus
    
    /// Optional provided Context
    @State var context: MastodonStatus.Context? = nil
    
    /// Current Status ID
    @Namespace var currentStatusId
    
    /// Instance host
    let host = Config.shared.activeInstanceHost
    
    /// Ancestors: Statuses this Status in reply to
    var ancestors: [MastodonStatus]
    {
        context?.ancestors ?? []
    }
    
    /// Descendants: Replies to this Status
    var descendants: [MastodonStatus]
    {
        context?.descendants ?? []
    }
    
    /// Attempt to fetch Context from remote server
    func fetchContext() async
    {
        let request = StatusContextRequest(
            host: host,
            statusIdentifier: status.id)
        
        do {
            print("Fetching context for StatusID:", status.id!)
            context = try await request.send()
        } catch {
            print(error)
        }
    }
       
    // MARK: - subviews
    /// Main view
    var body: some View
    {
        ScrollViewReader
        {
            scrollProxy in
            ScrollView
            {
                VStack
                {
                    // Ancestors
                    statusList(ancestors)
                    
                    // Prior label
                    if !ancestors.isEmpty {
                        indicator("Prior", icon: .chevronUp)
                    }
                    
                    // Post
                    StatusPost(status)
                        .id(currentStatusId)
                        .padding(0)
                        .padding(.top, 10)
                    
                    // Replies label
                    if !descendants.isEmpty {
                        indicator("Replies", icon: .chevronDown)
                    }
                    
                    // Descendants
                    statusList(descendants)
                }
                .navigationTitle("Post by \(status.account.displayName)")
                .onAppear {
                    scrollProxy.scrollTo(currentStatusId, anchor: .top)
                }
            }
        }
        .task {
            if context == nil {
                await fetchContext()
            }
        }
    }
    
    /// Prior or Replies indicator
    func indicator(_ text: String, icon: Icon) -> some View
    {
        HStack
        {
            Spacer()
            icon.image
            Text(text).font(.headline)
                .padding(5)
            icon.image
            Spacer()
        }
        .foregroundColor(.white)
        .background(Color.secondary)
    }
    
    /// A list of Statuses
    func statusList(_ statuses: [MastodonStatus]) -> some View
    {
        VStack
        {
            ForEach(statuses)
            {
                StatusPost($0)
            }
        }
    }
}


// MARK: - previews
#Preview("With context")
{
    StatusDetail(
        status: MastodonStatus.preview,
        context: MastodonStatus.previewContext
    )
}

#Preview("Without context")
{
    StatusDetail(
        status: MastodonStatus.preview
    )
}
