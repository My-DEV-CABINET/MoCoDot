//
//  MoCoDotWidgetBundle.swift
//  MoCoDotWidget
//
//  Created by 준우의 MacBook 16 on 4/7/24.
//

import WidgetKit
import SwiftUI

@main
struct MoCoDotWidgetBundle: WidgetBundle {
    var body: some Widget {
        MoCoDotWidget()
        MoCoDotWidgetLiveActivity()
    }
}
