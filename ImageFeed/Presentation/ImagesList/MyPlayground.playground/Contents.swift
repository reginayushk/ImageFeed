import Foundation
import UIKit
import PlaygroundSupport

let controllerView = UIView(frame: CGRect(x: 0, y: 0, width: 400, height: 700))

PlaygroundPage.current.liveView = controllerView

let view = UIView(frame: CGRect(x: 100, y: 100, width: 100, height: 100))
view.backgroundColor = .green
controllerView.addSubview(view)

let t1 = CGAffineTransform(rotationAngle: 3.14)

UIView.animateKeyframes(withDuration: 5, delay: 0) {
    UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.4) {
        view.backgroundColor = .red
        view.transform = CGAffineTransform(rotationAngle: 3.14)
    }
    
    UIView.addKeyframe(withRelativeStartTime: 0.4, relativeDuration: 0.2) {
        view.backgroundColor = .yellow
    }
    
    UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4) {
        view.backgroundColor = .green
        view.transform = view.transform.rotated(by: -1 * 3.14)
        view.transform.ro
//        view.transform = CGAffineTransform(rotationAngle: -1 * 3.14)
    }
}

