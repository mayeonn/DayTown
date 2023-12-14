//
//  ContentViewModel.swift
//  DayTown
//
//  Created by 김하연 on 12/14/23.
//

import Combine

class ContentViewModel: ObservableObject {
    @Published var tabSelection: Int = 0
    
    @Published var homeTabViewModel = HomeTabViewModel()
    @Published var groupTabViewModel = GroupTabViewModel()
    @Published var chatTabViewModel = ChatTabViewModel()
    @Published var myPageTabViewModel = MyPageTabViewModel()
}
