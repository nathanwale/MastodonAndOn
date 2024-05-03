//
//  StatusList.swift
//  Mastodon
//
//  Created by Nathan Wale on 27/9/2023.
//

import SwiftUI

///
/// A view that takes a Request object to fetch and display a list of Statuses
///  - request: A request object to fetch statuses from a server
///
struct StatusListRequestView: View
{
    ///  A request object to fetch statuses from a server
    var request: any MastodonStatusRequest
    
    /// An error, if one occurs
    @State var error: Error?
    
    /// The list of statuses to display, once fetched
    @State var statuses: [MastodonStatus]?
    
    /// Fetch Statuses from request
    func fetchStatuses() async
    {
        do {
            print("Fetching statuses...")
            statuses = try await request.send()
        } catch {
            print(error.localizedDescription)
            self.error = error
        }
    }
    
    /// Fetch additional Statuses
    func fetchMore() async
    {
        // Ensure last status
        guard
            let statuses,
            let lastStatus = statuses.last
        else {
            return
        }
        
        do {
            print("Fetching more statuses...")
            let newStatusRequest = request.after(lastStatus)
            let newStatuses = try await newStatusRequest.send()
            self.statuses = statuses + newStatuses
        } catch {
            print(error.localizedDescription)
            self.error = error
        }
    }
    
    /// Main view
    var body: some View
    {
        if let statuses {
            // Statuses have been fetched, show them
            StatusList(statuses: statuses) {
                await fetchMore()
            }
            .refreshable {
                self.statuses = nil
            }
        } else if let error {
            // Fetching statuses has produced an error, display
            errorMessage(error)
        } else {
            // By default, show activity indicator, and fetch statuses
            activityIndicator
                .task {
                    await fetchStatuses()
                }
        }
    }
    
    /// Activity indicator
    var activityIndicator: some View
    {
        VStack
        {
            Text("Fetching Statuses...")
            ProgressView()
        }
    }
    
    /// Error message
    func errorMessage(_ error: Error) -> some View
    {
        VStack
        {
            Text("Couldn't fetch statuses")
                .font(.title)
            Text(error.localizedDescription)
        }
    }
}

///
/// The default list of statuses, navigable to view replies, etc.
///
struct StatusList: View
{
    /// Statuses to display
    let statuses: [MastodonStatus]
    
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
    
    /// End of scroll callback
    let onEndOfScroll: () async -> ()
        
    /// Body
    var body: some View
    {
        ScrollView
        {
            LazyVStack()
            {
                ForEach(statuses)
                {
                    status in
                    
                    // Show status
                    StatusPost(status)
                        .listRowSeparator(.hidden)
                        .listRowInsets(statusInsets)
                        .scrollTargetLayout()
                        .padding(.top, 20)
                }
                ProgressView()
                    .onAppear {
                        Task {
                            await onEndOfScroll()
                        }
                    }
            }
        }
        // apply `scrollable`
        .scrollDisabled(!scrollable)
        .buttonStyle(.borderless)
    }
}


// MARK: - previews

#Preview("Sample posts") 
{
    StatusList(statuses: MastodonStatus.previews) {
        print("Load more...")
    }
}

#Preview("Online user posts")
{
    StatusListRequestView(request: UserTimelineRequest.sample)
}

#Preview("Online public timeline")
{
    StatusListRequestView(request: PublicTimelineRequest.sample)
}

#Preview("Home feed, authorised")
{
    StatusListRequestView(request: HomeTimelineRequest.sample)
}

#Preview("Home feed, unauthorised")
{
    StatusListRequestView(request: HomeTimelineRequest.sampleUnauthorised)
}

#Preview("Isolated post") 
{
    let statusId = "110879987501995566"
    let statuses = MastodonStatus.previews.filter { $0.id == statusId}
    return StatusList(statuses: statuses) {
        print("Load more...")
    }
}

#Preview("Hashtag timeline")
{
    StatusListRequestView(request: HashtagTimelineRequest.sample)
}
