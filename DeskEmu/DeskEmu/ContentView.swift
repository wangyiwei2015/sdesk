import SwiftUI

struct ContentView: View {
    @State var windowList = [WindowInfo]()
    @State var focused: UUID? = nil
    
    func dismissWindow(_ target: UUID) {
        withAnimation(.easeOut(duration: 0.2)) {
            windowList.removeAll(where: {$0.id == target})
        }
        focused = windowList.last?.id
    }
    
    func bringToFront(_ target: UUID) {
        windowList.move(fromOffsets: [windowList.firstIndex(where: {$0.id == target})!], toOffset: windowList.count)
    }
    
    var body: some View {
        ZStack {
            GeometryReader {geo in
                Image("DefaultBG", bundle: Bundle.main)
                    .resizable().scaledToFill()
            }.onTapGesture {focused = nil}
            VStack {
                MenuBarView(
                    windowList: $windowList,
                    focused: $focused
                )
                Spacer()
            }
            
            ForEach(windowList) {window in
                WindowView(
                    id: window.id,
                    location: window.location,
                    size: window.size,
                    focused: $focused,
                    dismissAction: self.dismissWindow,
                    bringToFrontAction: self.bringToFront
                )
                .transition(.opacity.combined(with: .scale(scale: 0.95)))
            }
            /*ForEach($windowList) {$window in
                WindowView(
                    //info: $window,
                    id: window.id,
                    location: $window.location,
                    size: $window.size,
                    focused: $focused,
                    dismissAction: self.dismissWindow
                )
            }*/
        }.ignoresSafeArea()
    }
    
    func makeBindingPoint(_ id: UUID) -> Binding<CGPoint> {
        let index = windowList.firstIndex(where: {$0.id == id})!
        return .init(
            get: {self.windowList[index].location},
            set: {self.windowList[index].location = $0}
        )
    }
    
    func makeBindingSize(_ id: UUID) -> Binding<CGSize> {
        let index = windowList.firstIndex(where: {$0.id == id})!
        return .init(
            get: {self.windowList[index].size},
            set: {self.windowList[index].size = $0}
        )
    }
}

struct WindowInfo: Identifiable, Equatable {
    let id = UUID()
    var location: CGPoint = CGPoint(x: 200, y: 300)//CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    var size = CGSize(width: 300, height: 200)
    static func ==(lhs: WindowInfo, rhs: WindowInfo) -> Bool {
        lhs.id == rhs.id
    }
}
