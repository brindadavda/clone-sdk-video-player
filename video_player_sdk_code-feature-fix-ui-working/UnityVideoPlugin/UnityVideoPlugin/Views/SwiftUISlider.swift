//
//  SwiftUISlider.swift
//  UnityVideoPlugin
//
//  Created by Brinda Davda on 16/05/25.
//
import SwiftUI
import Foundation

public struct SwiftUISlider: UIViewRepresentable {

    final public class Coordinator: NSObject {
        var value: Binding<Double>
        var maxValue: Double
        var parent: SwiftUISlider?
        var lastIsLandscape: Bool?

        public init(value: Binding<Double>, maxValue: Double, parent: SwiftUISlider? = nil) {
            self.value = value
            self.maxValue = maxValue
            self.parent = parent
            self.lastIsLandscape = parent?.isLandscape // Initial orientation
        }

        @objc func valueChanged(_ sender: UISlider) {
            let newValue = Double(sender.value) / 100
            if abs(self.value.wrappedValue - newValue) > 0.001 {
                self.value.wrappedValue = newValue
            }
        }

        @objc func dragStarted(_ sender: UISlider) {
            parent?.onEditingChanged?(true)
        }

        @objc func dragEnded(_ sender: UISlider) {
            parent?.onEditingChanged?(false)
        }
    }

    @Binding var value: Double
    var isLandscape: Bool
    var maxValue: Double
    private let bundle = Bundle(for: PlayerController.self)
    var onEditingChanged: ((Bool) -> Void)? = nil

    public func makeUIView(context: Context) -> UISlider {
        let slider = UISlider(frame: .zero)

        configureSlider(slider, isLandscape: isLandscape)

        slider.minimumValue = 0
        slider.maximumValue = Float(maxValue) * 100
        slider.value = Float(value * 100)

        slider.addTarget(context.coordinator, action: #selector(Coordinator.valueChanged(_:)), for: .valueChanged)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.dragStarted(_:)), for: .touchDown)
        slider.addTarget(context.coordinator, action: #selector(Coordinator.dragEnded(_:)), for: [.touchUpInside, .touchUpOutside, .touchCancel])

        return slider
    }

    public func updateUIView(_ uiView: UISlider, context: Context) {
        uiView.value = Float(self.value * 100)

        // Update only when orientation changes
        if context.coordinator.lastIsLandscape != isLandscape {
            context.coordinator.lastIsLandscape = isLandscape
            configureSlider(uiView, isLandscape: isLandscape)
        }
    }
  
  private func configureSlider(_ slider: UISlider, isLandscape: Bool) {
      let thumbSize: CGFloat = isLandscape ? 45 : 30
      let trackHeight: CGFloat = isLandscape ? 15 : 6 // dynamic based on device/orientation
      let capInset: CGFloat = 8

      // ✅ Resize thumb image
      let thumbImage = UIImage(resource: .init(name: "Circle", bundle: bundle))
          .resized(to: CGSize(width: thumbSize, height: thumbSize))
      slider.setThumbImage(thumbImage, for: .normal)

      // ✅ Resize track imag es to fixed height, then apply cap insets
      let originalMinTrack = UIImage(resource: .init(name: "slider_thik", bundle: bundle))
          let resizedMinTrack = originalMinTrack.resized(to: CGSize(width: originalMinTrack.size.width, height: trackHeight))
          let minTrackImage = resizedMinTrack.resizableImage(
              withCapInsets: UIEdgeInsets(top: 0, left: capInset, bottom: 0, right: capInset),
              resizingMode: .stretch
          )
          slider.setMinimumTrackImage(minTrackImage, for: .normal)
    

      let originalMaxTrack = UIImage(resource: .init(name: "slider", bundle: bundle))
          let resizedMaxTrack = originalMaxTrack.resized(to: CGSize(width: originalMaxTrack.size.width, height: trackHeight))
          let maxTrackImage = resizedMaxTrack.resizableImage(
              withCapInsets: UIEdgeInsets(top: 0, left: capInset, bottom: 0, right: capInset),
              resizingMode: .stretch
          )
          slider.setMaximumTrackImage(maxTrackImage, for: .normal)
    

      // ✅ Make sure slider doesn't become too tall
      slider.bounds.size.height = max(thumbSize, trackHeight)
  }


    public func makeCoordinator() -> SwiftUISlider.Coordinator {
        Coordinator(value: $value, maxValue: maxValue, parent: self)
    }
}
