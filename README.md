# Rive Inspector — A Mini DevTool for Exploring `.riv` Files

**Built with Dart + Flutter.**
This project demonstrates the ability to integrate Flutter, Riverpod state management, and Rive’s runtime to create a useful tool for designers and engineers. A live inspector for `.riv` animation files.

---

## Overview

**Rive Inspector** is a lightweight Flutter desktop/web app that:

* Loads any `.riv` file
* Detects **State Machines** and their inputs (Boolean, Number, Trigger)
* Displays an **interactive control panel** for live parameter editing
* Supports **play, pause, restart, scrub**, and **speed control** for timeline animations
* Shows a live **FPS (frames-per-second)** performance badge
* Updates all UI instantly using **Riverpod v2 Notifiers**

---

## Features

| Area                        | Description                                                                          |
| --------------------------- | ------------------------------------------------------------------------------------ |
|  **Rive Runtime Integration** | Imports and renders `.riv` assets with both animation and state machine support.     |
|  **State Machine Discovery** | Automatically enumerates inputs (`SMIInput<bool/double/trigger>`) for each artboard. |
|  **Live Input Controls**    | Toggle booleans, adjust sliders, or fire triggers — updates propagate instantly.     |
|  **Transport Bar**         | Play, pause, restart, and scrub through linear animations.                           |
|  **Performance Badge**      | Real-time FPS ticker using Flutter’s `Ticker` and a moving average.                  |
| **Reactive Architecture** | Clean state separation via Riverpod Notifiers for reproducible behavior.             |

---

## Tech Stack

| Category          | Tech                       |
| ----------------- | -------------------------- |
| Framework         | **Flutter 3.x**, Dart      |
| State Management  | **Riverpod v2 Notifiers**  |
| Animation Runtime | **Rive**                   |
| UI                | Material 3 + custom layout |
| Target            | Web, macOS, Windows, Linux |

---

## Getting Started

1. **Clone & Install**

   ```bash
   git clone https://github.com/yourusername/rive-inspector.git
   cd rive-inspector
   flutter pub get
   ```

2. **Add an Example Rive File**
   Place a `.riv` asset in:

   ```
   assets/rive/example.riv
   ```

   (Try Rive’s official samples: `skills-demo.riv`, `truck.riv`, or export your own.)

3. **Run**

   ```bash
   flutter run -d chrome
   # or desktop target: macos / windows / linux
   ```

---

## Project Structure

```
lib/
 ├── app/
 │    └── app.dart               # Root scaffold + layout
 ├── features/
 │    └── inspector/
 │         ├── state/
 │         │    ├── inspector_state.dart
 │         │    ├── discovered_input.dart
 │         │    └── fps_state.dart
 │         └── widgets/
 │              ├── rive_canvas.dart
 │              ├── inspector_panel.dart
 │              ├── transport_bar.dart
 │              └── fps_badge.dart
 └── main.dart
```

---

## Key Learnings

* **Rive runtime architecture** — understanding artboards, state machines, and controllers.
* **Flutter + Riverpod synergy** — maintaining real-time state without rebuild lag.
* **Tool-building mindset** — thinking about visibility and debugging for motion design workflows.
* **Performance profiling** — lightweight FPS instrumentation for animation tuning.

---

## Future Ideas

* File picker + drag-and-drop `.riv` loading
* Persistent input presets
* Timeline graphs and parameter recording
* Export snapshots for QA or design reviews
* Real-time collaboration via WebSocket sync

---