//
//  DoubleSliderTouchTracking.swift
//  DoubleSlider
//
//  Created by josh on 2018/03/30.
//  Copyright © 2018年 yhkaplan. All rights reserved.
//

import UIKit

extension DoubleSlider {
    
    // MARK: - Touch tracking
    
    override open func beginTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        previousLocation = touch.location(in: self)
        
        if lowerThumbLayer.frame.contains(previousLocation) {
            lowerThumbLayer.isHighlighted = true
        } else if upperThumbLayer.frame.contains(previousLocation) {
            upperThumbLayer.isHighlighted = true
        }
        
        return lowerThumbLayer.isHighlighted || upperThumbLayer.isHighlighted
    }
    
    override open func continueTracking(_ touch: UITouch, with event: UIEvent?) -> Bool {
        let location = touch.location(in: self)
        
        // Check drag distance
        let dragDistance = Double(location.x - previousLocation.x)
        let dragValue = (maxValue - minValue) * dragDistance / Double(bounds.width - thumbWidth)
        
        previousLocation = location
        
        var minimumSpace: Double = 0.05
        if numberOfSteps > 0 {
            minimumSpace = 1.0 / Double(numberOfSteps)
        }
        let halfMinSpace = minimumSpace / 2.0
        
        // Update values
        if lowerThumbLayer.isHighlighted {
            var lowerTempValue = lowerValue + dragValue
            lowerTempValue = boundValue(value: lowerTempValue, lowerValue: minValue, upperValue: upperValue)
            
            if !smoothStepping && numberOfSteps > 0 {
                //TODO: implement! step
            }
            
            if (lowerTempValue + halfMinSpace) > (upperValue - halfMinSpace) {
                lowerTempValue = upperValue - minimumSpace
            }
            
            lowerValue = lowerTempValue
            
            
        } else if upperThumbLayer.isHighlighted {
            var upperTempValue = upperValue + dragValue
            upperTempValue = boundValue(value: upperTempValue, lowerValue: lowerValue, upperValue: maxValue)
            
            if !smoothStepping && numberOfSteps > 0 {
                //TODO: implement! step
            }
            
            if (upperTempValue - halfMinSpace) < (lowerValue + halfMinSpace) {
                upperTempValue = lowerValue + minimumSpace
            }
            
            upperValue = upperTempValue
        }
        
        // Declare that a value was updated, called continuously
        sendActions(for: .valueChanged)
        valueChangedDelegate?.valueChanged(for: self)
        
        return true
    }
    
    override open func endTracking(_ touch: UITouch?, with event: UIEvent?) {
        lowerThumbLayer.isHighlighted = false
        upperThumbLayer.isHighlighted = false
        
        // Declare that the change finished, called at the end
        // of a drag session
        sendActions(for: .editingDidEnd)
        editingDidEndDelegate?.editingDidEnd(for: self)
    }
    
    // MARK: - Private funcs
    
    private func boundValue(value: Double, lowerValue: Double, upperValue: Double) -> Double {
        return min(max(value, lowerValue), upperValue)
    }
}
