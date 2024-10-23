<div align="center">
  <img src="https://github.com/user-attachments/assets/3ad62950-2109-481f-9fb7-6f3fe4c40dbb" alt="Image" width="200" height="200">
  <h1>ItemShopPlus: Fort Satellite</h1>
</div>

**ItemShopPlus** is a Swift-based iOS app designed to provide users with up-to-date information about in-game items from a popular gaming platform.
The app includes features like a `shop` for viewing items, `battle pass`, `stats`, and `widget` integration.
It provides a well-structured, user-friendly interface for navigating through various item collections and their details, as well as supporting network requests for real-time data updates.
Find it in [App Store](https://apps.apple.com/ru/app/fort-satellite-fortnite-shop/id6478311226?l=en-GB).

## Table of Contents 📋

- [Features](#features)
- [Technologies](#technologies)
- [Architecture](#architecture)
- [Testing](#testing)
- [Documentation](#documentation)
- [Requirements](#requirements)

## Features ⚒️

### Main Page
- Navigate seamlessly between different sections of the app, including the shop, battle pass, and stats.
- Access frequently used features like loot details, map, favorites and settings.
- Actual information for crew membership and bundles blocks.

<img src="https://github.com/user-attachments/assets/61903185-86e3-4b36-8356-220153bc0aac" alt="Demo" width="200" height="435">
<img src="https://github.com/user-attachments/assets/5a24ef3c-5e5d-47f9-ba4f-bde9dc545113" alt="Splash" width="200" height="435">
<img src="https://github.com/user-attachments/assets/d431c020-9cf0-412e-8ae8-996a14e8a123" alt="Onboarding" width="200" height="435">
<img src="https://github.com/user-attachments/assets/518b4708-fddd-4d8b-98aa-48734158a6b8" alt="Main" width="200" height="435">

### Item Shop
- Browse available in-game items.
- View item details including price, rarity, release dates, and more.
- Add items to favorites or view items in the shop.
- Filtering and sorting options based on item section.

<img src="https://github.com/user-attachments/assets/b13cdd83-dc14-4eb4-b4c2-e77f70b2c895" alt="Demo" width="200" height="435">
<img src="https://github.com/user-attachments/assets/538caebc-c785-44da-a909-0b279efd48f4" alt="Shop" width="200" height="435">
<img src="https://github.com/user-attachments/assets/50187803-1b66-47bd-af77-a873ed6c1c4d" alt="Granted" width="200" height="435">
<img src="https://github.com/user-attachments/assets/3ed72ff2-a4da-4452-9a22-af6aa297bf38" alt="VideoPreview" width="200" height="435">
<img src="https://github.com/user-attachments/assets/ffd64453-95ab-4f39-9dfc-cb5ec9894b6f" alt="Search" width="200" height="435">
<img src="https://github.com/user-attachments/assets/9b45f5ee-f58b-4d4b-9f38-99dea8baadfe" alt="Info" width="200" height="435">

### Battle Pass
- See details about items available in the current battle pass.
- Display essential information like start and end dates and remaining time.

<img src="https://github.com/user-attachments/assets/d985e069-e9e6-4a77-b4bf-e3114ff1c142" alt="Demo" width="200" height="435">
<img src="https://github.com/user-attachments/assets/6c59db65-7c63-4b80-85a6-724b4de1e55b" alt="BattlePass" width="200" height="435">
<img src="https://github.com/user-attachments/assets/7a65c57d-61dc-4342-acc1-f766b6a57e5c" alt="Granted" width="200" height="435">
<img src="https://github.com/user-attachments/assets/17b354b3-99b1-4aab-b2ea-e508e69caa4f" alt="VideoPreview" width="200" height="435">
<img src="https://github.com/user-attachments/assets/7e84df95-e43a-4adb-b141-ef4d0ffce7c7" alt="Search" width="200" height="435">
<img src="https://github.com/user-attachments/assets/1360afbb-de0f-4d47-9576-fe9b1398d19d" alt="Info" width="200" height="435">

### Stats
- View and track in-game statistics.
- Global stats such as wins, kills, and playtime are available across different game modes.
- Player statistics based on input methods (e.g., gamepad, keyboard, mouse).

<img src="https://github.com/user-attachments/assets/974afe3d-9b3b-45f3-bef1-4be45a7e92cc" alt="Demo" width="200" height="435">
<img src="https://github.com/user-attachments/assets/f6763b80-8525-40cd-a008-f58fc748baed" alt="UserSearch" width="200" height="435">
<img src="https://github.com/user-attachments/assets/d2704df1-58fb-4e96-8df0-07b955c06895" alt="Stats" width="200" height="435">
<img src="https://github.com/user-attachments/assets/48948f6a-e277-4c54-a30d-1add086eff64" alt="Details" width="200" height="435">

### Bundles
- Explore special offers and item bundles.
- View detailed descriptions of bundled items and their pricing.
- Easily identify expiration dates for limited-time bundles.

### Crew
- Access the exclusive crew membership section.
- View crew pack details, including items and V-Bucks rewards.
- Track the introduction dates of new crew packs and their benefits.

### Loot Details
- Browse and filter through various weapons and loot items.
- View detailed statistics such as damage, firing rate, and rarity.
- Sort items by weapon type sections.

### Map
- Interact with the in-game map to explore different points of interest (POIs).
- Use the archive feature to view past and present locations.
- Quickly switch between map views and clear markers with ease.

### Favourites
- Manage your collection of favorite items from the shop.
- Quickly access and view saved items from the favorites section.
- Toggle items as favorites for future reference and shop tracking.

### Widgets
- Custom widgets to display featured items or new arrivals in the game shop.
- Easy-to-use widget interface for a quick look at the most relevant items of the day.

### In-App Notifications
- Provides support for localized push notifications.
- Notifications show the latest item shop content and updates.

## Technologies 💻

### iOS Frameworks and Languages
- **Swift:** The primary language used to build the entire app, offering safety, performance, and modern language features.
- **SwiftUI:** It powers the layout and rendering of UI components, including widgets, and onboarding screens.
- **UIKit:** Used alongside SwiftUI for more complex or custom UI elements like UICollectionView, animations, and legacy components.
- **Core Data:** Responsible for local data persistence. It stores information about favorite items, user preferences, and cached shop data.
- **Combine:** A framework used for handling asynchronous programming in a reactive way (used with SwiftUI). It manages network requests, data flow, and UI updates seamlessly.

### Networking and Data Handling
- **URLSession:** The primary tool for managing network requests and fetching data from external APIs (like game item information, shop updates).
- **Kingfisher:** A third-party library used to efficiently download and cache images in the app, such as item images and in-game assets.
- **Yandex Ads SDK:** Integrated for serving advertisements to monetize the app. This includes displaying in-app ads to the users.

### User Interface and Experience
- **WidgetKit:** Powers the `Day Offer` widget, allowing users to see the latest shop items and updates directly from their home screen.
- **Core Animation:** Used to create smooth animations and transitions within the app, particularly for enhancing user interactions with buttons and other UI components.

### Push Notifications
- **Firebase Cloud Messaging (FCM):** Is used to send push notifications to users, such as alerts about new shop items, upcoming events, or important in-game updates.
- **Notification Service Extension:** Is implemented to customize notifications when they arrive on the device. This allows to modify the notification content dynamically, such as translating it based on the user’s preferred language.
- **Localized Notifications** The app uses the user’s language preference (stored in UserDefaults) to localize the notification text. When a notification is received, the app fetches the relevant localized message from the notification payload and displays it in the appropriate language.

### Logging
- **OSLog:** Integrated for logging essential app data, system events, and debugging information, making it easier to track performance and bugs.

## Architecture 🏗️
The **ItemShopPlus** app follows the Model-View-Controller (MVC) architecture pattern in its UIKit components.
This pattern organizes the app’s structure, dividing it into three distinct layers:

### Model
The Model represents the data layer of the app. This includes all the logic related to data retrieval, manipulation, and storage.

Examples:
- `ShopItem`: Stores data for items in the shop, such as price, rarity, and availability.
- `GrantedShopItem`: Handles details about bonuses or special rewards.

### View
The View is responsible for displaying the user interface elements. It presents the data from the model to the user.
Views are passive; they do not contain any logic beyond what is required to display the data.

Examples:
- `CollectionTotalPriceView`: Displays total prices in details pages.
- `TimerRemainingView`: Shows countdowns in items shop and battle pass info pages.

### Controller
The Controller acts as the intermediary between the model and the view. It manages user interactions and updates both the model and view as necessary.
It also handles user input and interactions like button taps, data fetching, and updating the views.

Examples:
- `FavouritesItemsViewController`: Handles interactions with favorite items, allowing users to toggle and view their favorite shop items.
- `ShopViewController`: Manages the display of the shop page, handling user navigation and data presentation.

## Testing 🧪

### Unit Testing

Unit tests focus on verifying the functionality of individual classes, methods, and functions in isolation.
Unit tests are written for both models and utility methods.

**ShopModelTests:** Tests for validating the correct behavior of the ShopItem, GrantedItem, and related entities. Ensures that properties such as item ID, name, and prices are correctly set and handled.
Example:
- `testEmptyShopItem()`: Verifies that a default, empty ShopItem is properly initialized with default values.

**StatsModelTests:** Tests for Stats and related classes, focusing on ensuring correct calculations of statistics such as `sumTopOne()` and `averageKD()`.
Example:
- `testAverageKDGlobal()`: Verifies the calculation of the average kill/death ratio for global stats.

### UI Testing
UI testing ensures that the user interface behaves correctly when interacted with. It simulates user actions such as tapping buttons, navigating screens, and entering text, then verifies the expected outcome.

**OnboardingScreenUITests:** Ensures that the onboarding screens function correctly, verifying that users can either skip or walk through the onboarding flow.
Example:
- `testOnbordingScreenWalkthrough()`: Simulates a user going through the onboarding screens, ensuring each page is correctly displayed and transitions work as expected.

**ShopPageUITests:** Tests the functionality of the shop page, ensuring that users can view item details, interact with banners, and see correct item pricing.
Example:
- `testShopPageInfoStruct()`: Simulates interaction with the shop page and verifies that essential information such as item details and pricing is presented correctly.

**BattlePassUITests:** Tests the navigation and interactions in the Battle Pass module, ensuring that users can view battle pass details and navigate between screens.
Example:
- `testBattlePassInfoStruct()`: Simulates user navigation to the Battle Pass screen and verifies that the correct information (e.g., start date, end date) is displayed.

## Documentation 📚
All significant classes, methods, and properties in the ItemShopPlus project are documented using Apple’s standard DocC format.
This format generates human-readable documentation directly from the source code, making it easy for developers to navigate through the project.

The documentation typically follows this structure:
- **Description:** Explains the purpose and functionality of the method/class.
- **Parameters:** Each parameter is documented, explaining what it represents and how it impacts the method.
- **Returns:** Where applicable, details what the method returns and under what conditions.

Every class includes a summary of its purpose, where and how it is used in the app, and detailed documentation of its methods and properties.
Example:
```swift
/// Downloads the image for a given `WidgetShopItem`
/// - Parameters:
///   - item: The `WidgetShopItem` that contains the image URL to be downloaded
///   - completion: A closure that returns the downloaded `UIImage` or `nil` if the download fails
///
/// The image is downloaded asynchronously, and the result is returned in the closure
private func downloadImage(for item: WidgetShopItem, completion: @escaping (UIImage?) -> Void) {
    // Code implementation
}
```

## Requirements ✅
- Xcode 15.0+
- Swift 5.0+
- iOS 16.0+
