import ComposableArchitecture
import SwiftUI

@Reducer struct DetailsFeature {
    struct State: Equatable {
        @PresentationState var alert: AlertState<Action.Alert>?
    }
    
    enum Action: Equatable {
        case alert(PresentationAction<Alert>)
        
        case deleteButtonTapped
        case deleteSuccess
        enum Alert {
            case confirmDelete
        }
    }
    
    var body: some ReducerOf<Self> {
        Reduce { state, action in
            switch action {
            case .deleteButtonTapped:
                state.alert = AlertState {
                    TextState("confirm")
                } actions: {
                    ButtonState(role: .destructive, action: .confirmDelete) {
                        TextState("delete")
                    }
                    ButtonState(role: .cancel) {
                        TextState("cancel")
                    }
                }
                return .none
            case .alert(.presented(.confirmDelete)):
                return .run { send in
                    await send(.deleteSuccess)
                }
            default:
                return .none
            }
        }
        .ifLet(\.$alert, action: \.alert)
    }
}

struct DetailsView: View {
    let store: StoreOf<DetailsFeature>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
                Button(
                    role: .destructive,
                    action: { viewStore.send(.deleteButtonTapped) },
                    label: {
                        Text("archive.delete")
                    }
                )
            .alert(
              store: self.store.scope(
                state: \.$alert,
                action: { .alert($0) }
              )
            )
        }
        
    }
}
