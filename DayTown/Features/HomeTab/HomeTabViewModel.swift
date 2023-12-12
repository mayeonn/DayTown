import SwiftUI
import Combine

class HomeTabViewModel: ObservableObject {
    @Published var content: String = "Initial Content"
    
    private var cancellables: Set<AnyCancellable> = []

    func fetchData() {
        Future<String, Never> { promise in
            DispatchQueue.global().async {
                promise(.success("Data for Home Tab"))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.content, on: self)
        .store(in: &cancellables)
    }
}

#Preview {
    ContentView()
}
