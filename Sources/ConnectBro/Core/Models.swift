import Foundation

enum AgentID: String, CaseIterable, Codable, Identifiable {
    case deepSeek = "DeepSeek"
    case chatGPT = "ChatGPT"
    case mirpi = "MIRPI"

    var id: String { rawValue }
}

enum MessageKind: String, Codable {
    case user
    case response
    case code
    case review
    case learning
    case system
}

struct AgentMessage: Identifiable, Codable, Hashable {
    let id: UUID
    let taskID: UUID
    let from: AgentID
    let to: AgentID?
    let kind: MessageKind
    let text: String
    let createdAt: Date
    let iteration: Int

    init(
        id: UUID = UUID(),
        taskID: UUID,
        from: AgentID,
        to: AgentID? = nil,
        kind: MessageKind,
        text: String,
        createdAt: Date = .now,
        iteration: Int = 0
    ) {
        self.id = id
        self.taskID = taskID
        self.from = from
        self.to = to
        self.kind = kind
        self.text = text
        self.createdAt = createdAt
        self.iteration = iteration
    }
}

struct ResearchTask: Identifiable, Codable, Hashable {
    let id: UUID
    var title: String
    var prompt: String
    var createdAt: Date
    var iteration: Int
    var status: TaskStatus

    init(title: String, prompt: String) {
        self.id = UUID()
        self.title = title
        self.prompt = prompt
        self.createdAt = .now
        self.iteration = 0
        self.status = .idle
    }
}

enum TaskStatus: String, Codable {
    case idle
    case running
    case waitingForReview
    case completed
    case failed
}

struct LearningRecord: Identifiable, Codable, Hashable {
    let id: UUID
    let taskID: UUID
    let createdAt: Date
    let question: String
    let experience: String
    let conclusion: String
    let confidence: Double

    init(taskID: UUID, question: String, experience: String, conclusion: String, confidence: Double = 0) {
        self.id = UUID()
        self.taskID = taskID
        self.createdAt = .now
        self.question = question
        self.experience = experience
        self.conclusion = conclusion
        self.confidence = min(max(confidence, 0), 1)
    }
}
