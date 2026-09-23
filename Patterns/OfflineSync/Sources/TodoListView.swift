#if canImport(SwiftUI)
import SwiftUI

public struct TodoListView: View {
    @State private var viewModel: TodoListViewModel
    @State private var newTitle = ""

    public init(viewModel: TodoListViewModel) {
        _viewModel = State(initialValue: viewModel)
    }

    public var body: some View {
        List {
            Section {
                TextField("New task", text: $newTitle)
                    .onSubmit { add() }
            }
            Section {
                ForEach(viewModel.items) { item in
                    Button {
                        Task { await viewModel.toggle(item) }
                    } label: {
                        Label(item.title, systemImage: item.isDone ? "checkmark.circle.fill" : "circle")
                    }
                }
                .onDelete { offsets in
                    let targets = offsets.map { viewModel.items[$0] }
                    Task {
                        for item in targets {
                            await viewModel.delete(item)
                        }
                    }
                }
            }
        }
        .refreshable { await viewModel.sync() }
        .safeAreaInset(edge: .bottom) { statusBar }
        .task { await viewModel.reload() }
    }

    private var statusBar: some View {
        HStack {
            switch viewModel.status {
            case .idle: Label("Not synced yet", systemImage: "icloud")
            case .syncing: Label("Syncing…", systemImage: "arrow.triangle.2.circlepath.icloud")
            case .synced: Label("Up to date", systemImage: "checkmark.icloud")
            case .offline: Label("Offline", systemImage: "icloud.slash")
            }
            Spacer()
            if viewModel.pendingChanges > 0 {
                Text("\(viewModel.pendingChanges) waiting").foregroundStyle(.orange)
            }
        }
        .font(.footnote)
        .padding()
        .background(.bar)
    }

    private func add() {
        let title = newTitle.trimmingCharacters(in: .whitespaces)
        guard !title.isEmpty else { return }
        newTitle = ""
        Task { await viewModel.add(title) }
    }
}
#endif
