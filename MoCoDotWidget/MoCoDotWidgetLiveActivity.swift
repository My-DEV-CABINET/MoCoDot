//
//  MoCoDotWidgetLiveActivity.swift
//  MoCoDotWidget
//
//  Created by 준우의 MacBook 16 on 4/7/24.
//

import ActivityKit
import WidgetKit
import SwiftUI

struct MoCoDotWidgetAttributes: ActivityAttributes {
    public struct ContentState: Codable, Hashable {
        // Dynamic stateful properties about your activity go here!
        var emoji: String
    }

    // Fixed non-changing properties about your activity go here!
    var name: String
}

struct MoCoDotWidgetLiveActivity: Widget {
    var body: some WidgetConfiguration {
        ActivityConfiguration(for: MoCoDotWidgetAttributes.self) { context in
            // Lock screen/banner UI goes here
            VStack {
                Text("Hello \(context.state.emoji)")
            }
            .activityBackgroundTint(Color.cyan)
            .activitySystemActionForegroundColor(Color.black)

        } dynamicIsland: { context in
            DynamicIsland {
                // Expanded UI goes here.  Compose the expanded UI through
                // various regions, like leading/trailing/center/bottom
                DynamicIslandExpandedRegion(.leading) {
                    Text("Leading")
                }
                DynamicIslandExpandedRegion(.trailing) {
                    Text("Trailing")
                }
                DynamicIslandExpandedRegion(.bottom) {
                    Text("Bottom \(context.state.emoji)")
                    // more content
                }
            } compactLeading: {
                Text("L")
            } compactTrailing: {
                Text("T \(context.state.emoji)")
            } minimal: {
                Text(context.state.emoji)
            }
            .widgetURL(URL(string: "http://www.apple.com"))
            .keylineTint(Color.red)
        }
    }
}

extension MoCoDotWidgetAttributes {
    fileprivate static var preview: MoCoDotWidgetAttributes {
        MoCoDotWidgetAttributes(name: "World")
    }
}

extension MoCoDotWidgetAttributes.ContentState {
    fileprivate static var smiley: MoCoDotWidgetAttributes.ContentState {
        MoCoDotWidgetAttributes.ContentState(emoji: "😀")
     }
     
     fileprivate static var starEyes: MoCoDotWidgetAttributes.ContentState {
         MoCoDotWidgetAttributes.ContentState(emoji: "🤩")
     }
}

#Preview("Notification", as: .content, using: MoCoDotWidgetAttributes.preview) {
   MoCoDotWidgetLiveActivity()
} contentStates: {
    MoCoDotWidgetAttributes.ContentState.smiley
    MoCoDotWidgetAttributes.ContentState.starEyes
}
