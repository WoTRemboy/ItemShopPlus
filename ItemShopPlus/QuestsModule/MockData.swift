//
//  MockData.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 09.12.2023.
//

import Foundation

let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSZ"
    return formatter
}()

func differenceBetweenDates(date1: Date, date2: Date) -> String {
    let calendar = Calendar.current
    
    let components = calendar.dateComponents([.weekOfMonth ,.day, .hour, .minute], from: date1, to: date2)
    
    if let weeks = components.weekOfMonth, let days = components.day, let hours = components.hour, let minutes = components.minute {
        return String(format: "%01dW %01dD %02dH %02dM", weeks, days, hours, minutes)
    }
    return "Time diff error..."
}

struct BundleMockData {
    
    let milestonesBundle = QuestBundle(tag: "Here", name: "Milestones", image: "https://media.fortniteapi.io/images/displayAssets/reward_milestone_quest_complete_copy.png", startDate: nil, endDate: nil)

    let rebootRallyBundle = QuestBundle(tag: "QuestCategory.BR.S28.RebootRally", name: "Reboot Rally", image: "https://media.fortniteapi.io/images/displayAssets/T_UI_ChallengeTile_RebootRally.png", startDate: dateFormatter.date(from: "2023-12-03T08:00:00.000Z"), endDate: dateFormatter.date(from: "2024-01-09T14:00:00.000Z"))
    
    func createMock() -> [QuestBundle] {
        let items = [milestonesBundle, rebootRallyBundle]
        return items
    }
}

struct QuestsMockData {
    
    let firstQuest = Quest(id: "Quest_S28_RebootRally_Rewards_02", name: "Earn 100 Points", enabled: true, enabledDate: nil, parentQuest: nil, progress: "100", image: "https://media.fortniteapi.io/images/cosmetics/697deb2d0e2ff6abcadaf4c668baafb7/v2/icon_background.png")

    let secondQuest = Quest(id: "Quest_S28_RebootRally_Quest2_05", name: "Stage 5 of 5 - Earn XP with an eligible friend in Battle Royale, Zero Build, Team Rumble, Save the World, or any creator-made experience except those made using UEFN.", enabled: true, enabledDate: nil, parentQuest: nil, progress: "400000", image: nil)
    
    func createMock() -> [Quest] {
        let items = [firstQuest, secondQuest]
        return items
    }
}
