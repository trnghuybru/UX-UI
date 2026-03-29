# Design System Document

## 1. Overview & Creative North Star

### Creative North Star: "The Nocturnal Guardian"
This design system is built to provide clarity in moments of chaos. It moves away from the flat, utilitarian "app template" look, embracing a high-end editorial aesthetic that prioritizes atmospheric depth and rapid information processing. The goal is to create a digital environment that feels protective and authoritative—a "Nocturnal Guardian" that uses a dark, sophisticated palette to reduce cognitive load while highlighting critical data through vibrant, urgent signals.

By utilizing intentional asymmetry and a "glass-on-charcoal" layering philosophy, the UI avoids the rigid constraints of a standard grid. Instead, it feels like a high-end dashboard where data floats in a structured, multi-dimensional space.

---

## 2. Colors

The palette is rooted in deep, ink-like tones to ensure maximum contrast for status alerts.

### Surface & Foundation
*   **Deep Backgrounds:** Use `surface` (#0a0e14) as the base anchor.
*   **The "No-Line" Rule:** Sectioning must be achieved through tonal shifts, not lines. To separate content, transition from `surface` to `surface_container_low` (#0f141a) or `surface_bright` (#262c36). **1px solid borders for sectioning are strictly prohibited.**
*   **Surface Hierarchy & Nesting:** Use the `surface_container` tiers to create organic depth. For example, place a `surface_container_high` card inside a `surface_container` section to imply a physical lift.

### Accent & Alert Logic
*   **SOS/Critical:** Use `error` (#ff6e84) for high-urgency alerts. It should be paired with `on_error` for text to maintain accessibility.
*   **Warning/Urgent:** Use `secondary` (#ff7350). This vibrant orange-red provides high visibility without the "stop" connotation of pure red.
*   **Information/Advisory:** Use `tertiary` (#ffe483) for cautionary weather updates and `primary` (#89acff) for general system info.
*   **Signature Textures:** For high-impact areas like the Weather Hero card or SOS button, use a subtle linear gradient from `primary` (#89acff) to `primary_dim` (#0f6df3) to add "soul" and visual weight.

---

## 3. Typography

The typography strategy pairs **Manrope** (Headlines) with **Inter** (Body/UI) to balance editorial sophistication with technical precision.

*   **Display & Headlines (Manrope):** These are the "voice" of the app. Use `display-lg` for current temperatures or critical alert titles. The geometric nature of Manrope provides a modern, authoritative feel.
*   **Titles & Body (Inter):** Inter is used for all functional data. Use `title-md` for card headers and `body-md` for descriptive weather reports.
*   **Labels (Inter):** Small-scale data (wind speed, timestamps) uses `label-md` or `label-sm`. These must always use `on_surface_variant` (#a8abb3) to keep them secondary to primary headlines.

---

## 4. Elevation & Depth

This system replaces traditional box-shadows with **Tonal Layering** and **Glassmorphism**.

*   **The Layering Principle:** Depth is communicated by "stacking" container tokens. A card should be `surface_container_highest` (#20262f) sitting on a `surface` (#0a0e14) background.
*   **Ambient Shadows:** For "floating" elements like floating action buttons (FABs) or top-level alerts, use a shadow with a 24px blur and 6% opacity. The shadow color should be a tinted `#000000` to ground the element in the dark environment.
*   **Glassmorphism:** For overlays or navigation bars, use `surface_container` with a 16px backdrop-blur and 80% opacity. This allows the vibrant colors of the map or weather icons to bleed through the UI, creating a high-end, integrated feel.
*   **The "Ghost Border" Fallback:** If a container needs definition against an identical background, use `outline_variant` (#44484f) at **15% opacity**. Never use 100% opaque outlines.

---

## 5. Components

### Buttons
*   **Primary (SOS/Action):** Rounded `xl` (1.5rem). Use the `primary_container` gradient.
*   **Secondary (Outlined):** Use the "Ghost Border" rule with `on_surface` text.

### Cards
*   **Standard Weather Card:** `md` (0.75rem) or `lg` (1.0rem) corner radius. Use `surface_container_low`. No borders.
*   **Emergency Alert Card:** Use a `secondary_container` background with `on_secondary_container` text to ensure the entire card demands attention.

### Lists & Inputs
*   **Lists:** Forbid divider lines. Use `spacing.4` (1rem) of vertical white space to separate items.
*   **Input Fields:** `surface_container_highest` background with a `sm` (0.25rem) radius. Labels should use `label-md` in `on_surface_variant`.

### Specialty Components (App Specific)
*   **Alert Pulse:** Critical SOS icons should feature a subtle radial glow using `error_dim` at 20% opacity to simulate a pulsing physical light.
*   **Weather Chronology:** Use a horizontal scrolling container with `surface_container_high` cards to show hourly forecasts, utilizing the `md` roundedness.

---

## 6. Do's and Don'ts

### Do
*   **Do** use `surface_container_lowest` for the deepest parts of the UI, like the background behind a map.
*   **Do** prioritize the Typography Scale; use `display-sm` for hero numbers to create an editorial hierarchy.
*   **Do** use `full` (9999px) roundedness for status chips and toggle switches.

### Don't
*   **Don't** use pure white (#FFFFFF) for body text; use `on_surface` (#f1f3fc) to prevent eye strain in dark mode.
*   **Don't** use 1px dividers. If a separation is needed, use a `px` height `surface_variant` line at 20% opacity.
*   **Don't** use sharp corners. Every element should have at least a `sm` (0.25rem) radius to maintain the system's approachable, modern feel.