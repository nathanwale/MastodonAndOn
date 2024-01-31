//
//  PollView.swift
//  Mastodon
//
//  Created by Nathan Wale on 30/1/2024.
//

import SwiftUI

struct PollView: View 
{
    let poll: MastodonPoll
    let text: String
    var emojis: [MastodonCustomEmoji] = []
    let barColour = Color.blue
    let barHeight = 25.0
    
    @State var viewWidth = 300.0
    
    var body: some View
    {
        GeometryReader {
            geo in
            VStack(alignment: .leading)
            {
                CustomEmojiText(html: text, emojis: emojis)
                options
                Spacer()
            }
            .onAppear {
                viewWidth = geo.size.width
            }
        }
    }
    
    // options
    var options: some View
    {
        VStack(alignment: .leading)
        {
            let total = Double(poll.votesCount)
            ForEach(poll.options, id: \.title)
            {
                option in
                let votes = Double(option.votesCount ?? 0)
                let percentage = (votes / total)
                optionView(option, percentage: percentage)
            }
        }
    }
    
    // display bar graph for option
    func optionView(_ option: MastodonPoll.Options, percentage: Double) -> some View
    {
            HStack(alignment: .top)
            {
                // widths
                let labelWidth = viewWidth * 0.33
                let graphWidth = viewWidth - labelWidth
                
                // label
                Text(option.title)
                    .frame(width: labelWidth)
                    .background(.yellow.opacity(0.25))
                    .multilineTextAlignment(.leading)
                
                
                // bar graph
                barGraph(percentage: percentage, width: graphWidth)
            }
    }
    
    // bar graph for percentage
    func barGraph(percentage: Double, width: Double) -> some View
    {
        ZStack(alignment: .leading)
        {
            let formattedPercentage = percentage.formatted(.percent.precision(.fractionLength(1)))
            barShape(percentage: percentage, width: width)
            Text("\(formattedPercentage)")
                .colorInvert()
                .padding(.leading)
        }
        .frame(width: width, height: barHeight)
    }
    
    // the actual bar of the bar graph
    func barShape(percentage: Double, width: Double) -> some View
    {
        ZStack(alignment: .leading)
        {
            let cornerRadius = 5.0
            let cornerSize = CGSize(width: cornerRadius, height: cornerRadius)

            // Full background bar
            RoundedRectangle(cornerSize: cornerSize)
                .foregroundStyle(barColour.opacity(0.25))
            
            // Graph bar
            let graphWidth = width * percentage
            RoundedRectangle(cornerSize: cornerSize)
                .foregroundStyle(barColour)
                .frame(width: graphWidth)
        
        }
    }
}


// MARK: - previews
#Preview
{
    VStack
    {
        PollView(poll: .sample, text: "Do you accept these terms?")
        Spacer()
        
        let poll = MastodonPoll(
            id: "0",
            expired: false, 
            multiple: true,
            votesCount: 100,
            options: [
                .init(title: "This one has some longer text, what happens if it wraps?", votesCount: 20),
                .init(title: "This one doesn't", votesCount: 50),
                .init(title: "But now we're back to long text. Break! Break the oppression of the layout! The text must wrap!", votesCount: 30)
            ],
            emojis: .samples)
        
        PollView(
            poll: poll,
            text: "We need to check longer poll options, and titles with emoji. :hotboi:",
            emojis: .samples)
    }
    .padding()
}
