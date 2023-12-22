//
//  MockData.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.12.2023.
//

import Foundation

struct QuestsMockData {
    
    let firstQuest = Quest(id: "Quest_S28_RebootRally_Rewards_02", name: "Earn 100 Points", enabled: true, enabledDate: nil, parentQuest: nil, xpReward: nil, itemReward: "Holo-Boot Pack", progress: "100", image: "https://media.fortniteapi.io/images/cosmetics/697deb2d0e2ff6abcadaf4c668baafb7/v2/icon_background.png")

    let secondQuest = Quest(id: "Quest_S28_RebootRally_Quest2_05", name: "Stage 5 of 5 - Earn XP with an eligible friend in Battle Royale, Zero Build, Team Rumble, Save the World, or any creator-made experience except those made using UEFN.", enabled: true, enabledDate: nil, parentQuest: nil, xpReward: "5000", itemReward: nil, progress: "400000", image: nil)
    
    func createMock() -> [Quest] {
        let items = [firstQuest, secondQuest]
        return items
    }
}
