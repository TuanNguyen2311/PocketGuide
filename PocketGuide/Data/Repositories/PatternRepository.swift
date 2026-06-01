// MARK: - Data/Repositories/PatternRepository.swift

import Foundation
import Combine

final class PatternRepository: PatternRepositoryProtocol {
    private let dataSource: LocalPatternDataSource

    init(dataSource: LocalPatternDataSource = LocalPatternDataSource()) {
        self.dataSource = dataSource
    }

    func fetchAllPatterns() -> AnyPublisher<[TradingPattern], Error> {
        dataSource.loadAll()
    }

    func fetchPatterns(category: PatternCategory) -> AnyPublisher<[TradingPattern], Error> {
        dataSource.loadAll()
            .map { $0.filter { $0.category == category } }
            .eraseToAnyPublisher()
    }

    func fetchPattern(id: String) -> AnyPublisher<TradingPattern?, Error> {
        dataSource.loadAll()
            .map { $0.first { $0.id == id } }
            .eraseToAnyPublisher()
    }
}
