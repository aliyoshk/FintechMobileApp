# Mintyn Dashboard — Mobile Assessment

Flutter implementation of the **Dashboard** and **Cards** screens from the Mintyn
Bank Figma design, built with Clean Architecture, mocked data, and a simulated
real-time feed.

## Demo

> 📹 _Add your screen recording/GIF here before submitting —
> e.g. `![demo](docs/demo.gif)` or a link to a short video._

## Scope

The assessment brief scopes this to **Dashboard and Cards only**. Built against
that:

- **Dashboard (Home)** — Balance card with Mastercard branding, QR shortcut,
  Add Cash/Send Money action buttons, quick actions row, and transaction
  history with Weekly/Monthly/Today filters. Hamburger icon opens the Profile
  Drawer.
- **Profile Drawer** — Side drawer showing user info with badge, Profile
  Settings (E-Statement, Credit Card, Settings), Notification toggle,
  Language/Country options, and Logout. The **Credit Card** row navigates to
  the Cards screen.
- **Your Card** — Physical/Virtual card tabs, card carousel with scale/fade
  animations, Freeze Card/Reveal actions, and Card Settings with toggles.
- **Card Transaction** — Drill-down page showing the selected card,
  spending area chart, and card-specific transaction history.

**Navigation flow:** Dashboard → (drawer) → Credit Card → Cards page →
(card settings) → Card Transaction page. No bottom navigation bar — matches
the Figma design exactly.

## Getting started

```bash
flutter pub get
flutter run
```

Runs against mock data by default. No backend, API key, or network access is
required — everything is seeded from `assets/mock/*.json`.

To run the tests:

```bash
flutter test
```

## Architecture — Clean Architecture

The project follows **Clean Architecture** with three distinct layers per
feature, ensuring dependencies always point inward:

```
Presentation → Domain ← Data
```

```
lib/
├── core/
│   ├── constants/       # App-wide constants
│   ├── theme/           # Colors, text styles, spacing tokens
│   ├── environment/     # AppEnvironment + EnvironmentConfig (mock/remote)
│   ├── di/              # Shared providers (Dio instance)
│   ├── errors/          # Failure hierarchy
│   ├── network/         # Network exceptions
│   ├── utils/           # Currency formatting
│   └── widgets/         # Shimmer, error banner, spending chart
│
├── features/
│   ├── dashboard/
│   │   ├── data/
│   │   │   ├── datasource/     # DashboardLocalDatasource (raw asset loading)
│   │   │   ├── dto/            # DashboardSummaryDto, TransactionDto (JSON-aware)
│   │   │   ├── mapper/         # DashboardMapper (DTO → Entity)
│   │   │   └── repositories/   # MockDashboardRepositoryImpl, RemoteDashboardRepositoryImpl
│   │   │
│   │   ├── domain/
│   │   │   ├── entities/       # DashboardSummary, Transaction, QuickAction (pure Dart)
│   │   │   ├── repositories/   # DashboardRepository (interface / contract)
│   │   │   └── usecases/       # WatchDashboardUseCase
│   │   │
│   │   └── presentation/
│   │       ├── pages/          # DashboardPage, ActivityPage
│   │       ├── providers/      # Riverpod providers + use case wiring
│   │       └── widgets/        # TotalBalanceCard, QuickActions, TransactionTile, etc.
│   │
│   └── cards/
│       ├── data/
│       │   ├── datasource/     # CardsLocalDatasource
│       │   ├── dto/            # BankCardDto
│       │   ├── mapper/         # CardMapper
│       │   └── repositories/   # MockCardsRepositoryImpl, RemoteCardsRepositoryImpl
│       │
│       ├── domain/
│       │   ├── entities/       # BankCard, CardNetwork
│       │   ├── repositories/   # CardsRepository (interface)
│       │   └── usecases/       # WatchCardsUseCase, ToggleFreezeCardUseCase
│       │
│       └── presentation/
│           ├── pages/          # CardsPage, CardTransactionPage
│           ├── providers/      # Riverpod providers + use case wiring
│           └── widgets/        # CardCarousel, BankCardWidget
│
└── main.dart
```

### Layer responsibilities

| Layer | Responsibility | Dependencies |
|-------|---------------|-------------|
| **Domain** | Entities (pure Dart), repository contracts, use cases | None (innermost) |
| **Data** | DTOs (JSON-aware), mappers, datasources, repository implementations | Domain |
| **Presentation** | Pages, widgets, Riverpod providers | Domain |

### Why each layer matters

- **Domain entities** (`DashboardSummary`, `BankCard`, `Transaction`) are pure
  Dart classes with no JSON parsing. Business rules like `maskedNumber`,
  `isCredit`, and `copyWith` live here.

- **DTOs** (`DashboardSummaryDto`, `BankCardDto`) own the `fromJson` contract.
  If the backend renames `accountHolderName` → `customer_name`, only the DTO
  and its mapper change — entities, use cases, and UI remain untouched.

- **Mappers** (`DashboardMapper`, `CardMapper`) convert DTOs → domain entities,
  keeping the data and domain layers decoupled.

- **Datasources** (`DashboardLocalDatasource`, `CardsLocalDatasource`) handle
  raw data access (asset loading for mocks, Dio calls for production).

- **Use cases** (`WatchDashboardUseCase`, `WatchCardsUseCase`,
  `ToggleFreezeCardUseCase`) provide a single-responsibility entry point for
  each operation. Even with simple delegation today, they give a clear seam for
  adding caching, analytics, or logging without touching repositories or UI.

- **Repository interfaces** live in `domain/`, not `data/`, because the
  presentation depends on the abstraction — the Dependency Inversion Principle.

### State management

**Riverpod**, via `StreamProvider` for both features. This gives
`AsyncValue<T>` (loading/data/error) for free, and pages use `.when(...)` to
render each state explicitly — including a retryable error banner when the
simulated connection drops.

The dependency chain through providers:

```
StreamProvider → UseCase → Repository Interface → Repository Implementation → Datasource
```

### Environment switching (mock ↔ remote)

```bash
flutter run                          # defaults to mock
flutter run --dart-define=ENV=remote # routes to Remote*RepositoryImpl
```

A single provider factory per feature selects the implementation:

```dart
final dashboardRepositoryProvider = Provider<DashboardRepository>((ref) {
  switch (EnvironmentConfig.current) {
    case AppEnvironment.mock:
      return MockDashboardRepositoryImpl(DashboardLocalDatasource());
    case AppEnvironment.remote:
      return RemoteDashboardRepositoryImpl(ref.watch(dioProvider));
  }
});
```

Wiring a real backend means implementing `RemoteDashboardRepositoryImpl` and
`RemoteCardsRepositoryImpl` — zero changes to use cases, providers, or UI.

### Simulating "real-time" data

`MockDashboardRepositoryImpl.watchDashboard()` yields an initial snapshot, then
emits periodic balance drift and occasionally throws to simulate a dropped
connection. The UI renders a retryable error banner — `ref.invalidate(...)`
restarts the stream.

`MockCardsRepositoryImpl` streams card updates via a broadcast controller so
freeze/unfreeze reflects immediately without re-fetching.

### Avoiding unnecessary rebuilds

- `StreamProvider.autoDispose` releases resources when a page isn't visible.
- `IndexedStack` keeps all tabs' state alive across tab switches.
- Narrow widget splits ensure a balance tick doesn't rebuild the full tree.

### Animations

- Balance/spending amounts: `AnimatedSwitcher` (fade + slide)
- Transaction list: staggered fade/slide on load
- Quick-action buttons: scale-down on press
- Card carousel: scale/fade side cards via `PageController`
- Card number/CVV: crossfade between masked and revealed
- Freeze: opacity animation + active state button swap
- Filter chips: animated container transitions
- Page dots: animated width changes
- Loading: custom shimmer placeholder

### Testing

```
test/
├── core/
│   └── currency_formatter_test.dart                  # unit — formatting
├── features/dashboard/
│   ├── watch_dashboard_usecase_test.dart              # unit — use case
│   └── mock_dashboard_repository_test.dart            # unit — stream emissions
├── features/cards/
│   ├── bank_card_test.dart                            # unit — masking, copyWith
│   ├── cards_usecases_test.dart                       # unit — WatchCards, ToggleFreeze
│   └── mock_cards_repository_test.dart                # unit — toggleFreeze behavior
└── widget_test.dart                                    # widget — DashboardPage
```

Tests cover all three layers: **domain** (use cases, entities), **data**
(repository implementations), and **presentation** (widget rendering with
provider overrides).

## Known limitations / notes

- `RemoteDashboardRepositoryImpl` / `RemoteCardsRepositoryImpl` are
  unimplemented stubs — there is no live Mintyn API for this assessment.
- Card imagery/colors are approximate; adjust `assets/mock/cards.json` once
  final design tokens are available.
- Responsive layout uses relative sizing but hasn't been tablet-tested.

## Future improvements

- Wire remote repository implementations to a real backend once available.
- Add golden tests for `TotalBalanceCard` and `BankCardWidget`.
- Extract a design-system package if this grows beyond two features.
