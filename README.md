# Crewmeister Absence Manager – Flutter

A submission for the **Crewmeister Front‑End Coding Challenge** rebuilt in **Flutter 3** following **Clean Architecture** and **Bloc/Cubit** state‑management.

---

## ✨ Implemented requirements

| Requirement                                                        | Status |
| ------------------------------------------------------------------ | :----: |
| Show the first 10 absences, paginate on scroll                     |    ✅   |
| Display employee name, type, period, member/admitter notes, status |    ✅   |
| Display total number of absences                                   |    ✅   |
| Filter absences by type                                            |    ✅   |
| Filter absences by date range                                      |    ✅   |
| Loading, empty and error states                                    |    ✅   |
| Shimmer skeleton while loading                                     |    ✅   |

*(Bonus iCal export is **not** implemented.)*

---

## 🗂 Project structure (Clean Architecture)

```text
lib/
├── core/               # cross‑cutting concerns (network, errors, utils)
├── features/
│   └── absences/
│       ├── data/       # DTOs · datasources · mappers · repository impl
│       ├── domain/     # entities · repositories → use‑cases
│       └── presentation/
│           ├── cubit/  # AbsenceCubit & states
│           ├── pages/  # AbsencesPage (UI)
│           └── widgets/# AbsenceCard, StatusPill, Note, …
└── api/                # local package simulating remote API (JSON assets)
```

### 🔄 Data‑flow overview

```text
JSON assets → AbsenceApi → DTOs
            ↘︎               ↑
              RemoteDataSource
                    ↘︎        (Either<Failure, DTO>)
               AbsenceRepositoryImpl
                       ↘︎     (Either<Failure, Entity>)
                     GetAbsences use‑case
                              ↘︎
                           AbsenceCubit
                              ↘︎
                            UI Widgets
```

---

## 📦 Dependencies

| Package              | Version | Purpose                            |
| -------------------- | ------- | ---------------------------------- |
| **flutter\_bloc**    | ^9.1.1  | Cubit/BLoC state‑management        |
| **dartz**            | ^0.10.1 | Functional `Either` & Right/Left   |
| **equatable**        | ^2.0.7  | Value equality                     |
| **json\_annotation** | ^4.9.0  | Code‑gen (with `build_runner`) |
| **intl**             | ^0.20.2 | Date formatting                    |
| **get\_it**          | ^8.0.3  | Simple service locator             |
| **shimmer**          | ^3.0.0  | Skeleton loader effect             |
| **mocktail**         | ^1.0.4  | Mocking in tests                   |
| **bloc\_test**       | ^10.0.0 | Cubit/BLoC test helpers            |
| **absence\_api**     | local   | Loads & paginates JSON (see below) |


## 🛠 Local package `absence_api`

* Located in **`/api`**.
* Contains DTOs (`AbsenceData`, `MemberData`, …) and `AbsenceApi` that merges, sorts & paginates in memory.

### Generate the DTOs

```bash
cd api
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
cd ..
```

Run this **once after cloning** (or whenever you change the DTOs).

---

## 🚀 Running the app

```bash
# clone
git clone <repo‑url>
cd crewmeister_absence_manager

# get root packages
flutter pub get

# build DTOs in local api/ package (see above)
flutter pub run build_runner build --delete-conflicting-outputs

# launch
flutter run
```

> Requires **Flutter 3.22+** and **Dart 3.3+**.

---

## 🧪 Running tests

```bash
flutter test    # runs unit & widget tests
```

The suite covers datasources, mappers, repository logic, Cubit state flow, and key widgets such as `AbsenceCard`, `StatusPill`, and `Note`.

---
