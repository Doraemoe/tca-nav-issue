import ComposableArchitecture
import SwiftUI

@Reducer struct AppFeature {
    struct State: Equatable {
        var path = StackState<AppFeature.Path.State>()
    }
    
    enum Action: Equatable {
        case path(StackAction<AppFeature.Path.State, AppFeature.Path.Action>)
    }
    
    var body: some Reducer<State, Action> {
        Reduce { state, action in
            switch action {
            case let .path(.element(id: id, action: .details(.deleteSuccess))):
                guard case .details = state.path[id: id]
                else { return .none }
                let penultimateId = state.path.ids.dropLast().last
                state.path.pop(from: penultimateId!)
                return .none
            default:
                return .none
            }
        }
        .forEach(\.path, action: \.path) {
            AppFeature.Path()
        }
    }
    
    @Reducer struct Path {
        enum State: Equatable {
            case reader(ReaderFeature.State)
            case details(DetailsFeature.State)
        }
        enum Action: Equatable {
            case reader(ReaderFeature.Action)
            case details(DetailsFeature.Action)
        }
        var body: some ReducerOf<Self> {
            Scope(state: \.reader, action: \.reader) {
                ReaderFeature()
            }
            Scope(state: \.details, action: \.details) {
                DetailsFeature()
            }
        }
    }
}

struct ContentView: View {
    let store: StoreOf<AppFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            NavigationStackStore(
                self.store.scope(state: \.path, action: { .path($0) })
            ) {
                NavigationLink(state: AppFeature.Path.State.reader(ReaderFeature.State.init())) {
                    Text("reader View")
                }
            } destination: { (state: AppFeature.Path.State) in
                switch state {
                case .reader:
                    CaseLet(
                        /AppFeature.Path.State.reader,
                         action: AppFeature.Path.Action.reader,
                         then: ReaderView.init(store:)
                    )
                case .details:
                    CaseLet(
                        /AppFeature.Path.State.details,
                         action: AppFeature.Path.Action.details,
                         then: DetailsView.init(store:)
                    )
                }
            }
        }
    }
}

