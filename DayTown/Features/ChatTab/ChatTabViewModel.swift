import SwiftUI
import Combine

class ChatTabViewModel: ObservableObject {
    @Published var content: String = "Initial Content"
    
    private var cancellables: Set<AnyCancellable> = []

    func fetchData() {
        Future<String, Never> { promise in
            DispatchQueue.global().async {
                promise(.success("Data for Chat Tab"))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.content, on: self)
        .store(in: &cancellables)
    }
}
