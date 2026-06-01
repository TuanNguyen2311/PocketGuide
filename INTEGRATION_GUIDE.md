# POCKET-GUIDE — Hướng Dẫn Tích Hợp Vào Xcode

## Cấu trúc thư mục đã tạo

```
PocketGuide/
├── PocketGuideApp.swift                    ← App entry point
├── Resources/
│   └── data.json                           ← Toàn bộ dữ liệu 18 mô hình + nến
├── Domain/
│   ├── Entities/
│   │   └── TradingPattern.swift            ← Model chính: TradingPattern, SignalType...
│   ├── Repositories/
│   │   └── PatternRepositoryProtocol.swift ← Protocol cho Repository
│   └── UseCases/
│       └── PatternUseCases.swift           ← FetchPatternsUseCase, BookmarkUseCase
├── Data/
│   ├── DataSources/
│   │   └── LocalPatternDataSource.swift    ← Đọc file JSON từ bundle
│   └── Repositories/
│       └── PatternRepository.swift         ← Implementation của protocol
└── Presentation/
    ├── ViewModels/
    │   └── PatternViewModels.swift         ← HomeVM, ListVM, DetailVM, BookmarkVM
    └── Views/
        ├── Home/
        │   └── HomeView.swift              ← Màn hình dashboard
        ├── PatternList/
        │   └── PatternListView.swift       ← Danh sách với filter + search
        ├── PatternDetail/
        │   ├── PatternDetailView.swift     ← Chi tiết + bookmark
        │   └── BookmarkListView.swift      ← Danh sách đã lưu
        └── Common/
            └── PatternIllustrationView.swift ← SVG-style vector drawings
```

---

## Các bước tích hợp vào Xcode

### Bước 1: Tạo Group folders trong Xcode
- Trong Project Navigator, tạo các Group (thư mục) theo cấu trúc trên
- **Quan trọng:** Dùng "New Group" (không phải New Group with Folder) để giữ đúng cấu trúc

### Bước 2: Thêm file vào project
1. Kéo thả từng file `.swift` vào Group tương ứng
2. Đảm bảo **Target membership** được check vào `PocketGuide`

### Bước 3: Thêm data.json vào Bundle
1. Kéo `data.json` vào nhóm `Resources`
2. Trong dialog: chọn **"Copy items if needed"** và check **Target: PocketGuide**
3. Kiểm tra trong Build Phases → Copy Bundle Resources → có `data.json`

### Bước 4: Cấu hình Deployment Target
- Minimum iOS: **16.0** (cần Canvas, NavigationStack, symbolEffect)
- Swift Language Version: **Swift 5** (hoặc 6 với strict concurrency)

### Bước 5: Thêm Accent Color
- Trong `Assets.xcassets`, tạo Color Set tên `AccentColor`
- Gợi ý: `#2E5CE6` (xanh dương) cho light mode

---

## Kiến trúc — Clean Architecture

```
[View] → [ViewModel] → [UseCase] → [Repository Protocol]
                                          ↕
                                   [Repository Impl]
                                          ↕
                                   [LocalDataSource]
                                          ↕
                                      [data.json]
```

**Nguyên tắc:**
- `Domain` không phụ thuộc vào bất kỳ layer nào
- `Data` implement protocol từ `Domain`
- `Presentation` chỉ biết `Domain` entities và `UseCase`

---

## Cơ sở dữ liệu — Local JSON (Lý do chọn)

Dự án này chọn **JSON bundled** thay vì CoreData/SQLite vì:
- ✅ **Offline 100%** — không cần network
- ✅ **Read-only** — dữ liệu cố định, không cần write
- ✅ **Zero setup** — không cần migration, schema
- ✅ **Dễ cập nhật** — chỉ thay file JSON khi có mô hình mới
- ✅ **Nhẹ nhàng** — file JSON < 100KB
- Bookmark được lưu riêng trong `UserDefaults` (chỉ lưu IDs)

---

## Tính năng đã implement

| Tính năng | Status |
|---|---|
| 18 Mô hình giá (đầy đủ nội dung) | ✅ |
| 12 Mẫu hình nến | ✅ |
| Vector illustrations (không dùng bitmap) | ✅ |
| Filter theo nhóm (Đảo chiều / Tiếp diễn) | ✅ |
| Tìm kiếm (Anh + Việt) | ✅ |
| Bookmark (UserDefaults) | ✅ |
| Dark Mode tự động | ✅ |
| Navigation với NavigationStack | ✅ |
| Clean Architecture 3 layers | ✅ |
| Combine + async data loading | ✅ |

---

## Mở rộng tiếp theo (Phase 4)

1. **Thêm nến còn lại:** Bổ sung ~20+ mẫu nến vào `data.json`
2. **matchedGeometryEffect:** Thêm hero animation từ list → detail
3. **Widget:** Hiển thị mô hình ngẫu nhiên trên Home Screen
4. **Share:** Cho phép share screenshot mô hình

---

*Generated for POCKET-GUIDE iOS App — Clean Architecture SwiftUI*
