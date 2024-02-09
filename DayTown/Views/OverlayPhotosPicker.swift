import SwiftUI
import PhotosUI

struct OverlayPhotosPicker: ViewModifier {
    @Binding var selectedItem: PhotosPickerItem?
    let inset: CGFloat
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images
                ) {
                    Image(systemName: "pencil.circle")
                        .foregroundStyle(.gray)
                        .font(.system(size: 30))
                        .padding(inset)
                }
            }
    }
}

extension View {
    
    func overlayPhotosPicker(selectedItem: Binding<PhotosPickerItem?>, inset: CGFloat) -> some View {
        modifier(OverlayPhotosPicker(selectedItem: selectedItem, inset: inset))
    }
}
