//
//  TestOpenUrlView.swift
//  MastodonTests
//
//  Created by Nathan Wale on 28/2/2024.
//

import SwiftUI

struct TestOpenUrlView: View 
{
    let url = URL.viewTag(name: "cats")
    
    var body: some View
    {
        Link(destination: url, label: {
            Text("Link")
        })
        .onOpenURL(perform: { url in
            print(url.absoluteString)
        })
    }
}

#Preview {
    TestOpenUrlView()
}
