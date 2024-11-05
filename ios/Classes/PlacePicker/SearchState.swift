enum SearchState {
    case initial
    case searching
    case found([Place])
    case notFound
}
