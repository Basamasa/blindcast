//
//  TutorialView.swift
//  Blindcast
//
//  Created by Jan Anstipp on 07.02.20.
//  Copyright © 2020 handycap. All rights reserved.
//

import SwiftUI
import AVFoundation
import Foundation

struct TutorialView_Previews: PreviewProvider {
    static var previews: some View {
        TutorialView()
    }
}

struct TutorialView : View {
    @ObservedObject var model = TutorialViewModel()

    var body: some View {
        ZStack{
            UIGestureView{callBack in self.model.newState(callBack)
            }
//            Text(model.lastGestureValue)
            Text("Demo")
        }.onAppear(){
            self.model.startTutorial()
        }
    }
}

// https://stackoverflow.com/questions/56513942/how-to-detect-a-tap-gesture-location-in-swiftui
struct UIGestureView:UIViewRepresentable {
    var callback: ((GestureState) -> Void)

    func makeUIView(context: UIViewRepresentableContext<UIGestureView>) -> UIView {
        let view = UIView(frame: .zero)
        
        let oneTapOneTouch = UITapGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.gesture))
        oneTapOneTouch.numberOfTapsRequired = 1
        oneTapOneTouch.numberOfTouchesRequired = 1
        
        let twoTapOneTouch = UITapGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.gesture))
        twoTapOneTouch.numberOfTapsRequired = 2
        twoTapOneTouch.numberOfTouchesRequired = 1
        
        let swipeLeft = UISwipeGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.gesture))
        swipeLeft.direction = .left
        
        let swipeRight = UISwipeGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.gesture))
        swipeRight.direction = .right
        
        let swipeUp = UISwipeGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.gesture))
        swipeUp.direction = .up
        
        let swipeDown = UISwipeGestureRecognizer(target: context.coordinator,action: #selector(Coordinator.gesture))
        swipeDown.direction = .down
        oneTapOneTouch.require(toFail: twoTapOneTouch)
        
//        let touch = UILongPressGestureRecognizer(target: context.coordinator,
//        action: #selector(Coordinator.touch))
//        touch.minimumPressDuration = 0.01

//        view.addGestureRecognizer(touch)
        view.addGestureRecognizer(oneTapOneTouch)
        view.addGestureRecognizer(twoTapOneTouch)
        view.addGestureRecognizer(swipeLeft)
        view.addGestureRecognizer(swipeRight)
        view.addGestureRecognizer(swipeUp)
        view.addGestureRecognizer(swipeDown)

        return view
    }
    

    class Coordinator: NSObject {
        var callback: ((GestureState) -> Void)
        var speaker = Speaker.instance
        
        init(callback: @escaping ((GestureState) -> Void)) {
            self.callback = callback
        }

        
//        @objc func touch(gesture: UIGestureRecognizer){
//            switch gesture.state{
//            case .began:
//                playAudio()
//                break
//            case .ended:
//                usleep(60000)
//                stopAudio()
//                break
//            default: break
//            }
//        }
        
        @objc func gesture(gesture: UIGestureRecognizer){
            
            if gesture.state == UIGestureRecognizer.State.ended {
                if let swipeGesture = gesture as? UISwipeGestureRecognizer{
                    if let direction = SwipeDirection.getDirection(swipeGesture.direction.rawValue){
                        let state = GestureState.init(isStart: false, type: GestureType.swipe(direction))
                        self.callback(state)
                    }
                }
                if let tapGesture = gesture as? UITapGestureRecognizer{
                    let state = GestureState.init(isStart: false, type: .tap(tapGesture.numberOfTapsRequired, tapGesture.numberOfTouchesRequired))
                    self.callback(state)
                }
            }
        }
    }

    func makeCoordinator() -> UIGestureView.Coordinator {
        return Coordinator(callback:self.callback)
    }

    func updateUIView(_ uiView: UIView,
                       context: UIViewRepresentableContext<UIGestureView>) {
    }

}

enum SwipeDirection {
    case right
    case left
    case up
    case down
    
    var description: String {
        switch self {
        case .right: return "right"
        case .left: return "left"
        case .up: return "up"
        case .down: return "down"
        }
    }

    
    static func getDirection(_ direction: UInt) -> SwipeDirection?{
        switch direction {
        case 1: return .right
        case 2: return .left
        case 4: return .up
        case 8: return .down
        default: return nil
        }
    }
    
}

struct GestureState{
    var isStart: Bool
    var type: GestureType
}

enum GestureType{
    case touch
    case tap(_ tap: Int,_ touch: Int)
    case swipe(SwipeDirection)
    var tap: (tap: Int,touch: Int)?{
        switch self {
        case let .tap(x,y):
            return (x,y)
        default:
            return nil
        }
    }
    
    func equals(_ gesture: GestureType) -> Bool{
        switch (self,gesture)  {
        case let (.tap(x1, y1),.tap(x2, y2)):
            return x1 == x2 && y1 == y2
        case let (.swipe(dircetion1),.swipe(dircetion2)):
            return dircetion1 == dircetion2
        case (.touch,.touch):
            return true
        default: return false
        }
    }
    
    var description: String {
        switch self {
        case let .swipe(dircetion):
            return "Swipe \(dircetion.description)"
        case let .tap(x, y):
            return "\(x) Taps, \(y) Fingers"
        case .touch:
            return "touch"
        }
    }
    
    var direction: SwipeDirection?{
        switch self {
        case let .swipe(x):
            return x
        default:
            return nil
        }
    }
}
