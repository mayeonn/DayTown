import SwiftUI
import Combine

class GroupTabViewModel: ObservableObject {
    @Published var currentUser: UserModel?
    @Published var myGroups: [Group] = []
    private var cancellables: Set<AnyCancellable> = []
    
    init() {
        $myGroups
            .compactMap { $0 }
            .sink { [weak self] user in
                self?.objectWillChange.send()
            }
            .store(in: &cancellables)
    }
}
