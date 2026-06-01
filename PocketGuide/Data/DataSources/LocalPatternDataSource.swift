// MARK: - Data/DataSources/LocalPatternDataSource.swift

import Foundation
import Combine

// MARK: - Raw Decodable Model (matching JSON exactly)

struct PatternDataContainer: Decodable {
    let chartPatterns: [TradingPattern]
    let candlestickPatterns: [TradingPattern]

    enum CodingKeys: String, CodingKey {
        case chartPatterns = "chart_patterns"
        case candlestickPatterns = "candlestick_patterns"
    }
}

// MARK: - Local Data Source

final class LocalPatternDataSource {
    private var cachedPatterns: [TradingPattern]?

    func loadAll() -> AnyPublisher<[TradingPattern], Error> {
        if let cached = cachedPatterns {
            return Just(cached)
                .setFailureType(to: Error.self)
                .eraseToAnyPublisher()
        }

        return Future<[TradingPattern], Error> { [weak self] promise in
            DispatchQueue.global(qos: .userInitiated).async {
                guard let url = Bundle.main.url(forResource: "data", withExtension: "json") else {
                    promise(.failure(DataSourceError.fileNotFound))
                    return
                }

                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    let container = try decoder.decode(PatternDataContainer.self, from: data)
                    let all = container.chartPatterns + container.candlestickPatterns
                    self?.cachedPatterns = all
                    promise(.success(all))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }
}

enum DataSourceError: LocalizedError {
    case fileNotFound
    case decodingFailed

    var errorDescription: String? {
        switch self {
        case .fileNotFound: return "Không tìm thấy file dữ liệu."
        case .decodingFailed: return "Lỗi đọc dữ liệu."
        }
    }
}
