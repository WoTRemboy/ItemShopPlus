//
//  JSONParce.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 21.12.2023.
//

import Foundation

extension QuestBundle {
    static func sharingParse(sharingJSON: Any) -> QuestBundle? {
        guard let data = sharingJSON as? [String: Any],
              let tag = data["tag"] as? String,
              let name = data["name"] as? String,
              let image = data["image"] as? String
//              let quests = data["bundles"] as? [String: Any]
        else {
            return nil
        }
//        let quests = data["bundles"] as? [String: Any]
//        var startDate, endDate: Date?
//        let activeDates = quests["activeDates"] as? [String: Any]
//        if let start = activeDates?["start"] as? String, let end = activeDates?["end"] as? String {
//            startDate = dateFormatter.date(from: start)
//            endDate = dateFormatter.date(from: end)
//        }
        
        return QuestBundle(tag: tag, name: name, image: image, startDate: nil, endDate: nil)
    }
}
