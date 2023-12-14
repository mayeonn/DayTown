import SwiftUI
import Combine

class HomeTabViewModel: ObservableObject {
    @Published var weekDragOffset: CGSize = CGSize()
    
    private var cancellables: Set<AnyCancellable> = []

    func setWeekDragOffset(_ size: CGSize) {
        Future<CGSize, Never> { promise in
            DispatchQueue.global().async {
                promise(.success(size))
            }
        }
        .receive(on: DispatchQueue.main)
        .assign(to: \.weekDragOffset, on: self)
        .store(in: &cancellables)
    }
}
