# RA2F Ultimate

**Ngôn ngữ:** [English](./README.md) | **Tiếng Việt**

[![Price](https://img.shields.io/badge/price-free-22c55e)](#miễn-phí--mã-nguồn-mở)
[![Source](https://img.shields.io/badge/source-open-3b82f6)](#miễn-phí--mã-nguồn-mở)
[![Language](https://img.shields.io/badge/language-Luau-00a2ff)](https://luau.org/)
[![License](https://img.shields.io/badge/license-MIT-f59e0b)](./LICENSE)

**RA2F Ultimate** là script Luau automation miễn phí và mã nguồn mở dành cho Roll Anime 2 Fight (Anime Rolls) trên Roblox. Script gom auto roll/buy ở lobby, auto tower, portal và raid, spin wheel, máy clone/evolve, merchant, upgrade, claim, webhook và quản lý config local vào một giao diện duy nhất.

Script không có key system, không có paywall và không thu phí người dùng.

> Dự án do cộng đồng phát triển, không liên kết hoặc được chứng thực bởi Roblox hay nhà phát triển Roll Anime 2 Fight. Hãy tự chịu trách nhiệm khi sử dụng phần mềm bên thứ ba và tuân thủ điều khoản của nền tảng.

## Tính năng nổi bật

- Auto Roll + Auto Buy với bộ lọc unit, rarity, mutation, Buy All và Keep Gold.
- Auto Play native, Fight Speed (`x1`/`x2`/`x3`) và Start/Stop theo Wave.
- Auto Tower với nhận diện Infinite Ticket.
- Auto Portal solo: tự tạo party, tự start, lọc difficulty/tên portal và trạng thái portal đang sở hữu.
- Auto Raid solo: tự tạo/refresh/start, lọc difficulty/map, trạng thái OPEN/CLOSED trực tiếp và ước tính lịch mở raid.
- Tự quay về sau khi chạy raid/dungeon/tower.
- Auto Spin Wheel và Auto Equip Best.
- Auto Merchant với Buy All và chọn item.
- Auto Upgrade với chọn loại upgrade.
- Auto Claim Battlepass và Battlepass Quest.
- Auto Clone và Auto Evolve với chọn unit.
- Discord webhook cho unit đã mua, portal đã tạo và thắng/thua raid.
- Fix Lag, Bypass (Luck/Mutation + tốc độ fight) và Remove Other Bases.
- Ẩn tên người chơi với chế độ My Name / Other Players / All Players.
- Anti-AFK, Auto Reconnect, config JSON auto-save theo UserId và nút mobile.
- Hỗ trợ nhiều place: lobby, tower, raid dungeon và portal dungeon.
- Chạy lại an toàn với chống reload trùng và cleanup/unload đầy đủ.

## Cài đặt

Chạy đoạn loader sau trong môi trường Luau tương thích khi đã vào game:

```lua
loadstring(game:HttpGet("https://raw.githubusercontent.com/Truyem/ra2f/refs/heads/main/anime_rolls_hub.luau"))()
```

## Yêu cầu

- Môi trường thực thi Luau hỗ trợ `loadstring` và `game:HttpGet`.
- HTTP request qua `request`, `http_request` hoặc `syn.request` cho thông báo Discord webhook.
- File APIs như `readfile`, `writefile` và `isfile` để lưu config theo UserId.
- Kết nối mạng để tải Fluent UI và tài nguyên script.

Khả năng tương thích phụ thuộc vào môi trường thực thi. Nếu thiếu API, một số tính năng có thể không hoạt động dù giao diện vẫn tải được.

## Sử dụng cơ bản

1. Chạy script trong Roll Anime 2 Fight (lobby, tower, raid hoặc dungeon).
2. Cấu hình tab Farm (unit, rarity, mutation, Keep Gold) trước khi bật Auto Buy.
3. Cấu hình bộ lọc Portal & Raid trước khi bật automation solo.
4. Config tự lưu vào `Anime roll to fight_<UserId>.json`; có thể lưu tay trong tab Info.
5. Kiểm tra kỹ webhook URL và tùy chọn auto leave/return trước khi AFK.
6. Nhấn `RightControl` để thu nhỏ hoặc mở lại giao diện (có nút nổi trên mobile).

Config được lưu trong file `Anime roll to fight_<UserId>.json` thuộc workspace của executor.

## File trong repository

- [`anime_rolls_hub.luau`](./anime_rolls_hub.luau): script automation chính cho RA2F.
- [`README.md`](./README.md): tài liệu tiếng Anh mặc định.
- [`LICENSE`](./LICENSE): MIT License.

## Mạng & Quyền riêng tư

Script chính chỉ gửi dữ liệu tới Discord webhook khi bạn tự bật và nhập webhook URL của mình (thông báo mua unit, portal và raid). Không gửi đi nơi nào khác.

Script chính chỉ thực hiện kết nối mạng để:

- Tải Fluent UI từ nguồn GitHub chính thức.
- POST tới Discord webhook URL do bạn cấu hình khi bật thông báo webhook.

Không có inventory, unit, số dư, username hoặc dữ liệu phiên nào bị gửi tới máy chủ bên ngoài khác.

## Miễn phí & Mã nguồn mở

Toàn bộ mã nguồn chính nằm trong [`anime_rolls_hub.luau`](./anime_rolls_hub.luau) và được công khai miễn phí để cộng đồng đọc, kiểm tra, cải tiến và đóng góp.

- Không mua bán hoặc trả phí để nhận script này.
- Không tin các bản reupload yêu cầu key hoặc thanh toán.
- Nên lấy phiên bản mới nhất trực tiếp từ repository GitHub chính thức.
- Khi chia sẻ hoặc fork, vui lòng giữ copyright notice và license notice.

Dự án được phát hành theo [MIT License](./LICENSE).

Nếu dự án hữu ích, hãy tặng repository một Star:

https://github.com/Truyem/ra2f

## Đóng góp

Pull request và báo lỗi đều được hoan nghênh.

1. Fork repository.
2. Tạo branch cho thay đổi của bạn.
3. Giữ thay đổi nhỏ, rõ ràng và không thêm code bị obfuscate.
4. Kiểm tra cú pháp Luau trước khi gửi pull request.
5. Mô tả hành vi đã thay đổi và cách bạn kiểm tra nó.

Khi báo lỗi, hãy cung cấp place (lobby/tower/raid/dungeon), thao tác gây lỗi, log console liên quan và tên môi trường thực thi. Không đăng webhook URL, token tài khoản hoặc dữ liệu cá nhân.

## Credits

- **Truyem789**: tác giả và người duy trì dự án.
- [Fluent](https://github.com/dawid-scripts/Fluent): thư viện giao diện.
- Cộng đồng Roll Anime 2 Fight: kiểm thử và đóng góp phản hồi.

## Disclaimer

Phần mềm được cung cấp nguyên trạng và có thể ngừng hoạt động sau mỗi bản cập nhật game. Tác giả không chịu trách nhiệm cho mất dữ liệu, gián đoạn tài khoản hoặc hậu quả phát sinh từ việc sử dụng script.
