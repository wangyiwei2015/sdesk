import SwiftUI

struct WindowView: View {
    //@Binding var info: WindowInfo
    var id: UUID
    //@Binding var location: CGPoint
    //@Binding var size: CGSize
    @State var location: CGPoint
    @State var size: CGSize
    @Binding var focused: UUID?
    var dismissAction: ((UUID) -> Void)
    var bringToFrontAction: ((UUID) -> Void)
    
    @GestureState private var startLocation: CGPoint? = nil
    @GestureState private var startSize: CGSize? = nil
    @State var titleBarHeight: CGFloat = 40
    
    var titleBarLocation: CGPoint {
        CGPoint(x: location.x, y: location.y - size.height / 2 - titleBarHeight / 2)
    }
    var maskLocation: CGPoint {
        CGPoint(x: location.x, y: location.y - titleBarHeight / 2)
    }
    
    var dragGesture: some Gesture {
        DragGesture().onChanged {value in
            location = (startLocation ?? location) + value.translation
            location.y = max(location.y, 100)
            if focused != id {
                bringToFrontAction(id)
            }
            focused = id
        }.updating($startLocation) {
            (_, startLocation, _) in
            startLocation = startLocation ?? location
        }
    }
    
    //func checkDragAtEdge() {
        //
    //}
    var dragzResizeGesture: some Gesture {
        DragGesture().onChanged {value in
            size.width = (startSize ?? size).width + value.translation.width
            size.height = (startSize ?? size).height + value.translation.height
            size.width = max(size.width, 100)
            size.height = max(size.height, 50)
            //location = (startLocation ?? location) + value.translation / 2
        }.updating($startLocation) { (_, startLocation, _) in
            startLocation = startLocation ?? location
        }
//        .updating($startSize) { (_, startSize, _) in
//            startSize = startSize ?? size
//        }
    }
    
    var body: some View {
        ZStack {
            ZStack {
                VStack {
                    Text("Contents")
                    Button("aaa") {}
                }
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        Image(systemName: "righttriangle.split.diagonal.fill")
                            .font(.system(size: 16)).foregroundColor(.gray)
                            .padding(4)
                            .gesture(dragzResizeGesture)
                    }
                }
                
                if focused != id {
                    Color(UIColor.systemBackground)
                        .opacity(0.2)
                        .onTapGesture {
                            focused = id
                            bringToFrontAction(id)
                        }
                }
            }
            .frame(width: size.width, height: size.height)
            .background(Color.systemGray(7))
            .position(location)
            
            Text("Title Bar")
                .background(
                    (focused == id ? Color.systemGray(4) : Color.systemGray(6))
                        .frame(width: size.width, height: titleBarHeight, alignment: .leading)
                )
                .onTapGesture {
                    focused = id
                    bringToFrontAction(id)
                }
                .position(titleBarLocation)
                .gesture(dragGesture)
            HStack {
                Spacer()
                Button {print("btn")
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill()
                            .foregroundColor(.systemGray(6))
                        Image(systemName: "arrow.down.left")
                            .foregroundColor(.black)
                    }.frame(width: titleBarHeight - 10, height: titleBarHeight - 10)
                }.padding(.vertical, 5)
                    .frame(width: titleBarHeight, height: titleBarHeight)
                    .offset(x: 10) //FIXME
                Button {
                        dismissAction(id)
                } label: {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8, style: .continuous).fill()
                            .foregroundColor(.red)
                        Image(systemName: "xmark")
                            .foregroundColor(.white)
                    }.frame(width: titleBarHeight - 10, height: titleBarHeight - 10)
                }.padding(.vertical, 5)
                    .frame(width: titleBarHeight, height: titleBarHeight)
            }.frame(width: size.width, height: titleBarHeight)
                .position(titleBarLocation)
            
        }.mask(
            RoundedRectangle(cornerRadius: 12, style: .continuous)
                .frame(width: size.width, height: size.height + titleBarHeight, alignment: .center)
                .position(maskLocation)
        ).shadow(radius: focused == id ? 12 : 4)
    }
}
