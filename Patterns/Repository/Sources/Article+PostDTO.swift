import Foundation

extension Article {
    init(dto: PostDTO) {
        self.init(
            id: dto.id,
            title: dto.title.capitalized,
            summary: dto.body.replacingOccurrences(of: "\n", with: " ")
        )
    }
}
