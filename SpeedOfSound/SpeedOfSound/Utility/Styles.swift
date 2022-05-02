//
//  File.swift
//  SpeedOfSound
//
//  Created by Anzer Arkin on 30.04.22.
//

import SwiftUI

struct OvalTextFieldStyle: TextFieldStyle {
    func _body(configuration: TextField<Self._Label>) -> some View {
        configuration
            .padding(10)
            .background(LinearGradient(gradient: Gradient(colors: [.white]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(35)
    }
}

struct RoundedCorner: Shape {

    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

struct DraggableModifier : ViewModifier {

    enum Direction {
        case top
        case bottom
    }

    let direction: Direction

    @State private var draggedOffset: CGSize = .zero
    @Binding var showPlayer: Bool

    func valueChanged(value: DragGesture.Value) {
        if direction == .top {
            if (value.location.y - value.startLocation.y) <= 0 {
                self.draggedOffset = value.translation
            }
        } else {
            if (value.location.y - value.startLocation.y) >= 0 {
                self.draggedOffset = value.translation
            }
        }
    }
    
    func valueChangeEnded(value: DragGesture.Value) {
        if value.translation.height < 0 {
            showPlayer = true
        }

        if value.translation.height > 0 {
            showPlayer = false
        }
    }
    
    func body(content: Content) -> some View {
        content
        .offset(
            CGSize(width: 0, height: draggedOffset.height)
        )
        .gesture(
            DragGesture()
            .onChanged { value in
                valueChanged(value: value)
            }
            .onEnded { value in
                self.draggedOffset = .zero
                valueChangeEnded(value: value)
            }
        )
    }

}
