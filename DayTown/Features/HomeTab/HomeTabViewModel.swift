import SwiftUI
import Combine

class HomeTabViewModel: ObservableObject {
    @Published var pickedDate: String = "Initial Content"
    
    private var cancellables: Set<AnyCancellable> = []

    func fetchData() {
        Future<String, Never> { promise in
            DispatchQueue.global().async {
                promise(.success("picked date"))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.pickedDate, on: self)
        .store(in: &cancellables)
    }
}

#Preview {
    ContentView()
}
