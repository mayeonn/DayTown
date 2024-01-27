import SwiftUI
import Combine

class GroupTabViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    private var cancellables: Set<AnyCancellable> = []
    @Published var myGroups: [Group] = []
    
    init() {
        $myGroups
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
