import SwiftUI

struct MultiStateMapStyleButton: View {
    @State private var states = MapStyleOption.allCases
    @State private var currentIndex = 0
    @Binding var selectedState: MapStyleOption

    var body: some View {
        Button {
            currentIndex = (currentIndex + 1) % states.count
            selectedState = states[currentIndex]
        } label: {
            Image(systemName: selectedState.icon)
                .font(.title)
                .frame(width: 30, height: 30)
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    MultiStateMapStyleButton(selectedState: .constant(.standard))
}
