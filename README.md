# RA2F Ultimate

**Language:** **English** | [Tiếng Việt](./README.vi.md)

[![Price](https://img.shields.io/badge/price-free-22c55e)](#free--open-source)
[![Source](https://img.shields.io/badge/source-open-3b82f6)](#free--open-source)
[![Language](https://img.shields.io/badge/language-Luau-00a2ff)](https://luau.org/)
[![License](https://img.shields.io/badge/license-MIT-f59e0b)](./LICENSE)

**RA2F Ultimate** is a free and open-source Luau automation script for Roll Anime 2 Fight (Anime Rolls) on Roblox. It combines lobby roll/buy farming, tower, portal and raid automation, spin wheel, clone/evolve machines, merchant, upgrades, claims, webhook notifications, and local config management in one interface.

The script has no key system, no paywall, and no user fee.

> This is a community project and is not affiliated with or endorsed by Roblox or the developers of Roll Anime 2 Fight. Use third-party software at your own risk and follow the platform's terms of service.

## Features

- Auto Roll + Auto Buy with unit, rarity, and mutation filters, Buy All, and Keep Gold.
- Native Auto Play, Fight Speed (`x1`/`x2`/`x3`), and Start/Stop at Wave controls.
- Auto Tower join with Infinite Ticket detection.
- Solo Portal automation with auto create, auto start, difficulty/name filters, and owned-portal status.
- Solo Raid automation with auto create/refresh/start, difficulty/map filters, live open/close status, and schedule estimation.
- Auto run return after raid/dungeon/tower runs.
- Auto Spin Wheel and Auto Equip Best.
- Auto Merchant with Buy All and item selection.
- Auto Upgrade with upgrade-type selection.
- Auto Claim Battlepass and Battlepass Quests.
- Auto Clone and Auto Evolve machines with unit selection.
- Discord webhook for unit purchases, portal creation, and raid victory/defeat.
- Fix Lag, Bypass (Luck/Mutation attributes + fight speed), and Remove Other Bases.
- Hide player names with My Name / Other Players / All Players modes.
- Anti-AFK, Auto Reconnect, per-UserId JSON config auto-save, and mobile toggle button.
- Multi-place support: lobby, tower, raid dungeons, and portal dungeons.
- Re-execute safe with reload debounce and full cleanup/unload.

## Installation

Run the following loader in a compatible Luau environment after joining the game:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Truyem/ra2f/refs/heads/main/anime_rolls_hub.luau"))()
```

## Requirements

- A Luau execution environment with `loadstring` and `game:HttpGet` support.
- HTTP requests through `request`, `http_request`, or `syn.request` for Discord webhook notifications.
- File APIs such as `readfile`, `writefile`, and `isfile` for per-UserId config persistence.
- An internet connection for Fluent UI and script resources.

Compatibility depends on the execution environment. Missing APIs may prevent individual features from working even if the interface loads successfully.

## Basic Usage

1. Run the script in Roll Anime 2 Fight (lobby, tower, raid, or dungeon).
2. Configure the Farm tab (units, rarities, mutations, Keep Gold) before enabling Auto Buy.
3. Configure Portal & Raid filters before enabling solo automation.
4. Save happens automatically to `Anime roll to fight_<UserId>.json`; use Info tab for manual save.
5. Verify webhook URL and auto leave/return options before going AFK.
6. Press `RightControl` to minimize or restore the interface (mobile floating button supported).

Configs are stored as `Anime roll to fight_<UserId>.json` inside the executor workspace.

## Repository Files

- [`anime_rolls_hub.luau`](./anime_rolls_hub.luau): main RA2F automation script.
- [`README.vi.md`](./README.vi.md): Vietnamese documentation.
- [`LICENSE`](./LICENSE): MIT License.

## Network & Privacy

The main script only sends data to a Discord webhook when you enable it and enter your own webhook URL (purchase, portal, and raid notifications). Nothing is sent anywhere else.

The main script makes network requests only to:

- Load Fluent UI from its official GitHub source.
- POST to your configured Discord webhook URL when webhook notifications are enabled.

No inventory, units, balances, usernames, or session data are sent to any other external receiver.

## Free & Open Source

The main source is available in [`anime_rolls_hub.luau`](./anime_rolls_hub.luau) for the community to inspect, improve, and contribute to at no cost.

- Do not pay anyone to obtain this script.
- Do not trust reuploads that require a key or payment.
- Download the latest version directly from the official GitHub repository.
- Keep the copyright and license notices when sharing or forking the project.

This project is released under the [MIT License](./LICENSE).

If the project helps you, please consider leaving it a star:

https://github.com/Truyem/ra2f

## Contributing

Bug reports and pull requests are welcome.

1. Fork the repository.
2. Create a branch for your change.
3. Keep changes focused and do not add obfuscated code.
4. Check the Luau syntax before opening a pull request.
5. Describe the changed behavior and how you verified it.

When reporting a bug, include the place (lobby/tower/raid/dungeon), reproduction steps, relevant console logs, and execution environment. Never publish webhook URLs, account tokens, or personal data.

## Credits

- **Truyem789**: creator and maintainer.
- [Fluent](https://github.com/dawid-scripts/Fluent): UI library.
- The Roll Anime 2 Fight community for testing and feedback.

## Disclaimer

This software is provided as-is and may stop working after a game update. The author is not responsible for data loss, account disruption, or other consequences resulting from its use.
