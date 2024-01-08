//
//  MockData.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 07.01.2024.
//

import UIKit

class MockData {
    
    let alien = ShopModel(id: "CID_A_025_Athena_Commando_M_Kepler_UEN6V", name: "Xenomorph", description: "If you see it coming, it's already too late.", type: "Outfit", image: "https://media.fortniteapi.io/images/shop/72bba71693760f695398b1cfd05a6c3b269298cb8ad9150b82788a60ece016bf/v2/MI_CID_A_025_M_Kepler/background.png", firstReleaseDate: nil, previousReleaseDate: nil, buyAllowed: true, price: 1600, rarity: "Epic")
    
    let ripley = ShopModel(id: "CID_A_026_Athena_Commando_F_Kepler_2G59M", name: "Ellen Ripley", description: "Last survivor of the Nostromo.", type: "Outfit", image: "https://media.fortniteapi.io/images/shop/9f614f032deed4fb3ec7e00aef5cc32e076554019296622bed7d54b944e84cb9/v2/MI_CID_A_026_F_Kepler/background.png", firstReleaseDate: nil, previousReleaseDate: nil, buyAllowed: true, price: 1500, rarity: "Epic")
    
    let yennefer = ShopModel(id: "Character_FishBowl", name: "Yennefer of Vengerberg", description: "Powerful sorceress who walks her own path.", type: "Outfit", image: "https://media.fortniteapi.io/images/shop/e5a58cbfdd038fecc1499d21e2b36020e3e9a80216b2faa04c71ef0494dd56f8/v2/MI_Character_FishBowl/background.png", firstReleaseDate: nil, previousReleaseDate: nil, buyAllowed: true, price: 1500, rarity: "Epic")
    
    func configMock() -> [ShopModel] {
        let items = [alien, ripley, yennefer]
        return items
    }
}
