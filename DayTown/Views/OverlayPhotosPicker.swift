import SwiftUI
import PhotosUI

struct OverlayPhotosPicker: ViewModifier {
    @Binding var selectedItem: PhotosPickerItem?
    
    func body(content: Content) -> some View {
        content
            .overlay(alignment: .bottomTrailing) {
                PhotosPicker(
                    selection: $selectedItem,
                    matching: .images,
                    photoLibrary: .shared()) {
                        Image(systemName: "pencil.circle")
                            .foregroundStyle(.gray)
                            .font(.system(size: 30))
                            .padding(20)
                    }
            }
    }
}

extension View {
    
    func overlayPhotosPicker(selectedItem: Binding<PhotosPickerItem?>) -> some View {
        modifier(OverlayPhotosPicker(selectedItem: selectedItem))
    }
}
