import Foundation

struct ExtractedCode: Identifiable, Hashable {
    let id = UUID()
    let language: String
    let content: String
}

enum CodeExtractor {
    static func extract(from text: String) -> [ExtractedCode] {
        let pattern = #"```([A-Za-z0-9_+.#-]*)\s*\n([\s\S]*?)```"#
        guard let regex = try? NSRegularExpression(pattern: pattern) else { return [] }
        let range = NSRange(text.startIndex..., in: text)
        return regex.matches(in: text, range: range).compactMap { match in
            guard match.numberOfRanges >= 3,
                  let languageRange = Range(match.range(at: 1), in: text),
                  let codeRange = Range(match.range(at: 2), in: text) else { return nil }
            return ExtractedCode(
                language: String(text[languageRange]).isEmpty ? "text" : String(text[languageRange]),
                content: String(text[codeRange]).trimmingCharacters(in: .whitespacesAndNewlines)
            )
        }
    }
}
