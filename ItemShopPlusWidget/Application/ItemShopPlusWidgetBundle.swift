//
//  ItemShopPlusWidgetBundle.swift
//  ItemShopPlusWidget
//
//  Created by Roman Tverdokhleb on 7/31/24.
//

import WidgetKit
import SwiftUI

/// The main entry point for the ItemShopPlus widget bundle. This structure defines the available widgets in the bundle
@main
struct ItemShopPlusWidgetBundle: WidgetBundle {
    /// The body property defines the widget that is part of this bundle
    internal var body: some Widget {
        ItemShopPlusWidget()
    }
}
