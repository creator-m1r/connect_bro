import SwiftUI

struct ContentView: View {
    @EnvironmentObject private var state: AppState

    var body: some View {
        NavigationSplitView {
            List(state.tasks) { task in
                VStack(alignment: .leading, spacing: 4) {
                    Text(task.title).font(.headline)
                    Text(task.status.rawValue).font(.caption).foregroundStyle(.secondary)
                }
            }
            .navigationTitle("Задачи")
        } detail: {
            VStack(spacing: 0) {
                header
                Divider()
                agentGrid
                Divider()
                messageComposer
            }
        }
    }

    private var header: some View {
        HStack {
            Text("CONNECT BRO").font(.title2.bold())
            Spacer()
            Text(state.status).foregroundStyle(.secondary)
            Text("MIRPI memory: \(state.learningRecords.count)")
                .font(.caption.monospaced())
        }
        .padding()
    }

    private var agentGrid: some View {
        HStack(spacing: 1) {
            AgentPanel(agent: .deepSeek, messages: state.messages)
            AgentPanel(agent: .chatGPT, messages: state.messages)
            AgentPanel(agent: .mirpi, messages: state.messages)
        }
        .background(.quaternary)
    }

    private var messageComposer: some View {
        HStack(alignment: .bottom) {
            TextField("Новая задача для AI...", text: $state.draft, axis: .vertical)
                .textFieldStyle(.roundedBorder)
                .lineLimit(3...8)
            Button("Создать задачу") {
                state.createTask()
            }
            .keyboardShortcut(.return, modifiers: [.command])
        }
        .padding()
    }
}

private struct AgentPanel: View {
    let agent: AgentID
    let messages: [AgentMessage]

    private var agentMessages: [AgentMessage] {
        messages.filter { $0.from == agent || $0.to == agent }
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Circle().frame(width: 9, height: 9)
                Text(agent.rawValue).font(.headline)
                Spacer()
            }
            .padding(10)
            Divider()
            ScrollView {
                LazyVStack(alignment: .leading, spacing: 10) {
                    if agentMessages.isEmpty {
                        Text("Ожидание подключения…")
                            .foregroundStyle(.secondary)
                            .padding(.top, 30)
                    }
                    ForEach(agentMessages) { message in
                        VStack(alignment: .leading, spacing: 3) {
                            Text(message.from.rawValue).font(.caption.bold())
                            Text(message.text).textSelection(.enabled)
                        }
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .padding(8)
                        .background(.background, in: RoundedRectangle(cornerRadius: 8))
                    }
                }
                .padding(10)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.regularMaterial)
    }
}
