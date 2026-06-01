// MARK: - Presentation/ViewModels/HomeViewModel.swift

import Foundation
import Combine
import SwiftUI

// MARK: - Home ViewModel

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var totalChartPatterns: Int = 0
    @Published var totalCandlestickPatterns: Int = 0
    @Published var isLoading: Bool = false

    private let fetchUseCase: FetchPatternsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(fetchUseCase: FetchPatternsUseCase = FetchPatternsUseCase(repository: PatternRepository())) {
        self.fetchUseCase = fetchUseCase
        loadCounts()
    }

    private func loadCounts() {
        isLoading = true
        fetchUseCase.executeAll()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in self?.isLoading = false },
                receiveValue: { [weak self] patterns in
                    self?.totalChartPatterns = patterns.filter { $0.category == .chartPattern }.count
                    self?.totalCandlestickPatterns = patterns.filter { $0.category == .candlestick }.count
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}

// MARK: - Pattern List ViewModel

@MainActor
final class PatternListViewModel: ObservableObject {
    @Published var patterns: [TradingPattern] = []
    @Published var filteredPatterns: [TradingPattern] = []
    @Published var selectedGroup: PatternGroup?
    @Published var searchText: String = ""
    @Published var isLoading: Bool = false
    @Published var errorMessage: String?

    let category: PatternCategory
    @Published var availableGroups: [PatternGroup] = []

    private let fetchUseCase: FetchPatternsUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        category: PatternCategory,
        fetchUseCase: FetchPatternsUseCase = FetchPatternsUseCase(repository: PatternRepository())
    ) {
        self.category = category
        self.fetchUseCase = fetchUseCase
        setupBindings()
        loadPatterns()
    }

    private func setupBindings() {
        Publishers.CombineLatest($patterns, $selectedGroup)
            .combineLatest($searchText)
            .map { combined, search in
                let (patterns, group) = combined
                var result = patterns
                if let group = group {
                    result = result.filter { $0.group == group }
                }
                if !search.isEmpty {
                    result = result.filter {
                        $0.nameVi.localizedCaseInsensitiveContains(search) ||
                        $0.nameEn.localizedCaseInsensitiveContains(search)
                    }
                }
                return result
            }
            .assign(to: &$filteredPatterns)
    }

    private func loadPatterns() {
        isLoading = true
        fetchUseCase.execute(category: category)
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] completion in
                    self?.isLoading = false
                    if case .failure(let error) = completion {
                        self?.errorMessage = error.localizedDescription
                    }
                },
                receiveValue: { [weak self] patterns in
                    self?.patterns = patterns
                    self?.availableGroups = Array(Set(patterns.map { $0.group })).sorted { $0.rawValue < $1.rawValue }
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }

    func selectGroup(_ group: PatternGroup?) {
        selectedGroup = group
    }
}

// MARK: - Pattern Detail ViewModel

@MainActor
final class PatternDetailViewModel: ObservableObject {
    @Published var isBookmarked: Bool = false

    let pattern: TradingPattern
    private let bookmarkUseCase: BookmarkUseCase

    init(pattern: TradingPattern, bookmarkUseCase: BookmarkUseCase = BookmarkUseCase()) {
        self.pattern = pattern
        self.bookmarkUseCase = bookmarkUseCase
        self.isBookmarked = bookmarkUseCase.isBookmarked(pattern.id)
    }

    func toggleBookmark() {
        bookmarkUseCase.toggleBookmark(pattern.id)
        isBookmarked = bookmarkUseCase.isBookmarked(pattern.id)
    }
}

// MARK: - Bookmark List ViewModel

@MainActor
final class BookmarkListViewModel: ObservableObject {
    @Published var bookmarkedPatterns: [TradingPattern] = []
    @Published var isLoading: Bool = false

    private let fetchUseCase: FetchPatternsUseCase
    private let bookmarkUseCase: BookmarkUseCase
    private var cancellables = Set<AnyCancellable>()

    init(
        fetchUseCase: FetchPatternsUseCase = FetchPatternsUseCase(repository: PatternRepository()),
        bookmarkUseCase: BookmarkUseCase = BookmarkUseCase()
    ) {
        self.fetchUseCase = fetchUseCase
        self.bookmarkUseCase = bookmarkUseCase
    }

    func loadBookmarks() {
        isLoading = true
        let ids = bookmarkUseCase.bookmarkedIds()
        fetchUseCase.executeAll()
            .receive(on: DispatchQueue.main)
            .sink(
                receiveCompletion: { [weak self] _ in self?.isLoading = false },
                receiveValue: { [weak self] patterns in
                    self?.bookmarkedPatterns = patterns.filter { ids.contains($0.id) }
                    self?.isLoading = false
                }
            )
            .store(in: &cancellables)
    }
}
