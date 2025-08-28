# YalaPay — B2B Invoicing & Cheque Management (Flutter)

A Flutter app that streamlines B2B invoice payments and cheque management with dashboards, CRUD screens, and reports. Phase 1 focuses on UI/logic with JSON; Phase 2 adds Firestore, Firebase Storage, SQLite (Floor), and Firebase Auth.

## 🗂 Phases
- **Phase 1**: UI/UX, navigation, entities & repositories using in-memory/JSON data; working screens for login, dashboard, customers, invoices, payments, cheque flows, and reports. :contentReference[oaicite:6]{index=6}
- **Phase 2**: Cloud Firestore data model + repositories; cheque images in Firebase Storage; SQLite (Floor) for static data; init DB from assets; signup/signin with Firebase Auth. :contentReference[oaicite:7]{index=7}

## ✨ Core Use Cases
- Login (users from `users.json` in phase 1; Firebase Auth in phase 2). :contentReference[oaicite:8]{index=8}
- Dashboard summaries (invoices & cheques). :contentReference[oaicite:9]{index=9}
- Customers: list/search/add/update/delete; auto IDs. :contentReference[oaicite:10]{index=10}
- Invoices: CRUD, auto number, balance calculation, related payments. :contentReference[oaicite:11]{index=11}
- Payments: handle cheque/bank transfer/card, with cheque details & status. :contentReference[oaicite:12]{index=12}
- Cheque depositing workflow & status updates; reports for invoices/cheques. :contentReference[oaicite:13]{index=13}
- Phase 2 add-ons: Firestore queries server-side; upload/delete cheque images in Firebase Storage; seed Firestore on first run; static refs in local SQLite (Floor). :contentReference[oaicite:14]{index=14}

## 🧱 Tech
- Flutter/Dart, Provider (state management)
- Firebase Auth, Cloud Firestore, Firebase Storage
- SQLite (Floor) for static data :contentReference[oaicite:15]{index=15}

