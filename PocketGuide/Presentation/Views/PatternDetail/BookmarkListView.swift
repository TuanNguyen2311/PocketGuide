// MARK: - Presentation/Views/PatternDetail/BookmarkListView.swift

import SwiftUI

struct BookmarkListView: View {
    @StateObject private var viewModel = BookmarkListViewModel()

    var body: some View {
        ZStack {
            Color.pageBG.ignoresSafeArea()

            Group {
                if viewModel.isLoading {
                    ProgressView()
                } else if viewModel.bookmarkedPatterns.isEmpty {
                    emptyState
                } else {
                    ScrollView(showsIndicators: false) {
                        LazyVStack(spacing: 10) {
                            ForEach(viewModel.bookmarkedPatterns) { pattern in
                                // BUG-6 FIX: PatternDetailView không còn nhận namespace
                                NavigationLink(destination: PatternDetailView(pattern: pattern)) {
                                    PatternRowCard(pattern: pattern)
                                }
                                .buttonStyle(CardPressButtonStyle())
                            }
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                    }
                }
            }
        }
        .navigationTitle("Đã lưu")
        .navigationBarTitleDisplayMode(.large)
        .onAppear { viewModel.loadBookmarks() }
    }

    private var emptyState: some View {
        VStack(spacing: 20) {
            Spacer()
            ZStack {
                Circle()
                    .fill(Color.orange.opacity(0.1))
                    .frame(width: 80, height: 80)
                Image(systemName: "bookmark.slash")
                    .font(.system(size: 36))
                    .foregroundStyle(.orange.opacity(0.6))
            }
            // BUG-3 FIX: AppFont.title / AppFont.body
            Text("Chưa có mô hình nào")
                .font(AppFont.title)
                .foregroundStyle(.secondary)
            Text("Nhấn vào biểu tượng 🔖 khi xem\nchi tiết để lưu vào đây.")
                .font(AppFont.body)
                .foregroundStyle(.tertiary)
                .multilineTextAlignment(.center)
            Spacer()
        }
        .padding()
    }
}

// MARK: - Previews

#Preview("Đã lưu – trống") {
    NavigationStack {
        BookmarkListView()
    }
}

#Preview("Đã lưu – Dark") {
    NavigationStack {
        BookmarkListView()
    }
    .preferredColorScheme(.dark)
}
