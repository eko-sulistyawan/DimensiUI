# DimensiUI

DimensiUI adalah hasil rebuild dari **Fluent 1.1.0** dengan penyesuaian tema bawaan (`Dimensi`), utilitas kontrol aksen dinamis (`SetAccent`), pembersihan UI (`Destroy`), serta konfigurasi folder bawaan `DimensiUISettings`.

## Struktur Proyek
- `src/` — Inti library (`init.lua`, `Creator.lua`, `Icons.lua`), `Components/`, `Elements/`, `Themes/` (termasuk `Dimensi.lua`), `Acrylic/`, dan `Packages/Flipper/`.
- `Addons/` — `SaveManager.lua` dan `InterfaceManager.lua` (menggunakan folder `DimensiUISettings`).
- `build/` — Konfigurasi build Luau (`init.luau`, `header.luau`, `darklua.json`, `modules/`).
- `Example.lua` & `Example.client.lua` — Contoh penggunaan komponen dan integrasi addon.

## Credits & Attribution
- Dibangun di atas fondasi **Fluent Interface Suite** (`dawid-scripts/Fluent`, lisensi MIT) beserta modul/aset pendukungnya (`Acrylic`, `Flipper`, `Lucide Icons`).
