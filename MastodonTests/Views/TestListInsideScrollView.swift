//
//  TestListInsideScrollView.swift
//  MastodonTests
//
//  Created by Nathan Wale on 26/1/2024.
//

import SwiftUI

struct TestListInsideScrollView: View 
{
    let list = ["A", "B", "C"]
    
    var body: some View {
        NavigationStack
        {
            List
            {
//                VStack
//                {
                    ForEach(list, id: \.self)
                    {
                        Text($0).font(.title)
                    }
//                }
            }
        }
    }
}

#Preview {
    TestListInsideScrollView()
}
