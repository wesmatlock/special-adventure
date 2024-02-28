import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            MapExampleHome()
                .tabItem {
                    Label {
                        Text("Attractions")
                    } icon: {
                        Image(systemName: "sparkles")
                    }

                }

            SearchNearBy()
                .tabItem {
                    Label {
                        Text("Search")
                    } icon: {
                        Image(systemName: "magnifyingglass.circle.fill")
                    }
                }
        }
    }
}

#Preview {
    ContentView()
}
