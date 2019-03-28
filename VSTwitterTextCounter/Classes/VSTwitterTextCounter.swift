//
//  VSTwitterTextCounter.swift
//  VSTwitterTextCounter
//
//  Created by Shady Elyaski on 12/22/17.
//  Copyright © 2018 Dynamic Signal. All rights reserved.
//

import UIKit

/**
 Lists down all different states of VSTwitterTextCounter
 */
public enum VSTwitterTextCounterState: Int
{
    case Ok
    case Warning
    case Overflowing
}

@IBDesignable

/**
 VSTwitterTextCounter is a custom UIControl that tries to imitate the new Twitter's tweet text counter progress-based UI.
 It follows the standard that is defined in: https://developer.twitter.com/en/docs/developer-utilities/twitter-text
 */
public class VSTwitterTextCounter: UIControl
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
    private static let CONTROL_SIZE: CGSize = CGSize(width: (CIRCLE_RADIUS +
                                                             Conversion.max(VSTwitterTextCounter.INNER_STROKE_WIDTH, VSTwitterTextCounter.OUTTER_STROKE_WIDTH)) * 10,
                                                     height: (CIRCLE_RADIUS +
                                                              Conversion.max(VSTwitterTextCounter.INNER_STROKE_WIDTH, VSTwitterTextCounter.OUTTER_STROKE_WIDTH)) * 2)

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
     Overflowing text's background color
     */
    private static let OVERFLOWING_TEXT_BACKGROUND = #colorLiteral(red: 1, green: 0.7215686275, blue: 0.7607843137, alpha: 1)
    
    /**
     Default counter's background color
     */
    private static let DEFAULT_BACKGROUND_COLOR = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
    
    //-------------------------
    
    // -- IBInspectable Variables ---
    
    /**
     Max Twitter text count supported
     */
    @IBInspectable open var maxCount: Int = DEFAULT_MAX_COUNT
    {
        didSet
        {
            setNeedsDisplay()
        }
    }
    
    /**
     Current Twitter weighted length
     Please use [Twitter's library](https://github.com/twitter/twitter-text/tree/master/objc) to correctly calculate weighted length of a string
     */
    @IBInspectable open var weightedLength: Int = 0
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
    open var counterState: VSTwitterTextCounterState
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
    override public var intrinsicContentSize: CGSize
    {
        return VSTwitterTextCounter.CONTROL_SIZE
    }
    
    //--------------------------
    
    // MARK: - Initialization & Life Cycle
    
    /**
     Initializes **VSTwitterTextCounter** with a new max character count
     NB. Control size is defaulted to *VSTwitterTextCounter.CONTROL_SIZE*
     */
    public convenience init(withMaxCount maxCount: Int)
    {
        let frame = CGRect(x: 0, y: 0, width: VSTwitterTextCounter.CONTROL_SIZE.width, height: VSTwitterTextCounter.CONTROL_SIZE.height)
        
        self.init(frame: frame)
        
        self.maxCount = maxCount
    }
    
    /**
     Initializes **VSTwitterTextCounter** with a start point
     NB. Control size is defaulted to *VSTwitterTextCounter.CONTROL_SIZE*
     */
    public convenience init(point: CGPoint)
    {
        let frame = CGRect(x: point.x, y: point.y, width: VSTwitterTextCounter.CONTROL_SIZE.width, height: VSTwitterTextCounter.CONTROL_SIZE.height)
        
        self.init(frame: frame)
    }
    
    /**
     Initializes **VSTwitterTextCounter**
     NB. Control size is defaulted to *VSTwitterTextCounter.CONTROL_SIZE*
     */
    public convenience init()
    {
        let point = CGPoint(x: 0, y: 0)
        
        self.init(point: point)
    }
    
    /**
     Initializes **VSTwitterTextCounter** with a frame
     NB. Control size is defaulted to *VSTwitterTextCounter.CONTROL_SIZE*
     */
    override public init(frame: CGRect)
    {
        let newFrame = CGRect(x: frame.origin.x, y: frame.origin.y, width: VSTwitterTextCounter.CONTROL_SIZE.width, height: VSTwitterTextCounter.CONTROL_SIZE.height)
        
        super.init(frame: newFrame)
        
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        
        // Force frame size
        self.frame = CGRect(x: frame.origin.x, y: frame.origin.y, width: VSTwitterTextCounter.CONTROL_SIZE.width, height: VSTwitterTextCounter.CONTROL_SIZE.height)
        
        setup()
    }
    
    private func setup()
    {
        backgroundColor = VSTwitterTextCounter.DEFAULT_BACKGROUND_COLOR
    }
    
    override public func awakeFromNib()
    {
        super.awakeFromNib()
        
    }
    
    override public func draw(_ rect: CGRect)
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
            
            // Draw the main background circle
            
            let circle_center_point = CGPoint(x: width - VSTwitterTextCounter.CIRCLE_RADIUS - Conversion.max(VSTwitterTextCounter.INNER_STROKE_WIDTH, VSTwitterTextCounter.OUTTER_STROKE_WIDTH), y: height / 2.0)
            
            var path = UIBezierPath()
            path = UIBezierPath(arcCenter: circle_center_point, radius: VSTwitterTextCounter.CIRCLE_RADIUS, startAngle: 0, endAngle: Conversion.degreesToRadians(value: 360), clockwise: true)
            VSTwitterTextCounter.MAIN_CIRCLE_COLOR.setStroke()
            VSTwitterTextCounter.DEFAULT_BACKGROUND_COLOR.setFill()
            path.lineWidth = VSTwitterTextCounter.INNER_STROKE_WIDTH
            path.stroke()
            path.fill()
            
            ctx.saveGState()
            
            // Draw the progress circle
            
            let percent = CGFloat(weightedLength) / CGFloat(maxCount)
            let startAngle = CGFloat(-90)   // Start drawing from center top
            let angle = 360 * percent + startAngle
            path = UIBezierPath(arcCenter: circle_center_point, radius: VSTwitterTextCounter.CIRCLE_RADIUS, startAngle: Conversion.degreesToRadians(value: startAngle), endAngle: Conversion.degreesToRadians(value: angle), clockwise: true)
            getCircleColor().setStroke()
            VSTwitterTextCounter.DEFAULT_BACKGROUND_COLOR.setFill()
            path.lineWidth = VSTwitterTextCounter.OUTTER_STROKE_WIDTH
            path.stroke()
            path.fill()
            
            ctx.restoreGState()
            
            // Draw the remaining characters count if needed
            
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
    
    // MARK: - Public helper methods
    
    /**
     Updates the layout of the TextView's depending on the new weighted length, like showing the overflowing text background.
     
     - parameter textView: Reference to the **UITextView** that needs to be updated
     - parameter textWeightedLength: The text's weighted length as calculated by Twitter's SDK NB. If the weighted length has been passed here, there is no need to pass it in again to the *weightedLength* property
     */
    public func update(with textView: UITextView, textWeightedLength: Int? = nil)
    {
        if let textWeightedLength = textWeightedLength
        {
            weightedLength = textWeightedLength
        }
        
        // Store the current cursor position as a range
        let preAttributedRange = textView.selectedRange
        
        // Highlight any overflowing text
        if weightedLength > maxCount
        {
            let objcString = NSString(string: textView.text)
            
            // Find if last allowed index falls between a unicode character
            var lastAllowedCharacterIndex = objcString.length > maxCount ? maxCount : objcString.length - 1    // Last allowed character index
            let rangeOfComposedCharacter = objcString.rangeOfComposedCharacterSequence(at: lastAllowedCharacterIndex)
            if rangeOfComposedCharacter.contains(lastAllowedCharacterIndex)
            {
                lastAllowedCharacterIndex = rangeOfComposedCharacter.location
            }
            // -------------------------------------------------------------
            
            // Split the string using NSString as Swift string counts Unicode characters as one each
            let okString = objcString.substring(to: lastAllowedCharacterIndex)
            let overflowingString = objcString.substring(from: lastAllowedCharacterIndex)
            
            let attributedString = NSMutableAttributedString(string: okString, attributes: [.font: textView.font!])
            
            attributedString.append(NSAttributedString(string: overflowingString, attributes: [.backgroundColor: VSTwitterTextCounter.OVERFLOWING_TEXT_BACKGROUND, .font: textView.font!]))
            
            textView.attributedText = attributedString
        }
        else    // Reset any kind of formatting
        {
            textView.attributedText = NSAttributedString(string: textView.text, attributes: [.font: textView.font!])   // Resets any kind of attributes
        }
        
        // Reapply the range
        textView.selectedRange = preAttributedRange
    }
    
    // MARK: - Private helper methods
    
    /**
     Figure out what color should we use to draw the progress circle
     
     - returns: UIColor value
     */
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
    
    /**
     Figure out what color should we use to draw the number
     
     - returns: UIColor value
     */
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
    
    /**
     Draw text with the specified attributes
     
     - parameter myText: Text needed to be drawn
     - parameter textColor: Text color
     - parameter font: Text font
     - parameter inRect: Drawing rectangle, text will be wrapped inside
     */
    private func drawMyText(_ myText: String, _ textColor: UIColor, _ font: UIFont, _ inRect: CGRect)
    {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineBreakMode = .byTruncatingTail
        paragraphStyle.alignment = .right
        
        let textFontAttributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
            ]
        
        let options: NSStringDrawingOptions = [.usesLineFragmentOrigin]
        
        myText.draw(with: inRect, options: options, attributes: textFontAttributes, context: nil)
    }
}
