//
//  Labels.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

final class Texts {
    
    // MARK: - Common
    
    enum CommonElements {
        static let headerIdentifier = "HeaderReusableView"
    }
    
    enum CollectionCell {
        static let identifier = "CollectionRarityCell"
    }
    
    enum Navigation {
        static let cancel = "Cancel"
        static let done = "Done"
        static let backToMain = "Main"
        static let backToShop = "Shop"
        static let backToPass = "Pass"
        static let backToBundles = "Bundles"
    }
    
    enum SearchController {
        static let result = "Result"
        static let noResult = "No result"
    }
    
    enum Season {
        static let beginDate = "2023-12-03T08:00:00.000Z"
        static let endDate = "2024-03-08T02:00:00.000Z"
    }
    
    enum Placeholder {
        static let noText = "Something wrong..."
    }
    
    enum noConnection {
        static let noInternet = "No connection"
        static let retry = "Please, retry later"
    }
    
    enum Rarity {
        static let common = "Common"
        static let uncommon = "Uncommon"
        static let rare = "Rare"
        static let epic = "Epic"
        static let legendary = "Legendary"
        static let mythic = "Mythic"
        static let star = "Star"
        static let transcendent = "Transcendent"
        static let exotic = "Exotic"
    }
    
    enum Currency {
        enum Code {
            static let usd = "USD"
            static let eur = "EUR"
            static let gbp = "GBP"
            static let cad = "CAD"
            static let rub = "RUB"
            static let dkk = "DKK"
            static let jpy = "JPY"
            static let sek = "SEK"
            static let brl = "BRL"
            static let nok = "NOK"
            static let aud = "AUD"
            static let lira = "TRY"
            static let aed = "AED"
            static let qar = "QAR"
            static let sar = "SAR"
        }
        enum Symbol {
            static let usd = "$"
            static let eur = "€"
            static let gbp = "£"
            static let cad = "$"
            static let rub = "₽"
            static let dkk = "kr"
            static let jpy = "¥"
            static let sek = "kr"
            static let brl = "R$"
            static let nok = "kr"
            static let aud = "$"
            static let lira = "₺"
        }
    }
    
    // MARK: - Main Module
    
    enum ButtonLabels {
        enum MainButtons {
            static let shop = "Item Shop"
            static let bundles = "Bundles"
            static let battlePass = "Battle Pass"
            static let lootDetails = "Loot Details"
            static let crew = "Crew"
            static let map = "Map"
            static let stats = "Stats"
            static let augments = "Augments"
            static let settings = "Settings"
        }
    }
    
    enum Pages {
        static let main = "Fort Satellite"
        static let quests = "Quests"
        static let quest = "Quest"
        static let details = "Details"
        static let shop = "Item Shop"
    }
    
    // MARK: - Cache Module
    
    enum ClearCache {
        static let message = "All media used in the app will remain in the cloud and will be re-downloaded when needed"
        static let cache = "Clear Entire Cache"
        static let megabytes = "MB"
        static let cancel = "Cancel"
        
        static let oops = "Oops!"
        static let alreadyClean = "The cache is already clean."
        static let success = "Success"
        static let cleared = "The cache has been cleared."
        static let ok = "OK"
    }
    
    // MARK: - Shop Module
    
    enum ShopPage {
        static let itemName = "Item name..."
        static let itemPrice = "Item price..."
        static let bundleName = "Bundle name..."
        static let segmentName = "Segment name..."
        static let allMenu = "All"
        static let rotaionTitle = "Shop Info"
        static let rotationInfo = "The shop refreshes every day. Check back to see what's new!"
        static let reloadShop = "It's time to update!"
        static let remaining = "Remaining time"
        static let jamTracks = "Jam Tracks"
    }
    
    enum ShopMainCell {
        static let identifier = "ShopCollectionViewCell"
        static let vBucks = " VBucks"
        static let search = "Search items"
    }
    
    enum ShopGrantedCell {
        static let footerIdentifier = "ShopGrantedCollectionReusableView"
        static let firstTime = "First time..."
        static let lastTime = "Last time..."
        static let total = "Total"
        static let price = "Bundle price..."
        static let title = "Title..."
        static let content = "Content..."
    }
    
    enum ShopGrantedParameters {
        static let descriprion = "Descriprion"
        static let series = "Series"
        static let firstTime = "First release"
        static let lastTime = "Previous release"
        static let descriptionData = "Descriprion..."
        static let seriesData = "Series..."
        static let firstTimeData = "First release..."
        static let lastTimeData = "Previous release..."
    }
    
    enum ShopTimer {
        static let whatMeans = "What is: "
        static let swipeInfo = "Swipe over the cell image to see more variations!"
        static let countInfo = "Number of elements in the item bundle."
        static let aboutRotation = "About rotation"
        static let rotationInfo = "The shop refreshes every day. Check back soon!"
    }
    
    // MARK: - Battle Pass Module
    
    enum BattlePassPage {
        static let title = "Battle Pass"
        static let free = "Free"
        static let paid = "Paid"
        static let allMenu = "All"
        static let page = "Page"
        static let search = "Search items"
    }
    
    enum BattlePassCell {
        static let identifier = "BattlePassCollectionViewCell"
        static let footerIdentifier = "BattlePassCollectionReusableView"
        static let price = "Item price..."
        static let loadingScreen = "Loading Screen"
        static let remaining = "Remaining time"
    }
    
    enum BattlePassItemsParameters {
        static let descriprion = "Descriprion"
        static let series = "Series"
        static let addedDate = "First release"
        static let paytype = "Tier type"
        static let rewardWall = "Rewards needed for unlock"
        static let levelWall = "Levels needed for unlock"
        static let introduced = "Introduced"
        static let set = "Set"
        static let beginDate = "Start date"
        static let endDate = "End date"
        static let currentSeason = "Currently underway"
        
        static let descriptionData = "Descriprion..."
        static let seriesData = "Series..."
        static let firstTimeData = "First release..."
        static let paytypeDara = "Tier type..."
        static let rewardWallData = "Rewards needed for unlock..."
        static let levelWallData = "Levels needed for unlock..."
        static let introducedData = "introduced in..."
        static let setData = "Part of..."
        static let beginDateData = "Begin date..."
        static let endDateData = "End date..."
        static let currentData = "Currently underway..."
    }
    
    enum BattlePassInfo {
        static let season = "Season"
        static let newSeason = "New season is coming soon!"
    }
    
    // MARK: - Crew Module
    
    enum CrewPage {
        static let currencyKey = "CurrencyKey"
        static let title = "Crew Pack"
    }
    
    enum CrewPageCell {
        static let identifier = "CrewCell"
        static let footerIdentifier = "CrewFooterReusableView"
        
        static let itemName = "Item name..."
        static let price = "Pack price..."
        static let symbol = "$"
        static let header = "Item Bundle"
        static let introductionTitle = "First appearance"
        static let introductionText = "Introduced in..."
        static let mainBenefits = "Main benefits"
        static let vbucks = "1,000 V-Bucks"
        static let additionalBenefints = "Additional benefits"
        static let yes = "Yes"
        static let no = "No"
        static let and = "and"
    }
    
    // MARK: - Bundles Module
    
    enum BundlesPage {
        static let title = "Bundles"
        static let header = "Special Offers"
    }
    
    enum BundleCell {
        static let identifier = "BundleCell"
        static let free = "Free"
    }
    
    enum BundleDetailsCell {
        static let identifier = "BundleDetailsCell"
        static let footerIdentifier = "BundleDetailsFooter"
        
        static let expiryDate = "Expiry date"
        static let expiryDateText = "00.00.0000"
        static let description = "Description"
        static let descriptionText = "Descriprion is..."
        static let about = "About"
        static let aboutText = "About this..."
    }
    
    // MARK: - Loot Details Module
    
    enum LootDetailsMain {
        static let title = "Loot Details"
        static let header = "Weapons"
    }
    
    enum LootDetailsMainCell {
        static let identifier = "LootDetailsMainCell"
        static let rarities = "Rarities"
        static let stats = "Stats"
    }
    
    enum LootDetailsRarity {
        static let title = "Rarities"
        static let back = "Loot"
    }
    
    enum LootDetailsRarityCell {
        static let identifier = "LootDetailsRarityCell"
    }
    
    enum LootDetailsStats {
        static let title = "Stats"
        static let backRarities = "Rarities"
        static let backLoot = "Loot"
    }
    
    enum LootDetailsStatsCell {
        static let footerIdentifier = "LootDetailsStatsFooter"
        static let damageBulletTitle = "Damage"
        static let firingRateTitle = "Firing rate"
        static let clipSizeTitle = "Clip size"
        static let reloadTimeTitle = "Reload time"
        static let bulletsCartridgeTitle = "Cartridge size"
        static let spreadTitle = "Spread"
        static let spreadDownsightsTitle = "Spread downsights"
        static let damageZoneTitle = "Damage zone critical"
        static let no = "No"
        
        static let damageBullets = "Units / round:"
        static let roundsSecond = "Rounds / second:"
        static let rounds = "Rounds:"
        static let seconds = "Seconds:"
        static let multiplier = "Multiplier:"
    }
    
    // MARK: - Settings Module
    
    enum SettingsPage {
        static let title = "Settings"
        static let aboutTitle = "About"
        static let generalTitle = "General"
        static let localizationTitle = "Localization"
        static let contactTitle = "Contact"
        
        static let notificationsTitle = "Notifications"
        static let appearanceTitle = "Appearance"
        static let cacheTitle = "Clear Cache"
        static let languageTitle = "Language"
        static let currencyTitle = "Currency"
        static let emailTitle = "Email"
        
        static let emailContent = "fortsatellite@vk.ru"
        static let emptyCacheContent = "Empty"
    }
    
    enum SettingsAboutCell {
        static let identifier = "SettingsAboutCell"
        static let name = "Fort Satellite"
        static let version = "0.6.3 release 1"
    }
    
    enum SettingsCell {
        static let identifier = "SettingsCell"
    }
    
    // MARK: - Stats Module
    
    enum StatsPage {
        static let title = "Stats"
        static let placeholder = "Error"
        static let progressTitle = "Progress"
        static let progressFirst = "Current\nSeason"
        static let progressSecond = "Current\nLevel"
        static let globalTitle = "Global"
        static let globalFirst = "Top 1\nPlaces"
        static let globalSecond = "Kills\nDeaths"
        static let inputTitle = "Input"
        static let inputFirst = "K/D\nGpad"
        static let inputSecond = "K/D\nMouse"
        static let historyTitle = "History"
        static let historyFirst = "Best\nSeason"
        static let historySecond = "Max\nLevel"
        static let nicknameKey = "NicknameKey"
    }
    
    enum StatsCell {
        static let identifier = "StatsCell"
        static let firstStatPlaceholder = "First\nStat"
        static let secondStatPlaceholder = "Second\nStat"
        static let statValuePlaceholder = "0"
    }
    
    enum NicknamePopup {
        static let placeholder = "Nickname"
        static let xbox = "Xbox"
        static let epic = "Epic"
        static let psn = "PSN"
        static let accept = "Accept"
        static let cancel = "Cancel"
        static let noResult = "No result"
        static let empty = "Empty text"
        static let emptyMessage = "Please, enter any nickname"
    }
    
    enum StatsDetailsPage {
        static let gamepad = "Gamepad"
        static let keyboard = "Keyboard"
        static let touch = "Touch"
    }
    
    enum StatsDetailsCell {
        static let identifier = "StatsDetailsCell"
        static let mode = "Mode:"
        static let winrate = "Winrate"
        static let topOne = "Top 1"
        static let matches = "Matches"
        static let kd = "K/D"
        static let kills = "Kills"
        static let outlived = "Outlived"
        static let hours = "Hours"
        static let score = "Score"
        static let season = "Season"
        static let level = "Level"
        static let progress = "Progress"
    }
    
    // MARK: - Quests Module
    
    enum Quest {
        static let title = "Quest"
    }
    
    enum BundleQuestsCell {
        static let identifier = "BundleCell"
        static let bundleName = "Bundle name..."
        static let bundleDate = "Until the end of this season"
    }
    
    enum QuestCell {
        static let identifier = "QuestCell"
        static let questName = "Task name..."
        static let questProgress = "Quest progress..."
        static let requirement = "Requirement: "
    }
    
    enum QuestDetails {
        static let rewards = "Rewards: "
        static let reward = "Reward: "
        static let xp = " XP"
        static let requirement = "Requirement: "
    }
    
    // MARK: - Map Module
    
    enum MapPage {
        static let title = "Map"
        static let poi = "POI"
        static let clear = "Clear"
        static let archive = "Archive"
    }
}

