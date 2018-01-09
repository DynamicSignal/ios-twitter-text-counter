//
//  VSTwitterTextCounter.swift
//  VoiceStorm
//
//  Created by Shady Elyaski on 12/22/17.
//  Copyright © 2018 Dynamic Signal. All rights reserved.
//

import UIKit

/**
 Lists down all different states of VSTwitterTextCounter
 */
enum VSTwitterCounterState: Int
{
    case Ok
    case Warning
    case Overflowing
}

@IBDesignable

/**
 VSTwitterTextCounter is a custom UIControl that tries to imitate the new Twitter's tweet text counter progress-based UI.
 It follows the standard that is defined in: https://github.com/twitter/twitter-text
 */
class VSTwitterTextCounter: UIControl
{
    /**
     This enum is responsible for all the conversion methods needed by **VSTwitterTextCounter**
     */
    private enum Conversion
    {
        /**
         Converts degrees to Radians
         
         - parameter value: Degree value
         
         - returns: Radians value
         */
        static func degreesToRadians(value: CGFloat) -> CGFloat
        {
            return value * .pi / 180.0
        }
        
        /**
         Finds the maximum between two *CGFloat*s
         
         - parameter value1: CGFloat 1
         - parameter value2: CGFloat 2
         
         - returns: Maximum between two value
         */
        static func max(_ value1: CGFloat, _ value2: CGFloat) -> CGFloat
        {
            return value1 > value2 ? value1 : value2
        }
    }
    
    // -- Control Constants ---
    
    /**
     Default Twitter's max text count
     */
    private static let DEFAULT_MAX_COUNT: Int = 280
    
    /**
     Circle's radius
     */
    private static let CIRCLE_RADIUS: CGFloat = 8
    
    /**
     Inner circle's stroke width
     */
    private static let INNER_STROKE_WIDTH: CGFloat = 1.5
    
    /**
     Outer circle's stroke width
     */
    private static let OUTTER_STROKE_WIDTH: CGFloat = 2
    
    /**
     Warning's cutoff percent, anything above that will show warning
     */
    private static let WARNING_CUTOFF_PERCENT: CGFloat = 92.8
    
    /**
     Control's fixed size
     */
    private static let CONTROL_SIZE: CGSize = CGSize(width: CIRCLE_RADIUS * 4,
                                                     height: CIRCLE_RADIUS * 2)
    /**
     Counter text's font
     */
    private static let NUMBER_FONT = UIFont.systemFont(ofSize: 14)
    
    /**
     Main Circle color
     */
    private static let MAIN_CIRCLE_COLOR = #colorLiteral(red: 0.8, green: 0.8392156863, blue: 0.8666666667, alpha: 1)
    
    /**
     Ok Circle color
     */
    private static let OK_CIRCLE_COLOR = #colorLiteral(red: 0.1137254902, green: 0.631372549, blue: 0.9490196078, alpha: 1)
    
    /**
     Warning Circle color
     */
    private static let WARNING_CIRCLE_COLOR = #colorLiteral(red: 1, green: 0.6784313725, blue: 0.1215686275, alpha: 1)
    
    /**
     Overflowing Circle color
     */
    private static let OVERFLOWING_CIRCLE_COLOR = #colorLiteral(red: 0.8784313725, green: 0.1411764706, blue: 0.368627451, alpha: 1)
    
    /**
     Warning counter's text color
     */
    private static let WARNING_NUMBER_COLOR = #colorLiteral(red: 0.3960784314, green: 0.4666666667, blue: 0.5254901961, alpha: 1)
    
    /**
     Overflowing counter's text color
     */
    private static let OVERFLOWING_NUMBER_COLOR = #colorLiteral(red: 0.8784313725, green: 0.1411764706, blue: 0.368627451, alpha: 1)
    
    /**
     Default counter's background color
     */
    private static let DEFAULT_BACKGROUND_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    
    //-------------------------
    
    // -- IBInspectable Variables ---
    
    /**
     Max Twitter text count supported
     */
    @IBInspectable var maxCount: Int = DEFAULT_MAX_COUNT
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    /**
     Current Twitter weighted length
     */
    @IBInspectable var weightedLength: Int = 0
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    //-------------------------------
    
    // -- Public Variables ---
    
    /**
     Current Twitter Counter state (Readonly)
     */
    var counterState: VSTwitterCounterState
    {
        if weightedLength >= maxCount
        {
            return .Overflowing
        }
        else if CGFloat(weightedLength) / CGFloat(maxCount) * 100 > VSTwitterTextCounter.WARNING_CUTOFF_PERCENT
        {
            return .Warning
        }
        else
        {
            return .Ok
        }
    }
    
    //-------------------------------
    
    // -- Internal Variables ---
    
    /**
     Used for autolayout
     
     - returns: Size for counter's content
     */
    override var intrinsicContentSize: CGSize
    {
        return CGSize(width: UIViewNoIntrinsicMetric, height: VSTwitterTextCounter.CONTROL_SIZE.height)
    }
    
    //--------------------------
    
    // MARK: - Initialization & Life Cycle
    
    public convenience init(withMaxCount maxCount: Int)
    {
        self.init(frame: CGRect.zero)
        
        self.maxCount = maxCount
    }
    
    override init(frame: CGRect)
    {
        super.init(frame: frame)
        
        setup()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        setup()
    }
    
    private func setup()
    {
        backgroundColor = VSTwitterTextCounter.DEFAULT_BACKGROUND_COLOR
    }
    
    override func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    override func draw(_ rect: CGRect)
    {
        // Drawing code
        if let ctx = UIGraphicsGetCurrentContext()
        {
            UIGraphicsPushContext(ctx)
            
            // Enable Antialiasing
            ctx.setShouldAntialias(true)
            ctx.setAllowsAntialiasing(true)
            ctx.interpolationQuality = .high
            
            let width = self.bounds.size.width
            let height = self.bounds.size.height
            
            let circle_center_point = CGPoint(x: width - VSTwitterTextCounter.CIRCLE_RADIUS - Conversion.max(VSTwitterTextCounter.INNER_STROKE_WIDTH, VSTwitterTextCounter.OUTTER_STROKE_WIDTH), y: height / 2.0)
            
            var path = UIBezierPath()
            path = UIBezierPath(arcCenter: circle_center_point, radius: VSTwitterTextCounter.CIRCLE_RADIUS, startAngle: 0, endAngle: Conversion.degreesToRadians(value: 360), clockwise: true)
            VSTwitterTextCounter.MAIN_CIRCLE_COLOR.setStroke()
            VSTwitterTextCounter.DEFAULT_BACKGROUND_COLOR.setFill()
            path.lineWidth = VSTwitterTextCounter.INNER_STROKE_WIDTH
            path.stroke()
            path.fill()
            
            ctx.saveGState()
            
            let percent = CGFloat(weightedLength) / CGFloat(maxCount)
            // swiftlint:disable missing_space_literals
            let startAngle = CGFloat(-90)   // Start drawing from center top
            // swiftlint:enable missing_space_literals
            let angle = 360 * percent + startAngle
            path = UIBezierPath(arcCenter: circle_center_point, radius: VSTwitterTextCounter.CIRCLE_RADIUS, startAngle: Conversion.degreesToRadians(value: startAngle), endAngle: Conversion.degreesToRadians(value: angle), clockwise: true)
            getCircleColor().setStroke()
            VSTwitterTextCounter.DEFAULT_BACKGROUND_COLOR.setFill()
            path.lineWidth = VSTwitterTextCounter.OUTTER_STROKE_WIDTH
            path.stroke()
            path.fill()
            
            ctx.restoreGState()
            
            let textSize = CGSize(width: circle_center_point.x - VSTwitterTextCounter.CIRCLE_RADIUS - Conversion.max(VSTwitterTextCounter.INNER_STROKE_WIDTH, VSTwitterTextCounter.OUTTER_STROKE_WIDTH) - 8, height: 14)
            let remaining = "\(maxCount - weightedLength)"
            
            switch counterState
            {
            case .Warning:
                drawMyText(remaining, VSTwitterTextCounter.WARNING_NUMBER_COLOR, VSTwitterTextCounter.NUMBER_FONT, CGRect(x: 0, y: (height - textSize.height) / 2, width: textSize.width, height: textSize.height))
            case .Overflowing:
                drawMyText(remaining, VSTwitterTextCounter.OVERFLOWING_NUMBER_COLOR, VSTwitterTextCounter.NUMBER_FONT, CGRect(x: 0, y: (height - textSize.height) / 2, width: textSize.width, height: textSize.height))
            default:
                // Do nothing
                break
            }
            
            UIGraphicsPopContext()
        }
    }
    
    // MARK: - Private helper methods
    
    private func getCircleColor() -> UIColor
    {
        switch counterState
        {
        case .Ok:
            return VSTwitterTextCounter.OK_CIRCLE_COLOR
        case .Warning:
            return VSTwitterTextCounter.WARNING_CIRCLE_COLOR
        case .Overflowing:
            return VSTwitterTextCounter.OVERFLOWING_CIRCLE_COLOR
        }
    }
    
    private func getNumberColor() -> UIColor
    {
        switch counterState
        {
        case .Ok, .Warning:
            return VSTwitterTextCounter.WARNING_NUMBER_COLOR
        case .Overflowing:
            return VSTwitterTextCounter.OVERFLOWING_NUMBER_COLOR
        }
    }
    
    private func drawMyText(_ myText: String, _ textColor: UIColor, _ font: UIFont, _ inRect: CGRect)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .right
        
        let textFontAttributes = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
            ] as [NSAttributedStringKey: Any]
        
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
        
        myText.draw(with: inRect, options: options, attributes: textFontAttributes, context: nil)
    }
}
