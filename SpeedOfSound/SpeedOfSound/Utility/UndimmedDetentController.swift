//
//  UndimmedDetentController.swift
//  MetronomeZones
//
//  Created by Anzer Arkin on 19.09.22.
//

import UIKit
import SwiftUI

class UndimmedDetentController: UIViewController {

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        avoidDimmingParent()
        avoidDisablingControls()
    }

    func avoidDimmingParent() {
        sheetPresentationController?.largestUndimmedDetentIdentifier = .large
    }

    func avoidDisablingControls() {
        presentingViewController?.view.tintAdjustmentMode = .normal
    }
}

struct UndimmedDetentView: UIViewControllerRepresentable {

    var largestUndimmedDetent: PresentationDetent?

    func makeUIViewController(context: Context) -> UIViewController {
        UndimmedDetentController()
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
    }
}
