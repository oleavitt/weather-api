# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

iOS weather app built with SwiftUI targeting iOS 17.6+, Xcode 16.2+. Displays current weather and multi-day forecasts using the WeatherAPI.com REST API. Supports weather alerts, search by city/zip/airport code, location-based queries, and query history via SwiftData.

## Build & Test Commands

The Xcode project is at `WeatherApi/WeatherApi.xcodeproj` with scheme `WeatherApi`.

```bash
# Build
xcodebuild -project WeatherApi/WeatherApi.xcodeproj -scheme WeatherApi -destination 'platform=iOS Simulator,name=iPhone 16' build

# Run all unit tests
xcodebuild -project WeatherApi/WeatherApi.xcodeproj -scheme WeatherApi -destination 'platform=iOS Simulator,name=iPhone 16' test

# Run a single test class
xcodebuild -project WeatherApi/WeatherApi.xcodeproj -scheme WeatherApi -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:WeatherApiTests/WeatherApiComDataSourceTests test

# Run a single test method
xcodebuild -project WeatherApi/WeatherApi.xcodeproj -scheme WeatherApi -destination 'platform=iOS Simulator,name=iPhone 16' -only-testing:WeatherApiTests/WeatherApiComDataSourceTests/testGetForecast test
```

## Architecture

### Data Flow: Protocol-Driven Abstraction

The app uses a two-layer abstraction to decouple views from API specifics:

1. **`NetworkLayer`** (protocol) — Handles raw HTTP/JSON fetching via Combine publishers. `NetworkLayerImpl` is the production implementation; `NetworkLayerMock` is used in tests with bundled JSON fixtures.

2. **`WeatherDataSource`** (protocol) — Transforms API-specific response models into normalized `WeatherData` structs. Currently `WeatherApiComDataSource` is the only implementation (for weatherapi.com). This design allows adding new weather API providers without changing views or view models.

3. **`WeatherData`** (and related structs in `DataSources/WeatherData.swift`) — The app-internal normalized data model. Views never see API-specific models.

4. **`WeatherApiModel`** (and related structs in `DataSources/WeatherAPIcom/WeatherApiModel.swift`) — The `Decodable` models matching the weatherapi.com JSON response. Mapping to `WeatherData` happens inside `WeatherApiComDataSource`.

### View Architecture

- **`WeatherApiView`** — Root TabView with four tabs: Current ("Here & Now"), Forecast, History, Settings. Creates the shared `WeatherViewModel` and injects it via `.environment()`. Sets up the SwiftData `modelContainer` for `HistoryItemModel`.
- **`WeatherViewModel`** — `@Observable` view model shared across Current and Forecast tabs. Owns the `WeatherDataSource`, handles loading state, formats display values based on user unit preferences (`TempUnits`, `SpeedUnits`, `PressureUnits`).
- **`WeatherView`** — Shared between Current and Forecast tabs (configured via `isForecast` flag).

### Key Patterns

- **User preferences** stored via `@AppStorage` with keys defined in `AppSettings` enum. The API key is stored at `AppSettings.weatherApiKey`.
- **Unit preferences** (temperature, speed, pressure) are enums in `Settings/Units.swift`. View models provide dual-unit values and select based on user setting.
- **SwiftData** used for `HistoryItemModel` persistence (query history).
- **Localization** uses Xcode String Catalogs (`.xcstrings`) at `Localization/Localizable.xcstrings`.
- **Theming** via `WeatherAppTheme` struct in `Localization/Theme.swift`.
- **Weather alerts** are deduplicated client-side (the API returns duplicates) using `Set<WAPIAlert>` with `Hashable` conformance.
- **`CardStyle`** view modifier in `ViewModifiers/` for consistent card styling.

### Test Structure

Unit tests are in `WeatherApi/WeatherApiTests/`. Tests use `NetworkLayerMock` with JSON fixture files from `WeatherApiTests/JSON/WeatherAPIcom/`. The test plan at `WeatherApi/WeatherApi.xctestplan` runs both unit and UI test targets in parallel.
