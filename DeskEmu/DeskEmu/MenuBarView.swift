import SwiftUI

struct MenuBarView: View {
    @Binding var windowList: [WindowInfo]
    @Binding var focused: UUID?
    
    var body: some View {
        ZStack {
            Color.systemGray(5)
            HStack {
                Image(systemName: "swift")
                Spacer()
                Button("New Window") {
                    let new = WindowInfo()
                    focused = new.id
                    withAnimation(.easeOut(duration: 0.2)) {
                        windowList.append(new)
                    }
                }
                Spacer()
                Image(systemName: "swift")
            }.padding(.top, 20)
        }.frame(height: 60)
    }
}
