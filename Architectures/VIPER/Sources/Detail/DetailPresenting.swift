@MainActor
public protocol DetailPresenting: AnyObject {
    func viewDidLoad() async
    func didTapFavorite() async
}
