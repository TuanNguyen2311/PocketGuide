// MARK: - Presentation/Views/PatternList/PatternListView.swift

import SwiftUI

struct PatternListView: View {
    let category: PatternCategory
    @StateObject private var viewModel: PatternListViewModel

    init(category: PatternCategory) {
        self.category = category
        _viewModel = StateObject(wrappedValue: PatternListViewModel(category: category))
    }

    var body: some View {
        ZStack {
            Color.pageBG.ignoresSafeArea()

            VStack(spacing: 0) {
                if viewModel.availableGroups.count > 1 {
                    groupFilterBar
                }
                searchBar

                if viewModel.isLoading {
                    Spacer()
                    ProgressView().scaleEffect(1.2)
                    Spacer()
                } else if viewModel.filteredPatterns.isEmpty {
                    emptyState
                } else {
                    patternList
                }
            }
        }
        .navigationTitle(category.displayName)
        .navigationBarTitleDisplayMode(.large)
    }

    // MARK: - Group Filter

    private var groupFilterBar: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                FilterChip(title: "Tất cả", isSelected: viewModel.selectedGroup == nil) {
                    withAnimation(.spring(response: 0.3)) { viewModel.selectGroup(nil) }
                }
                ForEach(viewModel.availableGroups, id: \.self) { group in
                    FilterChip(title: group.displayName, isSelected: viewModel.selectedGroup == group) {
                        withAnimation(.spring(response: 0.3)) { viewModel.selectGroup(group) }
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 10)
        }
        .background(Color.pageBG)
    }

    // MARK: - Search
    // BUG-3 FIX: AppFont.body thay vì .font(.appBody)

    private var searchBar: some View {
        HStack(spacing: 8) {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(.secondary)
            TextField("Tìm kiếm mô hình...", text: $viewModel.searchText)
                .font(AppFont.body)
            if !viewModel.searchText.isEmpty {
                Button { viewModel.searchText = "" } label: {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundStyle(.secondary)
                }
            }
        }
        .padding(.horizontal, 12)
        .padding(.vertical, 10)
        .background(Color.cardSurface, in: RoundedRectangle(cornerRadius: 12, style: .continuous))
        .padding(.horizontal, 16)
        .padding(.bottom, 8)
    }

    // MARK: - Pattern List

    private var patternList: some View {
        ScrollView(showsIndicators: false) {
            LazyVStack(spacing: 10) {
                ForEach(viewModel.filteredPatterns) { pattern in
                    NavigationLink(destination: PatternDetailView(pattern: pattern)) {
                        PatternRowCard(pattern: pattern)
                    }
                    .buttonStyle(CardPressButtonStyle())
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 24)
            .animation(.spring(response: 0.4, dampingFraction: 0.85), value: viewModel.filteredPatterns.count)
        }
    }

    // MARK: - Empty State

    private var emptyState: some View {
        VStack(spacing: 16) {
            Spacer()
            Image(systemName: "doc.text.magnifyingglass")
                .font(.system(size: 44))
                .foregroundStyle(.tertiary)
            Text("Không tìm thấy kết quả")
                // BUG-3 FIX: AppFont.headline
                .font(AppFont.headline)
                .foregroundStyle(.secondary)
            if !viewModel.searchText.isEmpty {
                Button("Xóa tìm kiếm") { viewModel.searchText = "" }
                    .buttonStyle(.bordered)
                    .tint(.appAccent)
            }
            Spacer()
        }
    }
}

// MARK: - Filter Chip

struct FilterChip: View {
    let title: String
    let isSelected: Bool
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13, weight: isSelected ? .semibold : .regular))
                .foregroundStyle(isSelected ? .white : .primary)
                .padding(.horizontal, 14)
                .padding(.vertical, 7)
                .background(
                    Capsule()
                        .fill(isSelected ? Color.appAccent : Color.cardSurface)
                )
        }
        .animation(.spring(response: 0.25), value: isSelected)
    }
}

// MARK: - Pattern Row Card
// BUG-6 FIX: Xóa namespace: Namespace.ID param — không dùng matchedGeometryEffect nữa

struct PatternRowCard: View {
    let pattern: TradingPattern

    var body: some View {
        HStack(spacing: 0) {
            // BUG-6 FIX: AnimatedThumbnail không còn nhận namespace
            AnimatedThumbnail(pattern: pattern, size: 76)
                .padding(10)

            VStack(alignment: .leading, spacing: 5) {
                // BUG-3 FIX: AppFont.headline / AppFont.caption
                Text(pattern.nameVi)
                    .font(AppFont.headline)
                    .foregroundStyle(.primary)
                    .lineLimit(1)

                Text(pattern.nameEn)
                    .font(AppFont.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(1)

                Spacer(minLength: 6)

                HStack(spacing: 6) {
                    SignalBadge(signal: pattern.signal)
                    Text(pattern.group.displayName)
                        .font(.system(size: 11))
                        .foregroundStyle(.secondary)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 3)
                        .background(Color(.tertiarySystemGroupedBackground), in: Capsule())
                }
            }
            .padding(.leading, 4)
            .padding(.trailing, 12)
            .padding(.vertical, 12)

            Spacer(minLength: 0)

            Image(systemName: "chevron.right")
                .font(.system(size: 11, weight: .semibold))
                .foregroundStyle(.tertiary)
                .padding(.trailing, 14)
        }
        .background(
            RoundedRectangle(cornerRadius: 16, style: .continuous)
                .fill(Color.cardSurface)
                .shadow(color: .black.opacity(0.05), radius: 10, x: 0, y: 3)
        )
    }
}

// MARK: - Signal Badge

struct SignalBadge: View {
    let signal: SignalType

    var body: some View {
        HStack(spacing: 4) {
            Circle()
                .fill(signal.color)
                .frame(width: 6, height: 6)
            Text(signal.displayName)
                .font(.system(size: 11, weight: .medium))
                .foregroundStyle(signal.color)
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(signal.lightColor, in: Capsule())
    }
}
