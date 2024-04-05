//
//  SelectInstanceView.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/12/2023.
//

import SwiftUI

struct SelectInstanceView: View 
{
    @State var host = Config.shared.activeInstanceHost
    @State var isEditingHost = false
    @State var connectionState = ConnectionState.untried
    @State var connectedInstance: MastodonInstance? = nil
    
    let instances = MastodonInstance.defaultHosts
    
    /// Most instances to display in list
    let instanceListMaxSize = 20
    
    var body: some View
    {
        VStack(spacing: 20)
        {
            instanceInput
            if shouldShowInstanceList {
                instanceSelection
            }
            ConnectionStatusView(
                state: connectionState,
                host: host,
                instance: connectedInstance)
            {
                await initiateConnection()
            }
        }
        .padding()
        .background(Color.secondary.opacity(0.1))
    }
    
    /// Combined free input and list selection for instances
    var instanceInput: some View
    {
        VStack(alignment: .leading)
        {
            Text("Choose instance server")
                .font(.caption.smallCaps())
            TextField("Server", text: $host)
                .textFieldStyle(.roundedBorder)
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                .onChange(of: host) {
                    isEditingHost = true
                    connectionState = .untried
                }
        }
    }
    
    var arrow: some View
    {
        let size = 20.0
        let path = Path
            {
                path in
                path.move(to: .init(x: size / 2, y: 0.0))
                path.addLine(to: .init(x: size, y: size / 2))
                path.addLine(to: .init(x: 0.0, y: size / 2))
                path.closeSubpath()
            }
            .fill(Color.secondary.opacity(0.1))
        
        return Rectangle()
            .foregroundColor(Color.clear)
            .background(path)
            .frame(width: size, height: size / 2)
    }
    
    /// Server instance selector
    var instanceSelection: some View
    {
        // arrow and list
        VStack(spacing: 0.0)
        {
            arrow
            // list
            VStack
            {
                ForEach(truncatedInstanceList, id: \.self)
                {
                    instance in
                    Button(instance)
                    {
                        self.host = instance
                        isEditingHost = false
                    }
                }
                if shouldTruncateList {
                    let difference = filteredInstances.count - truncatedInstanceList.count
                    Text("⋯")
                        .foregroundStyle(.secondary)
                    Text("(plus \(difference) more)")
                        .font(.caption.italic())
                        .foregroundStyle(.secondary)
                }
            }
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.secondary.opacity(0.1))
        }
        .padding(0)
    }
    
    /// should we truncate the list?
    var shouldTruncateList: Bool
    {
        filteredInstances.count > instanceListMaxSize
    }
    
    /// instances filtered by field input
    var filteredInstances: [String]
    {
        instances.filter {
            $0.hasPrefix(host)
        }
    }
    
    /// truncated list if too long
    var truncatedInstanceList: [String]
    {
        shouldTruncateList
            ? Array(filteredInstances[...instanceListMaxSize])
            : filteredInstances
    }
    
    
    /// should we show the instance list
    var shouldShowInstanceList: Bool
    {
        // don't show if instance matches one in the list exactly
        // ...or if the instance string is empty
        // ...or if the instance doesn't match anything in the list
        !(filteredInstances.contains(host)
            || host.isEmpty
            || filteredInstances.isEmpty)
    }
}


// MARK: - actions
extension SelectInstanceView
{
    func initiateConnection() async
    {
        connectionState = .waiting
        print("Connecting to \(host)...")
        let request = InstanceRequest(host: host)
        do {
            connectedInstance = try await request.send()
            print("Connected to instance '\(connectedInstance!.title)'")
            connectionState = .success
        } catch {
            print(error)
            connectionState = .failure
        }
    }
}


// MARK: - inner types
extension SelectInstanceView
{
    enum ConnectionState
    {
        case untried
        case waiting
        case success
        case failure
    }
}


// MARK: - previews
#Preview
{
    SelectInstanceView()
}
