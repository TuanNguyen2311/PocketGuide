// MARK: - Domain/UseCases/FetchPatternsUseCase.swift

import Foundation
import Combine

// MARK: - Fetch All Patterns Use Case

public final class FetchPatternsUseCase {
    private let repository: PatternRepositoryProtocol

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(category: PatternCategory) -> AnyPublisher<[TradingPattern], Error> {
        return repository.fetchPatterns(category: category)
    }

    public func executeAll() -> AnyPublisher<[TradingPattern], Error> {
        return repository.fetchAllPatterns()
    }
}

// MARK: - Fetch Single Pattern Use Case

public final class FetchPatternDetailUseCase {
    private let repository: PatternRepositoryProtocol

    public init(repository: PatternRepositoryProtocol) {
        self.repository = repository
    }

    public func execute(id: String) -> AnyPublisher<TradingPattern?, Error> {
        return repository.fetchPattern(id: id)
    }
}

// MARK: - Bookmark Use Case

public final class BookmarkUseCase {
    private let userDefaults: UserDefaults
    private static let key = "bookmarked_pattern_ids"

    public init(userDefaults: UserDefaults = .standard) {
        self.userDefaults = userDefaults
    }

    public func isBookmarked(_ patternId: String) -> Bool {
        bookmarkedIds().contains(patternId)
    }

    public func toggleBookmark(_ patternId: String) {
        var ids = bookmarkedIds()
        if ids.contains(patternId) {
            ids.remove(patternId)
        } else {
            ids.insert(patternId)
        }
        userDefaults.set(Array(ids), forKey: Self.key)
    }

    public func bookmarkedIds() -> Set<String> {
        let array = userDefaults.stringArray(forKey: Self.key) ?? []
        return Set(array)
    }
}
