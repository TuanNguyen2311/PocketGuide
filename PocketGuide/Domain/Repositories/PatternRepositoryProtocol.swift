// MARK: - Domain/Repositories/PatternRepositoryProtocol.swift

import Foundation
import Combine

public protocol PatternRepositoryProtocol {
    func fetchAllPatterns() -> AnyPublisher<[TradingPattern], Error>
    func fetchPatterns(category: PatternCategory) -> AnyPublisher<[TradingPattern], Error>
    func fetchPattern(id: String) -> AnyPublisher<TradingPattern?, Error>
}
