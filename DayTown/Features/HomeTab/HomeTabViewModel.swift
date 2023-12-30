import SwiftUI
import Combine
import RealmSwift

class HomeTabViewModel: ObservableObject {
    @Published var weekDragOffset: CGSize = CGSize()
    let calendar = Calendar.current
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
