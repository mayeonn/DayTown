import SwiftUI

struct WeekView: View {
    @ObservedObject var viewModel: WeekViewModel
    
    var body: some View {
        HStack(spacing: 8) {
            ForEach(Array(viewModel.week.enumerated()), id: \.element) { index, item in
                VStack(spacing: 4) {
                    Text(item)
                        .font(.system(size: 12))
                        .tint(.gray)
                    ZStack {
                        Circle()
                            .foregroundColor(viewModel.pickedDateIdx==index ? .blue : .white)
                        Text(K.weekDays[index])
                            .font(.system(size: 16))
                            .foregroundStyle(viewModel.pickedDateIdx==index ? .white : index==0 ? .red : index==6 ? .blue : .black)
                    }
                    .gesture(
                        TapGesture()
                            .onEnded{ _ in
                                viewModel.updatePickedDate(index: index)
                                viewModel.pickedDateIdx = index
                            }
                    )
                }
            }
        }
        .padding(8)
        .background(Rectangle().fill(.gray.opacity(0.2)))
        .onAppear{
            viewModel.initWeek()
        }
    }
}
