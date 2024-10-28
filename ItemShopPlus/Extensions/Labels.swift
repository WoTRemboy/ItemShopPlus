//
//  Labels.swift
//  ItemShopPlus
//
//  Created by Roman Tverdokhleb on 08.12.2023.
//

import UIKit

/// The class containing all the localized strings used in the application
final class Texts {
    
    // MARK: - Common
    
    /// Common elements like identifiers used across multiple modules
    enum CommonElements {
        static let headerIdentifier = "HeaderReusableView"
    }
    
    /// Collection cell identifiers
    enum CollectionCell {
        static let identifier = "CollectionRarityCell"
    }
    
    /// Navigation texts such as button labels for 'cancel', 'done'
    enum Navigation {
        static let cancel = NSLocalizedString("NavigationCancel", comment: "Cancel")
        static let done = NSLocalizedString("NavigationDone", comment: "Done")
        static let backToMain = NSLocalizedString("NavigationMain", comment: "Main")
        static let backToShop = NSLocalizedString("NavigationShop", comment: "Shop")
        static let backToPass = NSLocalizedString("NavigationPass", comment: "Pass")
        static let backToBundles = NSLocalizedString("NavigationBundles", comment: "Bundles")
        static let backToSettings = NSLocalizedString("NavigationSettings", comment: "Settings")
    }
    
    /// Texts for search controller, including "no result" messages
    enum SearchController {
        static let result = NSLocalizedString("SearchResult", comment: "Result")
        static let noResult = NSLocalizedString("SearchNoResult", comment: "No result")
    }
    
    /// Season date constants for battle pass parsing error
    enum Season {
        static let beginDate = "2023-12-03T08:00:00.000Z"
        static let endDate = "2024-03-08T02:00:00.000Z"
    }
    
    /// Placeholder texts for empty fields or errors
    enum Placeholder {
        static let noText = NSLocalizedString("PlaceholderSmth", comment: "Something wrong...")
    }
    
    /// Placeholder texts for empty views such as stats, favorites, and internet connectivity issues
    enum EmptyView {
        static let statsTitle = NSLocalizedString("EmptyViewStatsTitle", comment: "No stats")
        static let statsContent = NSLocalizedString("EmptyViewStatsContent", comment: "Enter a nickname and try again")
        static let favouriteTitle = NSLocalizedString("EmptyViewFavouriteTitle", comment: "No favorites")
        static let favouriteContent = NSLocalizedString("EmptyViewFavouriteContent", comment: "Add some shop items to your favorites")
        static let noInternetTitle = NSLocalizedString("EmptyViewInternetTitle", comment: "No connection")
        static let noInternetContent = NSLocalizedString("EmptyViewInternetContent", comment: "Please, check your internet connection")
        static let retryButton = NSLocalizedString("EmptyViewRetryButton", comment: "Retry")
    }
    
    /// Localized texts for item rarity types
    enum Rarity {
        static let common = NSLocalizedString("RarityCommon", comment: "Common")
        static let uncommon = NSLocalizedString("RarityUncommon", comment: "Uncommon")
        static let rare = NSLocalizedString("RarityRare", comment: "Rare")
        static let epic = NSLocalizedString("RarityEpic", comment: "Epic")
        static let legendary = NSLocalizedString("RarityLegend", comment: "Legendary")
        static let mythic = NSLocalizedString("RarityMythic", comment: "Mythic")
        static let star = NSLocalizedString("RarityStar", comment: "Star")
        static let transcendent = NSLocalizedString("RarityTrans", comment: "Transcendent")
        static let exotic = NSLocalizedString("RarityExotic", comment: "Exotic")
    }
    
    /// Texts related to network requests, including language settings
    enum NetworkRequest {
        static let language = NSLocalizedString("NetworkRequestLang", comment: "en")
    }
    
    /// Key for saving language settings to UserDefaults
    enum LanguageSave {
        static let userDefaultsKey = "UserDefaultsNotificationsKey"
    }
    
    /// Localized texts related to currencies
    enum Currency {
        
        /// Currency names used for different regions
        enum Name {
            static let usd = NSLocalizedString("CurrencyNameUSD", comment: "United States Dollar")
            static let eur = NSLocalizedString("CurrencyNameEUR", comment: "Euro")
            static let gbr = NSLocalizedString("CurrencyNameGBR", comment: "Pound Sterling")
            static let cad = NSLocalizedString("CurrencyNameCAD", comment: "Canadian Dollar")
            static let rub = NSLocalizedString("CurrencyNameRUB", comment: "Russian Ruble")
            static let dkk = NSLocalizedString("CurrencyNameDKK", comment: "Danish Krone")
            static let jpy = NSLocalizedString("CurrencyNameJPY", comment: "Japanese Yen")
            static let sek = NSLocalizedString("CurrencyNameSEK", comment: "Swedish Krona")
            static let brl = NSLocalizedString("CurrencyNameBRL", comment: "Brazilian Real")
            static let nok = NSLocalizedString("CurrencyNameNOK", comment: "Norwegian Krone")
            static let aud = NSLocalizedString("CurrencyNameAUD", comment: "Australian Dollar")
            static let lira = NSLocalizedString("CurrencyNameTRY", comment: "Turkish Lira")
        }
        
        /// Currency codes used for different regions
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
        
        /// Currency symbols corresponding to the currency codes
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
    
    // MARK: - Opening Screens Module
    
    /// Texts used in the onboarding screens
    enum OnboardingScreen {
        static let userDefaultsKey = "FirstLaunch"
        
        static let widgetTitle = NSLocalizedString("OnboardingScreenWidgetTitle", comment: "New widget")
        static let widgetContent = NSLocalizedString("OnboardingScreenWidgetContent", comment: "The 'Day Offer' shows what’s interesting in the shop today.")
        static let placeholderTitle = NSLocalizedString("OnboardingScreenPlaceholderTitle", comment: "Placeholders")
        static let placeholderContent = NSLocalizedString("OnboardingScreenPlaceholderContent", comment: "Now the pages without content have a context description.")
        static let iconTitle = NSLocalizedString("OnboardingScreenIconitle", comment: "App Icon")
        static let iconContent = NSLocalizedString("OnboardingScreenIconContent", comment: "With iOS 18, a specific icon theme will now be displayed.")
        
        static let skip = NSLocalizedString("OnboardingScreenSkipButton", comment: "Skip")
        static let next = NSLocalizedString("OnboardingScreenNextPageButton", comment: "Next page")
        static let started = NSLocalizedString("OnboardingScreenStartedButton", comment: "Get started")
    }
    
    // MARK: - Main Module
    
    /// Contains the button labels
    enum ButtonLabels {
        
        /// Button labels for the main screen buttons
        enum MainButtons {
            static let shop = NSLocalizedString("MainButtonsShop", comment: "Item Shop")
            static let bundles = NSLocalizedString("MainButtonsBundles", comment: "Bundles")
            static let battlePass = NSLocalizedString("MainButtonsBP", comment: "Battle Pass")
            static let lootDetails = NSLocalizedString("MainButtonsArmory", comment: "Armory")
            static let crew = NSLocalizedString("MainButtonsCrew", comment: "Crew")
            static let map = NSLocalizedString("MainButtonsMap", comment: "Map")
            static let favourites = NSLocalizedString("MainButtonsFavourites", comment: "Favourites")
            static let stats = NSLocalizedString("MainButtonsStats", comment: "Stats")
            static let augments = NSLocalizedString("MainButtonsAugments", comment: "Augments")
            static let settings = NSLocalizedString("MainButtonsSettings", comment: "Settings")
        }
    }
    
    /// Contains the section titles for different modules and screens
    enum Titles {
        static let main = NSLocalizedString("TitlesMain", comment: "Main")
        static let other = NSLocalizedString("TitlesOther", comment: "Other")
        static let bundles = NSLocalizedString("TitlesBundles", comment: "Bundles")
        static let bundlesIdentifier = "MainBundlesIdentifier"
    }
    
    /// Contains the titles of various pages in the app
    enum Pages {
        static let main = "Fort Satellite"
        static let quests = NSLocalizedString("PagesQuests", comment: "Quests")
        static let quest = NSLocalizedString("PagesQuest", comment: "Quest")
        static let details = NSLocalizedString("PagesDetails", comment: "Details")
        static let shop = NSLocalizedString("PagesShop", comment: "Item Shop")
    }
    
    // MARK: - Cache Module
    
    /// Contains texts related to clearing cache
    enum ClearCache {
        static let message = NSLocalizedString("ClearCacheMessage", comment: "All media used in the app will remain in the cloud and will be re-downloaded when needed")
        static let cache = NSLocalizedString("ClearCacheCache", comment: "Clear Entire Cache")
        static let megabytes = NSLocalizedString("ClearCacheMB", comment: "MB")
        static let cancel = NSLocalizedString("ClearCacheCancel", comment: "Cancel")
        
        static let oops = NSLocalizedString("ClearCacheOops", comment: "Oops!")
        static let alreadyClean = NSLocalizedString("ClearCacheClean", comment: "The cache is already clean.")
        static let success = NSLocalizedString("ClearCacheSuccess", comment: "Success")
        static let cleared = NSLocalizedString("ClearCacheCleared", comment: "The cache has been cleared.")
        static let ok = NSLocalizedString("ClearCacheOk", comment: "OK")
    }
    
    // MARK: - Shop Module
    
    /// Contains localized texts related to the shop module
    enum ShopPage {
        static let itemName = NSLocalizedString("ShopPageItemName", comment: "Item name...")
        static let itemPrice = NSLocalizedString("ShopPageItemPrice", comment: "Item price...")
        static let bundleName = NSLocalizedString("ShopPageBundleName", comment: "Bundle name...")
        static let segmentName = NSLocalizedString("ShopPageSegmentName", comment: "Segment name...")
        static let allMenu = NSLocalizedString("ShopPageAllMenu", comment: "All")
        static let rotaionTitle = NSLocalizedString("ShopPageShopInfo", comment: "Shop Info")
        static let reloadShop = NSLocalizedString("ShopPageReloadShop", comment: "It's time to update!")
        static let remaining = NSLocalizedString("ShopPageRemaining", comment: "Remaining time")
        static let jamTracks = NSLocalizedString("ShopPageJamTracks", comment: "Jam Tracks")
        static let backpack = NSLocalizedString("ShopPageShopBackpack", comment: "Backpack")
        static let bundle = NSLocalizedString("ShopPageShopItemBundle", comment: "Item Bundle")
        static let favourites = NSLocalizedString("ShopPageFavouritesNotification", comment: "Added to Favorites.")
        static let countKey = "ShopPageRatingUserDefaultsKey"
    }
    
    /// Collection view cell identifiers and texts related to the shop items
    enum ShopMainCell {
        static let identifier = "ShopCollectionViewCell"
        static let vBucks = " VBucks"
        static let search = NSLocalizedString("ShopMainCellSearch", comment: "Search items")
    }
    
    /// Collection view cell identifiers and texts related to the shop granted items
    enum ShopGrantedCell {
        static let footerIdentifier = "ShopGrantedCollectionReusableView"
        static let firstTime = NSLocalizedString("ShopGrantedCellFirstTime", comment: "First time...")
        static let lastTime = NSLocalizedString("ShopGrantedCellLastTime", comment: "Last time...")
        static let total = NSLocalizedString("ShopGrantedCellTotal", comment: "Total")
        static let price = NSLocalizedString("ShopGrantedCellPrice", comment: "Bundle price...")
        static let title = NSLocalizedString("ShopGrantedCellTitle", comment: "Title...")
        static let content = NSLocalizedString("ShopGrantedCellContent", comment: "Content...")
    }
    
    /// Collection view parameters related to the shop granted items
    enum ShopGrantedParameters {
        static let descriprion = NSLocalizedString("ShopGrantedParametersDescription", comment: "Descriprion")
        static let series = NSLocalizedString("ShopGrantedParametersSeries", comment: "Series")
        static let firstTime = NSLocalizedString("ShopGrantedParametersFirstTime", comment: "First release")
        static let lastTime = NSLocalizedString("ShopGrantedParametersLastTime", comment: "Previous release")
        static let expiryDate = NSLocalizedString("ShopGrantedParametersExpityDate", comment: "Expiry date")
        static let descriptionData = NSLocalizedString("ShopGrantedParametersDescriptionData", comment: "Descriprion...")
        static let seriesData = NSLocalizedString("ShopGrantedParametersSeriesData", comment: "Series...")
        static let firstTimeData = NSLocalizedString("ShopGrantedParametersFirstTimeData", comment: "First release...")
        static let lastTimeData = NSLocalizedString("ShopGrantedParametersLastTimeData", comment: "Previous release...")
        static let expiryDateData = NSLocalizedString("ShopGrantedParametersExpityDateData", comment: "Expiry date...")
    }
    
    /// Content related to the shop info page
    enum ShopTimer {
        static let whatMeans = NSLocalizedString("ShopTimerWhat", comment: "What is: ")
        static let swipeInfo = NSLocalizedString("ShopTimerSwipeInfo", comment: "Swipe over the cell image to see more variations!")
        static let countInfo = NSLocalizedString("ShopTimerCountInfo", comment: "Number of elements in the item bundle.")
        static let aboutRotation = NSLocalizedString("ShopTimerAboutRotation", comment: "About rotation")
        static let rotationInfo = NSLocalizedString("ShopTimerRotationInfo", comment: "The shop refreshes every day. Check back soon!")
    }
    
    // MARK: - Battle Pass Module
    
    /// Contains localized texts related to the Battle Pass module
    enum BattlePassPage {
        static let title = NSLocalizedString("BattlePassPageTitle", comment: "Battle Pass")
        static let free = NSLocalizedString("BattlePassPageFree", comment: "Free")
        static let paid = NSLocalizedString("BattlePassPagePaid", comment: "Paid")
        static let allMenu = NSLocalizedString("BattlePassPageAll", comment: "All")
        static let page = NSLocalizedString("BattlePassPagePage", comment: "Page")
        static let search = NSLocalizedString("BattlePassPageSearch", comment: "Search items")
    }
    
    /// Collection view cell identifiers and texts related to Battle Pass items
    enum BattlePassCell {
        static let identifier = "BattlePassCollectionViewCell"
        static let footerIdentifier = "BattlePassCollectionReusableView"
        static let price = NSLocalizedString("BattlePassCellPrice", comment: "Item price...")
        static let loadingScreen = NSLocalizedString("BattlePassCellLoadingScreen", comment: "Loading Screen")
        static let remaining = NSLocalizedString("BattlePassCellRemaining", comment: "Remaining time")
    }
    
    /// Contains localized texts related to the parameters of Battle Pass items
    enum BattlePassItemsParameters {
        static let descriprion = NSLocalizedString("BattlePassItemsParametersDescription", comment: "Descriprion")
        static let series = NSLocalizedString("BattlePassItemsParametersSeries", comment: "Series")
        static let addedDate = NSLocalizedString("BattlePassItemsParametersFirstRelease", comment: "First release")
        static let paytype = NSLocalizedString("BattlePassItemsParametersTierType", comment: "Tier type")
        static let rewardWall = NSLocalizedString("BattlePassItemsParametersRewardWall", comment: "Rewards needed for unlock")
        static let levelWall = NSLocalizedString("BattlePassItemsParametersLevelWall", comment: "Levels needed for unlock")
        static let introduced = NSLocalizedString("BattlePassItemsParametersIntroduced", comment: "Introduced")
        static let set = NSLocalizedString("BattlePassItemsParametersSet", comment: "Set")
        static let beginDate = NSLocalizedString("BattlePassItemsParametersBeginDate", comment: "Start date")
        static let endDate = NSLocalizedString("BattlePassItemsParametersEndDate", comment: "End date")
        static let currentSeason = NSLocalizedString("BattlePassItemsParametersCurrentSeason", comment: "Currently underway")
        
        static let descriptionData = NSLocalizedString("BattlePassItemsParametersDescriprionData", comment: "Descriprion...")
        static let seriesData = NSLocalizedString("BattlePassItemsParametersSeriesData", comment: "Series...")
        static let firstTimeData = NSLocalizedString("BattlePassItemsParametersFirstTimeData", comment: "First release...")
        static let paytypeDara = NSLocalizedString("BattlePassItemsParametersTierTypeData", comment: "Tier type...")
        static let rewardWallData = NSLocalizedString("BattlePassItemsParametersRewardWallData", comment: "Rewards needed for unlock...")
        static let levelWallData = NSLocalizedString("BattlePassItemsParametersLevelWallData", comment: "Levels needed for unlock...")
        static let introducedData = NSLocalizedString("BattlePassItemsParametersIntroducedData", comment: "Introduced in...")
        static let setData = NSLocalizedString("BattlePassItemsParametersSetData", comment: "Part of...")
        static let beginDateData = NSLocalizedString("BattlePassItemsParametersBeginDateData", comment: "Begin date...")
        static let endDateData = NSLocalizedString("BattlePassItemsParametersEndDateData", comment: "End date...")
        static let currentData = NSLocalizedString("BattlePassItemsParametersCurrentData", comment: "Currently underway...")
    }
    
    /// Contains localized texts related to the Battle Pass information
    enum BattlePassInfo {
        static let season = NSLocalizedString("BattlePassInfoSeason", comment: "Season")
        static let newSeason = NSLocalizedString("BattlePassItemsParametersnewSeason", comment: "New season is coming soon!")
        static let dateFormat = NSLocalizedString("BattlePassInfoDataFormat", comment: "%01dW %01dD %02d:%02d:%02d")
    }
    
    // MARK: - Crew Module
    
    /// Contains localized texts related to the Crew module
    enum CrewPage {
        static let currencyKey = "CurrencyKey"
        static let title = NSLocalizedString("CrewPageTitle", comment: "Crew Pack")
    }
    
    /// Collection view cell identifiers and texts related to Crew items
    enum CrewPageCell {
        static let identifier = "CrewCell"
        static let footerIdentifier = "CrewFooterReusableView"
        
        static let itemName = NSLocalizedString("CrewPageCellItemName", comment: "Item name...")
        static let price = NSLocalizedString("CrewPageCellPrice", comment: "Pack price...")
        static let symbol = "$"
        static let header = NSLocalizedString("CrewPageCellHeader", comment: "Item Bundle")
        static let introductionTitle = NSLocalizedString("CrewPageCellIntroduction", comment: "First appearance")
        static let introductionText = NSLocalizedString("CrewPageCellIntroductionData", comment: "Introduced in...")
        static let mainBenefits = NSLocalizedString("CrewPageCellMainBenefits", comment: "Main benefits")
        static let vbucks = "1,000 V-Bucks"
        static let additionalBenefints = NSLocalizedString("CrewPageCellAdditional", comment: "Additional benefits")
        static let yes = NSLocalizedString("CrewPageCellYes", comment: "Yes")
        static let no = NSLocalizedString("CrewPageCellNo", comment: "No")
        static let and = NSLocalizedString("CrewPageCellAnd", comment: "and")
    }
    
    // MARK: - Bundles Module
    
    /// Contains localized texts related to the Bundles module
    enum BundlesPage {
        static let title = NSLocalizedString("BundlesPageTitle", comment: "Bundles")
        static let header = NSLocalizedString("BundlesPageHeader", comment: "Special Offers")
    }
    
    /// Collection view cell identifiers and texts related to Bundles
    enum BundleCell {
        static let identifier = "BundleCell"
        static let free = NSLocalizedString("BundleCellFree", comment: "Free")
    }
    
    /// Collection view cell identifiers and texts for Bundle details
    enum BundleDetailsCell {
        static let identifier = "BundleDetailsCell"
        static let footerIdentifier = "BundleDetailsFooter"
        
        static let expiryDate = NSLocalizedString("BundleDetailsCellExpityDate", comment: "Expiry date")
        static let expiryDateText = "00.00.0000"
        static let description = NSLocalizedString("BundleDetailsCellDescription", comment: "Description")
        static let descriptionText = NSLocalizedString("BundleDetailsCellDescriptionData", comment: "Descriprion is...")
        static let about = NSLocalizedString("BundleDetailsCellAbout", comment: "About")
        static let aboutText = NSLocalizedString("BundleDetailsCellAboutData", comment: "About this...")
    }
    
    // MARK: - Loot Details Module
    
    /// Contains localized texts related to the Loot Details (Armory) module
    enum LootDetailsMain {
        static let title = NSLocalizedString("LootDetailsMainArmory", comment: "Armory")
        static let header = NSLocalizedString("LootDetailsMainWeapons", comment: "Weapons")
    }
    
    /// Collection view cell identifiers and texts for the main loot details section
    enum LootDetailsMainCell {
        static let identifier = "LootDetailsMainCell"
        static let rarities = NSLocalizedString("LootDetailsMainCellRarities", comment: "Rarities")
        static let stats = NSLocalizedString("LootDetailsMainCellStats", comment: "Stats")
    }
    
    /// Contains localized texts related to the Rarity section in Loot Details (Armory)
    enum LootDetailsRarity {
        static let title = NSLocalizedString("LootDetailsRarityTitle", comment: "Rarities")
        static let back = NSLocalizedString("LootDetailsRarityBack", comment: "Armory")
    }
    
    /// ollection view cell identifiers related to the Rarity section in Loot Details
    enum LootDetailsRarityCell {
        static let identifier = "LootDetailsRarityCell"
    }
    
    /// Contains localized texts related to the Stats section in Loot Details
    enum LootDetailsStats {
        static let title = NSLocalizedString("LootDetailsStatsTitle", comment: "Stats")
        static let backRarities = NSLocalizedString("LootDetailsStatsRarities", comment: "Rarities")
        static let backLoot = NSLocalizedString("LootDetailsStatsBackLoot", comment: "Armory")
        static let pistols = NSLocalizedString("LootDetailsStatsPistols", comment: "Pistols")
        static let assault = NSLocalizedString("LootDetailsStatsAssault", comment: "Assault")
        static let shotgun = NSLocalizedString("LootDetailsStatsShotgun", comment: "Shotgun")
        static let sniper = NSLocalizedString("LootDetailsStatsSniper", comment: "Sniper")
        static let blade = NSLocalizedString("LootDetailsStatsBlade", comment: "Blade")
        static let bow = NSLocalizedString("LootDetailsStatsBow", comment: "Bow")
        static let launcher = NSLocalizedString("LootDetailsStatsRocket", comment: "Launcher")
        static let gadget = NSLocalizedString("LootDetailsStatsGadget", comment: "Gadget")
        static let heal = NSLocalizedString("LootDetailsStatsHeal", comment: "Heal")
        static let misc = NSLocalizedString("LootDetailsStatsLauncher", comment: "Misc")
        
        /// Enum defining the tags used for weapon categories in the Loot Details Stats page
        enum Tags {
            static let pistols = "Pistols"
            static let assault = "Assault"
            static let shotgun = "Shotgun"
            static let sniper = "Sniper"
            static let bow = "Bow"
            static let blade = "Blade"
            static let launcher = "Launcher"
            static let gadget = "Gadget"
            static let heal = "Heal"
            static let misc = "Misc"
        }
    }
    
    /// Collection view cell identifiers and labels related to Stats in Loot Details
    enum LootDetailsStatsCell {
        static let footerIdentifier = "LootDetailsStatsFooter"
        static let damageBulletTitle = NSLocalizedString("LootDetailsStatsCellDamage", comment: "Damage")
        static let firingRateTitle = NSLocalizedString("LootDetailsStatsCellFiringRate", comment: "Firing rate")
        static let clipSizeTitle = NSLocalizedString("LootDetailsStatsCellClipSize", comment: "Clip size")
        static let reloadTimeTitle = NSLocalizedString("LootDetailsStatsCellReloadTime", comment: "Reload time")
        static let bulletsCartridgeTitle = NSLocalizedString("LootDetailsStatsCellCartridgeSize", comment: "Cartridge size")
        static let spreadTitle = NSLocalizedString("LootDetailsStatsCellSpread", comment: "Spread")
        static let spreadDownsightsTitle = NSLocalizedString("LootDetailsStatsCellSpreadDownsights", comment: "Spread downsights")
        static let damageZoneTitle = NSLocalizedString("LootDetailsStatsCellDamageZone", comment: "Damage zone critical")
        static let no = NSLocalizedString("LootDetailsStatsCellNo", comment: "No")
        
        static let damageBullets = NSLocalizedString("LootDetailsStatsCellUnitsRound", comment: "Units / round:")
        static let roundsSecond = NSLocalizedString("LootDetailsStatsCellRoundsSecond", comment: "Rounds / second:")
        static let rounds = NSLocalizedString("LootDetailsStatsCellRounds", comment: "Rounds:")
        static let seconds = NSLocalizedString("LootDetailsStatsCellSeconds", comment: "Seconds:")
        static let multiplier = NSLocalizedString("LootDetailsStatsCellMultiplier", comment: "Multiplier:")
    }
    
    // MARK: - Favourites Module
    
    /// Contains localized texts related to the Favourites module
    enum FavouritesPage {
        static let title = NSLocalizedString("FavouritesPageTitle", comment: "Favourites")
        static let footerIdentifier = "FavouritesFooterReusableView"
        static let available = NSLocalizedString("FavouritesPageAvailable", comment: "Available")
        static let notAvailable = NSLocalizedString("FavouritesPageNotAvailable", comment: "Not Available")
    }
    
    /// Defines the sort order for shop items in Favourites data base
    enum ItemSortOrder {
        static let outfit = "outfit"
        static let emote = "emote"
        static let backpack = "backpack"
        static let pickaxe = "pickaxe"
        static let glider = "glider"
        static let wrap = "wrap"
        static let loadingscreen = "loadingscreen"
        static let sparkSong = "sparks_song"
        static let music = "music"
        static let spray = "spray"
        static let bannertoken = "bannertoken"
        static let contrail = "contrail"
        static let buildingProp = "building_prop"
        static let buildingSet = "building_set"
    }
    
    // MARK: - Settings Module
    
    /// Contains localized texts related to Notification Settings in the Settings module
    enum NotificationSettings {
        static let key = "NotificationsKey"
        static let enable = "Enable"
        static let disable = "Disable"
        static let alertTitle = NSLocalizedString("NotificationSettingsAlertTitle", comment: "Notification Access Required")
        static let alertContent = NSLocalizedString("NotificationSettingsAlertContent", comment: "Please enable notifications in Settings.")
        static let alertSettings = NSLocalizedString("NotificationSettingsAlertSettings", comment: "Settings")
        static let alertCancel = NSLocalizedString("NotificationSettingsAlertCancel", comment: "Cancel")
    }
    
    /// Contains localized texts related to Appearance Settings in the Settings module
    enum AppearanceSettings {
        static let key = "AppearanceKey"
        static let systemValue = "SystemValue"
        static let lightValue = "LightValue"
        static let darkValue = "DarkValue"
        static let system = NSLocalizedString("AppearanceSettingsSystem", comment: "Device")
        static let light = NSLocalizedString("AppearanceSettingsLight", comment: "Light")
        static let dark = NSLocalizedString("AppearanceSettingsDark", comment: "Dark")
    }
    
    /// Contains localized texts related to Language Settings in the Settings module
    enum LanguageSettings {
        static let alertTitle = NSLocalizedString("LanguageSettingsAlertTitle", comment: "Change language")
        static let alertContent = NSLocalizedString("LanguageSettingsAlertContent", comment: "Select the language you want in Settings.")
    }
    
    /// Contains localized texts for the Settings page
    enum SettingsPage {
        static let title = NSLocalizedString("SettingsPageTitle", comment: "Settings")
        static let aboutTitle = NSLocalizedString("SettingsPageAboutTitle", comment: "About")
        static let generalTitle = NSLocalizedString("SettingsPageGeneralTitle", comment: "General")
        static let localizationTitle = NSLocalizedString("SettingsPageLocalizationTitle", comment: "Localization")
        static let teamTitle = NSLocalizedString("SettingsPageTeamTitle", comment: "Team")
        
        static let notificationsTitle = NSLocalizedString("SettingsPageNotificationsTitle", comment: "Notifications")
        static let appearanceTitle = NSLocalizedString("SettingsPageAppearanceTitle", comment: "Appearance")
        static let cacheTitle = NSLocalizedString("SettingsPageClearCacheTitle", comment: "Clear Cache")
        static let languageTitle = NSLocalizedString("SettingsPageLanguageTitle", comment: "Language")
        static let currencyTitle = NSLocalizedString("SettingsPageCurrencyTitle", comment: "Currency")
        static let developerTitle = NSLocalizedString("SettingsPageDeveloperTitle", comment: "Developer")
        static let designerTitle = NSLocalizedString("SettingsPageDesignerTitle", comment: "Designer")
        static let emailTitle = NSLocalizedString("SettingsPageEmailTitle", comment: "Email")
        
        static let developerContent = NSLocalizedString("SettingsPageDeveloperContent", comment: "Roman T.")
        static let designerContent = NSLocalizedString("SettingsPageDesignerContent", comment: "Artyom T.")
        static let emailContent = "fortsatellite@vk.com"
        static let languageContent = NSLocalizedString("SettingsPageLanguageContent", comment: "English")
        static let emptyCacheContent = NSLocalizedString("SettingsPageEmptyCache", comment: "Empty")
        
        static let developerLink = "https://www.linkedin.com/in/voityvit"
        static let designerLink = "https://t.me/ArtyomTver"
    }
    
    /// Contains localized texts for the About section in Settings
    enum SettingsAboutCell {
        static let identifier = "SettingsAboutCell"
        static let name = "Fort Satellite"
        static let version = "release"
    }
    
    /// Contains localized texts for cells in Settings
    enum SettingsCell {
        static let identifier = "SettingsCell"
        static let selectIdentifier = "SettingsSelectCell"
    }
    
    // MARK: - Stats Module
    
    /// Contains localized texts related to the Stats module
    enum StatsPage {
        static let title = NSLocalizedString("StatsPageTitle", comment: "Stats")
        static let placeholder = NSLocalizedString("StatsPagePlaceholder", comment: "Error")
        static let progressTitle = NSLocalizedString("StatsPageProgressTitle", comment: "Progress")
        static let progressFirst = NSLocalizedString("StatsPageProgressFirst", comment: "Current Season")
        static let progressSecond = NSLocalizedString("StatsPageProgressSecond", comment: "Current Level")
        static let globalTitle = NSLocalizedString("StatsPageGlobalTitle", comment: "Global")
        static let globalFirst = NSLocalizedString("StatsPageGlobalFirst", comment: "Top 1 Places")
        static let globalSecond = NSLocalizedString("StatsPageGlobalSecond", comment: "Kills Deaths")
        static let inputTitle = NSLocalizedString("StatsPageInputTitle", comment: "Input")
        static let inputFirst = NSLocalizedString("StatsPageInputFirst", comment: "K/D Gpad")
        static let inputSecond = NSLocalizedString("StatsPageInputSecond", comment: "K/D Mouse")
        static let historyTitle = NSLocalizedString("StatsPageHistoryTitle", comment: "History")
        static let historyFirst = NSLocalizedString("StatsPageHistoryFirst", comment: "Best Season")
        static let historySecond = NSLocalizedString("StatsPageHistorySecond", comment: "Max Level")
        static let nicknameKey = "NicknameKey"
    }
    
    /// Contains localized texts for the Stats cell in the Stats module
    enum StatsCell {
        static let identifier = "StatsCell"
        static let firstStatPlaceholder = "First\nStat"
        static let secondStatPlaceholder = "Second\nStat"
        static let statValuePlaceholder = "0"
    }
    
    /// Contains localized texts for the Nickname popup in the Stats module
    enum NicknamePopup {
        static let placeholder = NSLocalizedString("NicknamePopupPlaceholder", comment: "Nickname")
        static let xbox = "Xbox"
        static let epic = "Epic"
        static let psn = "PSN"
        static let accept = NSLocalizedString("NicknamePopupAccept", comment: "Accept")
        static let cancel = NSLocalizedString("NicknamePopupCancel", comment: "Cancel")
        static let noResult = NSLocalizedString("NicknamePopupNoResult", comment: "No result")
        static let empty = NSLocalizedString("NicknamePopupEmpty", comment: "Empty text")
        static let emptyMessage = NSLocalizedString("NicknamePopupEmptyMessage", comment: "Please, enter any nickname")
    }
    
    /// Contains localized texts related to details about stats input methods and party types in the Stats module
    enum StatsDetailsPage {
        static let gamepad = NSLocalizedString("StatsDetailsPageGamepad", comment: "Gamepad")
        static let keyboard = NSLocalizedString("StatsDetailsPageKeyboard", comment: "Keyboard")
        static let touch = NSLocalizedString("StatsDetailsPageTouch", comment: "Touch")
        static let solo = NSLocalizedString("StatsDetailsPageSolo", comment: "Solo")
        static let duo = NSLocalizedString("StatsDetailsPageDuo", comment: "Duo")
        static let trio = NSLocalizedString("StatsDetailsPageTrio", comment: "Trio")
        static let squad = NSLocalizedString("StatsDetailsPageSquad", comment: "Squad")
    }
    
    /// Contains localized texts for the Stats details cell in the Stats module
    enum StatsDetailsCell {
        static let identifier = "StatsDetailsCell"
        static let mode = NSLocalizedString("StatsDetailsCellMode", comment: "Mode:")
        static let winrate = NSLocalizedString("StatsDetailsCellWinrate", comment: "Winrate")
        static let topOne = NSLocalizedString("StatsDetailsCellTopOne", comment: "Top 1")
        static let matches = NSLocalizedString("StatsDetailsCellMatches", comment: "Matches")
        static let kd = NSLocalizedString("StatsDetailsCellKD", comment: "K/D")
        static let kills = NSLocalizedString("StatsDetailsCellKills", comment: "Kills")
        static let outlived = NSLocalizedString("StatsDetailsCellOutlived", comment: "Outlived")
        static let hours = NSLocalizedString("StatsDetailsCellHours", comment: "Hours")
        static let score = NSLocalizedString("StatsDetailsCellScore", comment: "Score")
        static let season = NSLocalizedString("StatsDetailsCellSeason", comment: "Season")
        static let level = NSLocalizedString("StatsDetailsCellLevel", comment: "Level")
        static let progress = NSLocalizedString("StatsDetailsCellProgress", comment: "Progress")
    }
    
    // MARK: - Quests Module
    
    /// Contains localized texts related to the Quests module
    enum Quest {
        static let title = "Quest"
    }
    
    /// Contains localized texts for the Bundle Quests cell in the Quests module
    enum BundleQuestsCell {
        static let identifier = "BundleCell"
        static let bundleName = "Bundle name..."
        static let bundleDate = "Until the end of this season"
    }
    
    /// Contains localized texts for the Quest cell in the Quests module
    enum QuestCell {
        static let identifier = "QuestCell"
        static let questName = "Task name..."
        static let questProgress = "Quest progress..."
        static let requirement = "Requirement: "
    }
    
    /// Contains localized texts related to Quest details in the Quests module
    enum QuestDetails {
        static let rewards = "Rewards: "
        static let reward = "Reward: "
        static let xp = " XP"
        static let requirement = "Requirement: "
    }
    
    // MARK: - Map Module
    
    /// Contains localized texts related to the Map module
    enum MapPage {
        static let title = NSLocalizedString("MapPageTitle", comment: "Map")
        static let poi = NSLocalizedString("MapPagePOI", comment: "POI")
        static let clear = NSLocalizedString("MapPageClear", comment: "Clear")
        static let archive = NSLocalizedString("MapPageArchive", comment: "Archive")
    }
    
    // MARK: - Widget
    
    /// Contains localized texts related to the Widget module
    enum Widget {
        static let placeholderName = "--"
        static let displayName = NSLocalizedString("WidgetDisplayName", comment: "Day Offer")
        static let description = NSLocalizedString("WidgetDisplayDescription", comment: "New or the most interesting item today.")
    }
}

// MARK: - Notification Names

extension Notification.Name {
    /// Notification to trigger a transfer back to the main page
    static let transferToMainPage = Notification.Name("TransferToMainPageNotification")
}


