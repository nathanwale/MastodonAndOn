//
//  StatusList.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/9/2023.
//

import SwiftUI

///
/// The default list of statuses, navigable to view replies, etc.
///
struct StatusList: View
{
    /// Statuses to display
    @StateObject var source: StatusSource
    
    /// App Navigation
    @EnvironmentObject private var navigation: AppNavigation
    
    /// Should we be able to scroll through list?
    var scrollable = true
    
    /// Insets for Status Posts
    let statusInsets = EdgeInsets(
        top: 10,
        leading: 0,
        bottom: 20,
        trailing: 0
    )
        
    /// Body
    var body: some View
    {
        NavigationStack(path: $navigation.path)
        {
            List(source.statuses)
            {
                status in
                
                // Show status
                StatusPost(status)
                    .listRowSeparator(.hidden)
                    .listRowInsets(statusInsets)
                    // colour and event to update focused status
                    .background(background(status: status))
            }
            // apply `scrollable`
            .scrollDisabled(!scrollable)
            // List styling
            .listStyle(.plain)
            .buttonStyle(.borderless)
            // Pass on navigation object
            .environmentObject(navigation)
            // Configure navigation
            .navigationDestination(for: MastodonStatus.self) {
                status in
                StatusDetail(status: status)
            }
            // Load source of Statuses
            .task {
                await loadStatusesIfRequired()
            }
        }
    }
    
    /// background colour and event to update focused status
    func background(status: MastodonStatus) -> some View
    {
        // need to read the geometry to tell which post
        // is in the middle of the screen
        GeometryReader
        {
            geo in
            
            // background colour for focused status
            let bgColour = (status == source.focusedStatus)
                ? Color.teal.opacity(0.1)
                : Color.clear
            
            // assign colour and set up event
            Color(bgColour)
                .onChange(of: geo.frame(in: .global).midY)
            {
                let midY = geo.frame(in: .global).midY
                let screenHeight = UIScreen.main.bounds.height
                let screenMidY = screenHeight / 2
                let threshold: CGFloat = screenHeight / 10
                let isInMiddle = (midY > screenMidY - threshold)
                                    && (midY < screenMidY + threshold)
                if isInMiddle {
                    source.focusedStatus = status
                    Task {
                        await loadStatusesIfRequired()
                    }
                }
            }
        }
    }
    
    /// Load Statuses if required
    func loadStatusesIfRequired() async
    {
        do {
            try await source.balance()
        } catch {
            print(error)
        }
    }
}


// MARK: - previews

struct Preview_StatusList: View
{
    var statuses: [MastodonStatus] = []
    var request: any MastodonStatusRequest = MockRequestApi()
    
    var source: StatusSource
    {
        .init(statuses: statuses, request: request)
    }
    
    var body: some View
    {
        StatusList(source: source)
            .environmentObject(AppNavigation())
    }
}

#Preview("Sample posts") 
{
    Preview_StatusList(statuses: MastodonStatus.previews)
}

#Preview("Online user posts")
{
    Preview_StatusList(request: UserTimelineRequest.sample)
}

#Preview("Online public timeline")
{
    Preview_StatusList(request: PublicTimelineRequest.sample)
}

#Preview("Home feed, authorised")
{
    Preview_StatusList(request: HomeTimelineRequest.sample)
}

#Preview("Home feed, unauthorised")
{
    Preview_StatusList(request: HomeTimelineRequest.sampleUnauthorised)
}

#Preview("Isolated post") 
{
    let statusId = "110879987501995566"
    let statuses = MastodonStatus.previews.filter { $0.id == statusId}
    return Preview_StatusList(statuses: statuses)
}
