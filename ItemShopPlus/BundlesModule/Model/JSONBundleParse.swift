//
//  JSONBundleParse.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 19.04.2024.
//

import Foundation

extension BundleItem {
    static func sharingParse(sharingJSON: Any) -> BundleItem? {
        guard let globalData = sharingJSON as? [String: Any],
              let id = globalData["offerId"] as? String,
              let available = globalData["available"] as? Bool,
              available == true,
              let name = globalData["name"] as? String,
              let description = globalData["description"] as? String,
              let descriptionLong = globalData["descriptionLong"] as? String,
              let backgroundImageData = globalData["displayAssets"] as? [[String: Any]],
              let wideImageData = globalData["keyImages"] as? [[String: Any]],
              let pricesData = globalData["prices"] as? [[String: Any]],
              let grantedData = globalData["granted"] as? [[String: Any]],
              let expiryDateString = globalData["expiryDate"] as? String
        else {
            return nil
        }
        
        var priceArray = [BundlePrice]()
        for priceDatum in pricesData {
            guard let code = priceDatum["paymentCurrencyCode"] as? String,
                  let symbol = priceDatum["paymentCurrencySymbol"] as? String,
                  let price = priceDatum["paymentCurrencyAmountNatural"] as? Double
            else {
                return nil
            }
            let type = SelectingMethods.selectCurrency(code: code)
            priceArray.append(BundlePrice(type: type, code: code, symbol: symbol, price: price))
        }
        
        let backgroundImage = backgroundImageData.first?["background"] as? String ?? String()
        let granted = grantedData.compactMap { BundleGranted.sharingParse(sharingJSON: $0) }
        
        let wideImageSet = wideImageData.first(where: { $0["type"] as? String == "OfferImageWide" })
        let wideImage = wideImageSet?["url"] as? String ?? String()

        var expiryDate: Date?
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ssZ"
        
        if let date1 = dateFormatter.date(from: expiryDateString) {
            expiryDate = date1
        }
        
        return BundleItem(id: id, available: available, name: name, description: description, descriptionLong: descriptionLong, backgroundImage: backgroundImage, wideImage: wideImage, expiryDate: expiryDate ?? .now, prices: priceArray, granted: granted)
    }
}


extension BundleGranted {
    static func sharingParse(sharingJSON: Any) -> BundleGranted? {
        guard let globalData = sharingJSON as? [String: Any],
              let id = globalData["templateId"] as? String,
              let quantity = globalData["quantity"] as? Int
        else {
            return nil
        }
        return BundleGranted(id: id, quantity: quantity)
    }
}
