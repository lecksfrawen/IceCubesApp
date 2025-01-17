import SwiftUI
import Timeline
import Env
import Network
import Combine

struct TimelineTab: View {
  @EnvironmentObject private var client: Client
  @StateObject private var routeurPath = RouterPath()
  @Binding var popToRootTab: IceCubesApp.Tab
  @State private var timeline: TimelineFilter = .home
  
  var body: some View {
    NavigationStack(path: $routeurPath.path) {
      TimelineView(timeline: $timeline)
        .withAppRouteur()
        .withSheetDestinations(sheetDestinations: $routeurPath.presentedSheet)
        .toolbar {
          if client.isAuth {
            ToolbarItem(placement: .navigationBarLeading) {
              Button {
                routeurPath.presentedSheet = .newStatusEditor
              } label: {
                Image(systemName: "square.and.pencil")
              }
            }
            ToolbarItem(placement: .navigationBarTrailing) {
              timelineFilterButton
            }
          }
        }
    }
    .onAppear {
      if !client.isAuth {
        timeline = .pub
      }
    }
    .environmentObject(routeurPath)
    .onChange(of: $popToRootTab.wrappedValue) { popToRootTab in
      if popToRootTab == .timeline {
        routeurPath.path = []
      }
    }
  }
  
  
  private var timelineFilterButton: some View {
    Menu {
      ForEach(TimelineFilter.availableTimeline(), id: \.self) { timeline in
        Button {
          self.timeline = timeline
        } label: {
          Text(timeline.title())
        }
      }
    } label: {
      Image(systemName: "line.3.horizontal.decrease.circle")
    }

  }
}
