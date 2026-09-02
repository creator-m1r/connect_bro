import Foundation

protocol AgentTransport: Sendable {
    var agent: AgentID { get }
    func send(_ message: String) async throws -> String
}

struct LocalMIRPITransport: AgentTransport {
    let agent: AgentID = .mirpi
    let endpoint: URL

    func send(_ message: String) async throws -> String {
        var request = URLRequest(url: endpoint)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONSerialization.data(withJSONObject: ["message": message])

        let (data, response) = try await URLSession.shared.data(for: request)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        return String(data: data, encoding: .utf8) ?? ""
    }
}

struct UnconfiguredTransport: AgentTransport {
    let agent: AgentID

    func send(_ message: String) async throws -> String {
        throw NSError(domain: "ConnectBro", code: 1, userInfo: [
            NSLocalizedDescriptionKey: "Транспорт \(agent.rawValue) ещё не настроен."
        ])
    }
}
