import Foundation
import SwiftUI

@MainActor
final class AppState: ObservableObject {
    @Published var selectedAgent: AgentID = .deepSeek
    @Published var messages: [AgentMessage] = []
    @Published var tasks: [ResearchTask] = []
    @Published var learningRecords: [LearningRecord] = []
    @Published var draft = ""
    @Published var status = "Готов"
    @Published var workspaceURL: URL?

    private let memoryStore = LearningMemoryStore()

    init() {
        learningRecords = memoryStore.load()
    }

    func createTask() {
        let prompt = draft.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !prompt.isEmpty else { return }
        let task = ResearchTask(title: prompt.prefix(70).description, prompt: prompt)
        tasks.insert(task, at: 0)
        append(AgentMessage(taskID: task.id, from: .deepSeek, kind: .system, text: prompt, iteration: 0))
        draft = ""
        status = "Задача создана"
    }

    func append(_ message: AgentMessage) {
        messages.append(message)
    }

    func recordLearning(question: String, experience: String, conclusion: String, confidence: Double) {
        guard let task = tasks.first else { return }
        let record = LearningRecord(
            taskID: task.id,
            question: question,
            experience: experience,
            conclusion: conclusion,
            confidence: confidence
        )
        learningRecords.insert(record, at: 0)
        memoryStore.save(learningRecords)
    }
}

private final class LearningMemoryStore {
    private let fileURL: URL

    init() {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        let directory = base.appendingPathComponent("ConnectBro", isDirectory: true)
        try? FileManager.default.createDirectory(at: directory, withIntermediateDirectories: true)
        fileURL = directory.appendingPathComponent("mirpi-learning.json")
    }

    func load() -> [LearningRecord] {
        guard let data = try? Data(contentsOf: fileURL) else { return [] }
        return (try? JSONDecoder().decode([LearningRecord].self, from: data)) ?? []
    }

    func save(_ records: [LearningRecord]) {
        guard let data = try? JSONEncoder().encode(records) else { return }
        try? data.write(to: fileURL, options: .atomic)
    }
}
