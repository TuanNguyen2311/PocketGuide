// MARK: - Domain/Entities/TradingPattern.swift

import Foundation

// MARK: - Core Entities

public struct TradingPattern: Identifiable, Codable, Hashable {
    public let id: String
    public let category: PatternCategory
    public let group: PatternGroup
    public let nameEn: String
    public let nameVi: String
    public let signal: SignalType
    public let description: String
    public let identification: [String]
    public let psychology: String
    public let tradingSetup: TradingSetup
    public let notes: [String]

    enum CodingKeys: String, CodingKey {
        case id, category, group
        case nameEn = "name_en"
        case nameVi = "name_vi"
        case signal, description, identification, psychology
        case tradingSetup = "trading_setup"
        case notes
    }
}

public struct TradingSetup: Codable, Hashable {
    public let entry: String
    public let target: String
    public let stopLoss: String

    enum CodingKeys: String, CodingKey {
        case entry, target
        case stopLoss = "stop_loss"
    }
}

public enum PatternCategory: String, Codable, CaseIterable {
    case chartPattern = "ChartPattern"
    case candlestick = "Candlestick"

    var displayName: String {
        switch self {
        case .chartPattern: return "Mô Hình Giá"
        case .candlestick: return "Mẫu Hình Nến"
        }
    }

    var subtitle: String {
        switch self {
        case .chartPattern: return "18 mô hình giá cổ điển"
        case .candlestick: return "Nến Nhật & các mẫu hình"
        }
    }

    var iconName: String {
        switch self {
        case .chartPattern: return "chart.xyaxis.line"
        case .candlestick: return "chart.bar.fill"
        }
    }
}

public enum PatternGroup: String, Codable, CaseIterable {
    case reversal = "Reversal"
    case continuation = "Continuation"
    case single = "Single"

    var displayName: String {
        switch self {
        case .reversal: return "Đảo Chiều"
        case .continuation: return "Tiếp Diễn"
        case .single: return "Đơn Nến"
        }
    }
}

// MARK: - Preview Sample Data

extension TradingPattern {
    static let previewBearish = TradingPattern(
        id: "cp001",
        category: .chartPattern,
        group: .reversal,
        nameEn: "Head and Shoulders",
        nameVi: "Đầu và Vai",
        signal: .bearish,
        description: "Mô hình đảo chiều giảm giá xuất hiện cuối xu hướng tăng, gồm 3 đỉnh với đỉnh giữa cao nhất.",
        identification: [
            "Xuất hiện sau xu hướng tăng kéo dài",
            "Gồm 3 đỉnh: vai trái, đầu (cao nhất), vai phải",
            "Đường viền cổ nối 2 đáy giữa các đỉnh",
            "Khối lượng giảm dần từ vai trái → đầu → vai phải"
        ],
        psychology: "Phe mua dần cạn kiệt. Mỗi lần thử lập đỉnh mới đều thất bại.",
        tradingSetup: TradingSetup(
            entry: "Chờ giá đóng cửa dứt khoát dưới neckline.",
            target: "Đo chiều cao từ đỉnh đầu đến neckline, chiếu xuống từ điểm phá vỡ.",
            stopLoss: "Đặt trên đỉnh vai phải hoặc trên neckline."
        ),
        notes: ["Khối lượng tăng vọt khi phá vỡ neckline = tín hiệu mạnh", "Phổ biến và đáng tin cậy nhất"]
    )

    static let previewBullish = TradingPattern(
        id: "cp004",
        category: .chartPattern,
        group: .reversal,
        nameEn: "Double Bottom",
        nameVi: "Đáy Đôi",
        signal: .bullish,
        description: "Mô hình hình chữ W, hai đáy xấp xỉ nhau báo hiệu đảo chiều tăng giá.",
        identification: [
            "Xuất hiện sau xu hướng giảm",
            "Hai đáy xấp xỉ bằng nhau, hình chữ W"
        ],
        psychology: "Phe bán không thể đẩy giá thấp hơn mức hỗ trợ lần 2.",
        tradingSetup: TradingSetup(
            entry: "Chờ giá đóng cửa trên đỉnh giữa 2 đáy.",
            target: "Chiều cao từ đáy lên đỉnh giữa, chiếu lên.",
            stopLoss: "Dưới đáy thứ hai."
        ),
        notes: ["Một trong những mô hình đảo chiều tăng đáng tin cậy nhất"]
    )

    static let previewNeutral = TradingPattern(
        id: "cs005",
        category: .candlestick,
        group: .single,
        nameEn: "Doji",
        nameVi: "Nến Doji",
        signal: .neutral,
        description: "Nến có thân rất nhỏ, thể hiện sự do dự và cân bằng giữa hai phe.",
        identification: ["Giá mở cửa và đóng cửa gần như bằng nhau"],
        psychology: "Thị trường đang do dự về hướng đi tiếp theo.",
        tradingSetup: TradingSetup(
            entry: "Không giao dịch dựa trên Doji đơn lẻ.",
            target: "Phụ thuộc vào xu hướng và vị trí.",
            stopLoss: "Phụ thuộc vào hướng xác nhận."
        ),
        notes: ["Tín hiệu mạnh nhất khi xuất hiện sau xu hướng mạnh"]
    )
}

public enum SignalType: String, Codable {
    case bullish
    case bearish
    case neutral

    var displayName: String {
        switch self {
        case .bullish: return "Tín hiệu Tăng"
        case .bearish: return "Tín hiệu Giảm"
        case .neutral: return "Trung lập"
        }
    }

    var emoji: String {
        switch self {
        case .bullish: return "📈"
        case .bearish: return "📉"
        case .neutral: return "↔️"
        }
    }
}
