import Foundation
import SwiftUI
import Models
import Network

@MainActor
class StatusDetailViewModel: ObservableObject {
  public let statusId: String
  
  var client: Client?
  
  enum State {
    case loading, display(status: Status, context: StatusContext), error(error: Error)
  }
  
  @Published var state: State = .loading
  @Published var title: String = ""
    
  init(statusId: String) {
    state = .loading
    self.statusId = statusId
  }
  
  func fetchStatusDetail() async {
    guard let client else { return }
    do {
      let status: Status = try await client.get(endpoint: Statuses.status(id: statusId))
      let context: StatusContext = try await client.get(endpoint: Statuses.context(id: statusId))
      state = .display(status: status, context: context)
      title = "Post from \(status.account.displayName)"
    } catch {
      state = .error(error: error)
    }
  }
  
  
  func handleEvent(event: any StreamEvent, currentAccount: Account?) {
    if let event = event as? StreamEventUpdate,
       event.status.account.id == currentAccount?.id {
      Task {
        await fetchStatusDetail()
      }
    } else if event is StreamEventDelete {
      Task {
        await fetchStatusDetail()
      }
    }
  }
}
