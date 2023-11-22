import ComposableArchitecture
import SwiftUI

@Reducer struct ReaderFeature {
    struct State: Equatable {
    }
    
    enum Action: Equatable {
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            default:
                return .none
            }
        }
    }
}

struct ReaderView: View {
    let store: StoreOf<ReaderFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            Text("test")
                .toolbar {
                    ToolbarItem(placement: .primaryAction) {
                        NavigationLink(
                            state: AppFeature.Path.State.details(DetailsFeature.State.init())
                        ) {
                            Image(systemName: "info.circle")
                        }
                    }
                }
                .navigationBarTitleDisplayMode(.inline)
                .toolbar(.hidden, for: .tabBar)
        }
    }
}
