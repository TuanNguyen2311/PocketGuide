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
