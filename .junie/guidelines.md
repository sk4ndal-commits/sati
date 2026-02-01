1) Intent (Produktabsicht)

Sati ist ein Behavioral-Finance-Tracker, der Automatisierung bewusst gegen Achtsamkeit eintauscht.
Die App hilft Nutzer:innen, ihr Ausgaben- und Einnahmenverhalten korrekt, reflektiert und nachhaltig zu verstehen — manuell, offline-first und mit gezielter Reibung an den richtigen Stellen.

Ziel ist nicht „mehr Daten“, sondern bessere Entscheidungen.

Primary Outcomes

Korrektes, bewusstes Erfassen von Einnahmen & Ausgaben (keine Schätzung, kein Raten)

Verhaltensfeedback im Moment der Entscheidung (Intent Prompt)

Kontinuierliche Budgetkontrolle (statt Monatsende-Schock)

Regelmäßige Reflexion durch kurze, strukturierte Reviews

Vertrauen in Zahlen – auch bei mehreren Jobs / unregelmäßigem Einkommen

Product Principles

Awareness over Automation
Alles, was Verhalten beeinflusst, muss vom Nutzer bewusst bestätigt werden.

Accuracy beats Convenience
Lieber manuell & korrekt als automatisch & falsch.

Friction by Design (gezielt)
Reibung nur dort, wo sie Denken auslöst (nicht beim Tippen).

Explainable Logic only
Keine „Black Box“-Insights. Jede Empfehlung ist regelbasiert und nachvollziehbar.

Offline-first Trust
Kernfunktionen funktionieren ohne Account, Internet oder Cloud.

Scalable Foundation
Datenmodell erlaubt Wachstum (mehr Einkommen, Budgets, Perioden), UI bleibt bewusst schlank.

2) What Sati is NOT (Non-Goals / Guardrails)

Sati ist nicht:

eine automatische Banking- oder Multibanking-App

ein Ersatz für persönliche Finanzberatung oder Steuerberatung

ein Investment-, Krypto- oder Portfolio-Tracker

ein KI-Coach, der Verhalten „interpretiert“

ein Gamification-Tool mit Badges, Streaks oder Rankings

ein Vergleichs- oder Angebotsportal

ein Social- oder Sharing-Produkt

Out of Scope (MVP):

Bank-Sync, PSD2, Auto-Import

Auto-Kategorisierung oder Merchant-Erkennung

Prognosen, Cashflow-Simulationen, KI-Texte

Multi-Device Live-Sync

Gemeinsame Haushalte / Collaboration

Steuer- oder Netto-Optimierung

3) Scope & Feature Boundaries (MVP)
   Foundation (Blocker)

Lokale Persistenz (offline-first)

Zeitbasierte Struktur (Monat / Woche als logische Perioden)

Alle Daten eindeutig einem Zeitraum zuordenbar

Core (MVP)
Manuelles Logging

Einnahmen & Ausgaben manuell erfassen

Pflicht: Betrag, Typ, Kategorie

Optional: Notiz, Datum

Entry ≤ 20 Sekunden

Strukturierte Einkommen

Mehrere Einkommensquellen (z. B. Job A, Job B)

Einnahmen immer einer Quelle zugeordnet

Optional: erwarteter Betrag + Rhythmus

Budgeting

Monatsbudgets pro Kategorie (Envelope-Prinzip)

Sofortige Anzeige „verbleibend“

Optionaler Rollover

Behavioral Features (USP, P0)

Intent Prompt bei Ausgaben > X €

„Geplant?“ (ja/nein)

„Gefühl?“ (1–5)

Budget Breach Moments

Warnung bei 80 % Budgetverbrauch

Lokal, freundlich, einmal pro Zeitraum

Weekly Review Ritual

Top-3 Kategorien

Ungeplante Ausgaben gesamt

Eine regelbasierte Anpassungsempfehlung

Insight (minimal, vertrauenswürdig)

Monatsübersicht:

Einnahmen vs. Ausgaben

Kategorieverteilung

Gesamtspielraum

Ownership

Export (CSV/JSON)

Lokales Backup

Monetarisierung (vorbereitet, aber getrennt)

Optionaler Login + Cloud-Backup (Supabase)

App bleibt vollständig nutzbar ohne Account

4) Tech Stack & Architektur (Flutter)
   Flutter Version & Tooling

Flutter stable (aktueller stable Channel)

Dart ≥ 3.x

Lints: flutter_lints + projekt-spezifisch

Format: dart format (verpflichtend)

Architectural Defaults

Layered Architecture (pragmatisch Clean):

presentation/ – Screens, Widgets, UI State

application/ – Use Cases, Orchestrierung, Regeln

domain/ – Entities, Value Objects, Interfaces

data/ – Drift Tables, Repositories, Mappers

State Management & DI: riverpod

Eine Verantwortung pro Layer. Keine Abkürzungen.

Local Data (Offline-first)

Lokale DB: Drift (SQLite)

UI greift nie direkt auf DB zu

Alle Schreiboperationen laufen über Use Cases

Supabase (Backup only)

Supabase Auth (E-Mail/Passwort)

Backup/Restore von DB-Snapshots

Kein Live-Sync-Modell

Guest-Mode immer vollständig nutzbar

5) Coding Guidelines (Dart / Flutter)
   General

Code muss lesbar ohne Kontext sein.

Prefer kleine, klare Widgets statt komplexer build()-Methoden.

Side Effects (IO, Navigation, Notifications) nicht im UI Layer.

Jede Funktion muss testbar sein, aber:

Keine Tests schreiben. Keine Tests ausführen.

Naming

Dateien/Ordner: snake_case

Klassen: PascalCase

Methoden/Variablen: camelCase

Riverpod: somethingProvider, somethingController

Null Safety & Types

Kein dynamic im Business-Code.

late nur mit Begründung.

Prefer sealed / freezed für UI-States & Result-Typen.

Error Handling

Keine stillen Fehler.

Fehler werden entweder:

klar im UI kommuniziert, oder

im Application Layer behandelt & geloggt

Prefer Result-Typen statt throw im UI.

Data Modeling

Domain Entities sind immutable.

Drift Models ≠ Domain Entities.

IDs konsistent (UUID oder int, aber einheitlich).

Jede Tabelle unterstützt createdAt, updatedAt.

Behavioral Logic (wichtig)

Regeln (80 %, ungeplant, Review-Vorschläge) liegen im Application Layer

Keine „intelligenten“ Heuristiken ohne Erklärung

Jede Empfehlung muss deterministisch & erklärbar sein

UI Guidelines (Achtsamkeit unterstützen)

Primäre Aktion immer sichtbar: „+ Eintrag“

Keine Dashboard-Überladung

Formulare:

minimale Pflichtfelder

alles andere optional / später

Copy:

neutral

nicht wertend

keine Schuld-Sprache

Accessibility & UX

Touch Targets ≥ 44px

Klarer Kontrast

Ruhige Farben (keine Alarmfarben für Geld)

Verhalten lenken, nicht bestrafen

Performance

Rebuilds minimieren (const, selektive Provider)

Listen mit ListView.builder

Keine teuren Berechnungen im UI

Leitgedanke (nicht verhandelbar)

Sati ist kein Tool, das dir Arbeit abnimmt.
Es ist ein Tool, das dir Verantwortung zurückgibt.

Wenn eine Entscheidung zwischen Bequemlichkeit und Bewusstsein steht,
entscheidet sich Sati immer für Bewusstsein.