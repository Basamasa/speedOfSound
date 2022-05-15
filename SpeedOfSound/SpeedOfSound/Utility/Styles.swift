//
//  File.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct ViewDidLoadModifier: ViewModifier {

    @State private var didLoad = false
    private let action: (() -> Void)?

    init(perform action: (() -> Void)? = nil) {
        self.action = action
    }

    func body(content: Content) -> some View {
        content.onAppear {
            if didLoad == false {
                didLoad = true
                action?()
            }
        }
    }

}

struct DraggableModifier : ViewModifier {

    @State private var draggedOffset: CGSize = .zero
    @Binding var showPlayer: Bool
    let direction: Direction

    enum Direction {
        case top
        case bottom
    }
    
    func valueChanged(value: DragGesture.Value) {
         if direction == .bottom {
             if (value.location.y - value.startLocation.y) > 10 {
                 withAnimation() {
                     self.draggedOffset = value.translation
                     showPlayer = false
                 }
             }
         }
     }
    
    func valueChangeEnded(value: DragGesture.Value) {
        if value.translation.height < 0 {
            withAnimation {
                showPlayer = true
            }
        }

        if value.translation.height > 0 {
            withAnimation {
                showPlayer = false
            }
        }
    }
    
    func body(content: Content) -> some View {
        content
        .offset(
            CGSize(width: 0, height: draggedOffset.height)
        )
        .gesture(
            DragGesture().onChanged { value in
                valueChanged(value: value)
            }
            .onEnded { value in
                self.draggedOffset = .zero
                valueChangeEnded(value: value)
            }
        )
    }

}
