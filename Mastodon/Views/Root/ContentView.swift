//
//  ContentView.swift
//  Mastodon
//
//  Created by Nathan Wale on 7/9/2023.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        UserLoginView(host: MastodonInstance.defaultHost)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
