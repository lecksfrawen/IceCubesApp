import SwiftUI
import Timeline
import Env
import Network
import Notifications

struct NotificationsTab: View {
  @EnvironmentObject private var watcher: StreamWatcher
  @StateObject private var routeurPath = RouterPath()
  @Binding var popToRootTab: IceCubesApp.Tab
  
  var body: some View {
    NavigationStack(path: $routeurPath.path) {
      NotificationsListView()
        .withAppRouteur()
        .withSheetDestinations(sheetDestinations: $routeurPath.presentedSheet)
    }
    .onAppear {
      watcher.unreadNotificationsCount = 0
    }
    .environmentObject(routeurPath)
    .onChange(of: $popToRootTab.wrappedValue) { popToRootTab in
      if popToRootTab == .notifications {
        routeurPath.path = []
      }
    }
  }
}
