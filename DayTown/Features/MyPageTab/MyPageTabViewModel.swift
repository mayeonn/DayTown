import SwiftUI
import Combine

class MyPageTabViewModel: ObservableObject {
    @Published var content: String = "Initial Content"
    
    private var cancellables: Set<AnyCancellable> = []

    func fetchData() {
        Future<String, Never> { promise in
            DispatchQueue.global().async {
                promise(.success("Data for MyPage Tab"))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.content, on: self)
        .store(in: &cancellables)
    }
}
