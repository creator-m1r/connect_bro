import Foundation

actor AgentRouter {
    private(set) var history: [AgentMessage] = []

    func route(_ message: AgentMessage, to target: AgentID) -> AgentMessage {
        let routed = AgentMessage(
            taskID: message.taskID,
            from: message.from,
            to: target,
            kind: message.kind,
            text: message.text,
            iteration: message.iteration
        )
        history.append(routed)
        return routed
    }

    func append(_ message: AgentMessage) {
        history.append(message)
    }
}

/// MIRPI's first learning layer: convert interaction history into durable experience.
/// Model weights are intentionally untouched. This makes learning auditable and reversible.
struct MIRPILearningEngine {
    func makeRecord(task: ResearchTask, messages: [AgentMessage]) -> LearningRecord? {
        let relevant = messages.filter { $0.taskID == task.id }
        guard !relevant.isEmpty else { return nil }

        let experience = relevant.map { "\($0.from.rawValue): \($0.text)" }.joined(separator: "\n\n")
        let conclusion = "Опыт сохранён. Следующий шаг — проверить вывод независимым экспериментом или тестом."

        return LearningRecord(
            taskID: task.id,
            question: task.prompt,
            experience: String(experience.prefix(20_000)),
            conclusion: conclusion,
            confidence: 0.0
        )
    }
}
