//
//  AttributedStringSugar.swift
//  AttributedStringSugar
//
//  Created by Elon on 2020/03/17.
//

import UIKit

@available(iOS 9.0, *)
public extension String {
    var attribute: NSMutableAttributedString {
        return NSMutableAttributedString(string: self)
    }
    
    var attributedFromHTML: NSMutableAttributedString {
        return NSMutableAttributedString(html: self) ?? NSMutableAttributedString(string: self)
    }
}

@available(iOS 9.0, *)
public extension NSMutableAttributedString {
    internal convenience init?(html: String) {
        guard let data = html.data(using: String.Encoding.utf16, allowLossyConversion: false) else {
            return nil
        }
        
        do {
            let attributedString = try NSMutableAttributedString(
                data: data,
                options: [
                    .documentType: NSAttributedString.DocumentType.html,
                    .characterEncoding: String.Encoding.utf8.rawValue
                ],
                documentAttributes: nil
            )
            
            self.init(attributedString: attributedString)
        } catch {
            print(error.localizedDescription)
            return nil
        }
    }
    
    /**
     Adds an attribute with the given name and value to the characters in the specified range.
    
     You may assign any name/value pair you wish to a range of characters. Raises an invalidArgumentException
     if name or value is nil and an rangeException
     if any part of aRange lies beyond the end of the receiver’s characters.
    
     - Parameters:
       - key: A string specifying the attribute name.
     Attribute keys can be supplied by another framework or can be custom ones you define.
     For information about the system-supplied attribute keys, see the Constants section in NSAttributedString.
       - value: The attribute value associated with name.
       - range: Range to apply. The value `nil` means full range.
    */
    @discardableResult
    func addAttribute(_ key: NSAttributedString.Key, value: Any, range: NSRange? = nil) -> NSMutableAttributedString {
        if let range = range {
            self.addAttribute(key, value: value, range: range)
        } else {
            let range = NSRange(location: 0, length: self.string.count)
            self.addAttribute(key, value: value, range: range)
        }
        
        return self
    }
    
    /**
     Adds the given collection of attributes to the characters in the specified range.
    
     You may assign any name/value pair you wish to a range of characters.
     Raises an invalidArgumentException if attributes is nil and an rangeException
     if any part of aRange lies beyond the end of the receiver’s characters.

     - Parameters:
       - attrs: A dictionary containing the attributes to add.
     Attribute keys can be supplied by another framework or can be custom ones you define.
     For information about the system-supplied attribute keys, see the Constants section in NSAttributedString.
       - range: Range to apply. The value `nil` means full range.
     */
    @discardableResult
    func addAttributes(_ attrs: [NSAttributedString.Key : Any], range: NSRange? = nil) -> NSMutableAttributedString {
        if let range = range {
            self.addAttributes(attrs, range: range)
        } else {
            let range = NSRange(location: 0, length: self.string.count)
            self.addAttributes(attrs, range: range)
        }
        
        return self
    }
    
    /**
     The value of this attribute is a UIFont object. Use this attribute to change the font for a range of text.
     If you do not specify this attribute, the string uses a 12-point Helvetica(Neue) font by default.
     
     - Parameters:
       - font: string uses a 12-point Helvetica(Neue) font by default.
       - range: Range to apply. The value `nil` means full range.
     */
    func font(_ font: UIFont, range: NSRange? = nil) -> NSMutableAttributedString {
        return self.addAttribute(.font, value: font, range: range)
    }
    
    /**
     The value of this attribute is a UIFont object. Use this attribute to change the font for a range of text.
     If you do not specify this attribute, return nil
     
     - Parameters:
        - name: costom font name. `UIFont(name: "String")`
        - size: font size
        - range: Range to apply. The value `nil` means full range.
     */
    func customFont(name: String, ofSize size: CGFloat, range: NSRange? = nil) -> NSMutableAttributedString? {
        guard let font = UIFont(name: name, size: size) else {
            print("\(name) font does not exist")
            return nil
        }
        
        return self.font(font, range: range)
    }

    /**
     font object used for standard interface items in the specified size and weight.
    
     - Parameters:
       - size: The size (in points) to which the font is scaled. This value must be greater than 0.0.
       - weight: The weight of the font, specified as a font weight constant.
     For a list of possible values, see "Font Weights” in UIFontDescriptor.
     Avoid passing an arbitrary floating-point number for weight,
     because a font might not include a variant for every weight.

       - range: Range to apply. The value `nil` means full range.
     */
    func systemFont(
        ofSize size: CGFloat,
        weight: UIFont.Weight = .regular,
        range: NSRange? = nil
    ) -> NSMutableAttributedString {
        return self.font(UIFont.systemFont(ofSize: size, weight: weight), range: range)
    }
    
    /**
     Append String
     
     - Parameters:
       - string: input string
       - makeAttribute: make attribute to input string
       - input: input string
     
     - Example
     ```swift
     "Hello, ".attribute
         .systemFont(ofSize: 30, weight: .bold)
         .append(string: "World!", makeAttribute: {
             $0.attribute
                 .systemFont(ofSize: 25, weight: .light)
                 .foreground(color: .blue)
                 .background(color: .gray)
        })
     ```
     */
    func append(
        string: String,
        makeAttribute: (_ input: String) -> NSMutableAttributedString
    ) -> NSMutableAttributedString {
        self.append(makeAttribute(string))
        return self
    }
    
    /**
     The value of this attribute is a UIColor object.
     Use this attribute to specify the color of the text during rendering.
     If you do not specify this attribute, the text is rendered in black.
     
     - Parameters:
        - color: specify the color of the text during rendering.
        - range: Range to apply. The value `nil` means full range.
     */
    func foreground(color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        return self.addAttribute(.foregroundColor, value: color, range: range)
    }
    
    /**
     The value of this attribute is a UIColor object.
     Use this attribute to specify the color of the background area behind the text.
     If you do not specify this attribute, no background color is drawn.
     
     - Parameters:
        - color: specify the color of the background area behind the text.
        - range: Range to apply. The value `nil` means full range.
     */
    func background(color: UIColor, range: NSRange? = nil) -> NSMutableAttributedString {
        return self.addAttribute(.backgroundColor, value: color, range: range)
    }
    
    /**
     The value of this attribute is an NSParagraphStyle object.
     Use this attribute to apply multiple attributes to a range of text.
     If you do not specify this attribute, the string uses the default paragraph attributes,
     as returned by the default method of NSParagraphStyle.
     
     - Parameters:
        - lineSpacing: The distance in points between the bottom of one line fragment and the top of the next.
        This value is always nonnegative. This value is included in the line fragment heights in the layout manager.
     
        - minimumLineHeight: The receiver’s minimum height.
        This property contains the minimum height in points that any line in the receiver will occupy, regardless of the font size or size of any attached graphic. This value must be nonnegative.
     
        - maximumLineHeight: The receiver’s maximum line height.
        This property contains the maximum height in points that any line in the receiver will occupy, regardless of the font size or size of any attached graphic. This value is always nonnegative. The default value is 0.
     
        Glyphs and graphics exceeding this height will overlap neighboring lines; however, a maximum height of 0 implies no line height limit. Although this limit applies to the line itself, line spacing adds extra space between adjacent lines.
     
        - lineHeightMultiple: The line height multiple.
        The natural line height of the receiver is multiplied by this factor (if positive) before being constrained by minimum and maximum line height. The default value of this property is 0.0.
     
        - alignment: The text alignment of the receiver.
        Natural text alignment is realized as left or right alignment depending on the line sweep direction of the
        first script contained in the paragraph. For a list of alignment constants, see the “Constants” section of
        NSString UIKit Additions Reference.
     
        - lineBreakMode: The mode that should be used to break lines in the receiver.
        This property contains the line break mode to be used laying out the paragraph’s text.
        For a list of line break constants, see the “Constants” section of NSParagraphStyle.
     
        - firstLineHeadIndent: The indentation of the first line of the receiver.
        This property contains the distance (in points) from the leading margin of a text container to the beginning of the paragraph’s first line. This value is always nonnegative.

        - headIndent: The indentation of the receiver’s lines other than the first.
        This property contains the distance (in points) from the leading margin of a text container to the beginning of lines other than the first. This value is always nonnegative.

        - tailIndent: The indentation of the receiver’s lines other than the first.
        If positive, this value is the distance from the leading margin (for example, the left margin in left-to-right text). If 0 or negative, it’s the distance from the trailing margin.
     
        For example, a paragraph style designed to fit exactly in a 2-inch wide container has a head indent of 0.0 and a tail indent of 0.0. One designed to fit with a quarter-inch margin has a head indent of 0.25 and a tail indent of –0.25.
     
        - paragraphSpacingBefore: The distance between the paragraph’s top and the beginning of its text content.
        This property contains the space (measured in points) between the paragraph’s top and the beginning of its text content. The default value of this property is 0.0.
     
        - paragraphSpacing: The space after the end of the paragraph.
        This property contains the space (measured in points) added at the end of the paragraph to separate it from the following paragraph. This value must be nonnegative. The space between paragraphs is determined by adding the previous paragraph’s paragraphSpacing and the current paragraph’s paragraphSpacingBefore.
     
        - baseWritingDirection: The base writing direction for the receiver.
        If you specify NSWritingDirectionNaturalDirection, the receiver resolves the writing direction to either NSWritingDirectionLeftToRight or NSWritingDirectionRightToLeft, depending on the direction for the user’s language preference setting.

        - range: Range to apply. The value `nil` means full range.
     */
    func paragraphStyle(
        lineSpacing: CGFloat? = nil,
        minimumLineHeight: CGFloat? = nil,
        maximumLineHeight: CGFloat? = nil,
        lineHeightMultiple: CGFloat? = nil,
        alignment: NSTextAlignment? = nil,
        lineBreakMode: NSLineBreakMode? = nil,
        firstLineHeadIndent: CGFloat? = nil,
        headIndent: CGFloat? = nil,
        tailIndent: CGFloat? = nil,
        paragraphSpacingBefore: CGFloat? = nil,
        paragraphSpacing: CGFloat? = nil,
        baseWritingDirection: NSWritingDirection? = nil,
        range: NSRange? = nil
    ) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        
        if let lineSpacing = lineSpacing {
            paragraphStyle.lineSpacing = lineSpacing
        }
        if let minimumLineHeight = minimumLineHeight {
            paragraphStyle.minimumLineHeight = minimumLineHeight
        }
        if let maximumLineHeight = maximumLineHeight {
            paragraphStyle.maximumLineHeight = maximumLineHeight
        }
        if let lineHeightMultiple = lineHeightMultiple {
            paragraphStyle.lineHeightMultiple = lineHeightMultiple
        }
        if let alignment = alignment {
            paragraphStyle.alignment = alignment
        }
        if let lineBreakMode = lineBreakMode {
            paragraphStyle.lineBreakMode = lineBreakMode
        }
        if let firstLineHeadIndent = firstLineHeadIndent {
            paragraphStyle.firstLineHeadIndent = firstLineHeadIndent
        }
        if let headIndent = headIndent {
            paragraphStyle.headIndent = headIndent
        }
        if let tailIndent = tailIndent {
            paragraphStyle.tailIndent = tailIndent
        }
        if let paragraphSpacingBefore = paragraphSpacingBefore {
            paragraphStyle.paragraphSpacingBefore = paragraphSpacingBefore
        }
        if let paragraphSpacing = paragraphSpacing {
            paragraphStyle.paragraphSpacing = paragraphSpacing
        }
        if let baseWritingDirection = baseWritingDirection {
            paragraphStyle.baseWritingDirection = baseWritingDirection
        }
        
        return self.addAttribute(.paragraphStyle, value: paragraphStyle, range: range)
    }
    
    /**
     The value of this attribute is an NSNumber object containing an integer.
     This value indicates whether the text is underlined and corresponds to one of the constants described in
     NSUnderlineStyle.
     The default value for this attribute is styleNone.
     
     - Parameters:
       - style: The default value for this attribute is styleNone.
     
       - color: The value of this attribute is a UIColor object. The default value is nil, indicating same as foreground color.
     
       - range: Range to apply. The value `nil` means full range.
     */
    func underline(style: NSUnderlineStyle, color: UIColor? = nil, range: NSRange? = nil) -> NSMutableAttributedString {
        // - FIXME: 정상 동작 안됨 수정 필요 2020-03-16 02:42:49
        var attributes: [NSAttributedString.Key: Any] = [
            .underlineStyle: style.rawValue
        ]
        
        if let color = color {
            attributes[.underlineColor] = color
        }
        
        return self.addAttributes(attributes, range: range)
    }
    
    /**
     The value of this attribute is an NSNumber object containing an integer.
     This value indicates whether the text has a line through it and corresponds to one of the constants described in
     NSUnderlineStyle. The default value for this attribute is styleNone.
     
     - Parameters:
       - style: The default value for this attribute is styleNone.
     
       - color: The value of this attribute is a UIColor object. The default value is nil,
     indicating same as foreground color.
     
       - range: Range to apply. The value `nil` means full range.
     */
    func strikeThrough(
        style: NSUnderlineStyle,
        color: UIColor? = nil,
        range: NSRange? = nil
    ) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .strikethroughStyle: style.rawValue
        ]
        
        if let color = color {
            attributes[.strikethroughColor] = color
        }
        
        return self.addAttributes(attributes, range: range)
    }
    
    /**
     stroke and fill the text.
     
     - Parameters:
       - width: The value of this attribute is an NSNumber object containing a floating-point value.
     This value represents the amount to change the stroke width and is specified as a percentage of the font point size.
     Specify 0 (the default) for no additional changes.
     Specify positive values to change the stroke width alone.
     Specify negative values to stroke and fill the text. For example, a typical value for outlined text would be 3.0.
     
       - color: The value of this parameter is a UIColor object.
     If it is not defined (which is the case by default), it is assumed to be the same as the value of foregroundColor;
     otherwise, it describes the outline color.
     For more details, see Drawing attributed strings that are both filled and stroked.
     
       - range: Range to apply. The value `nil` means full range.
     */
    func stroke(width: Double, color: UIColor? = nil, range: NSRange? = nil) -> NSMutableAttributedString {
        var attributes: [NSAttributedString.Key: Any] = [
            .strokeWidth: width
        ]
        
        if let color = color {
            attributes[.strokeColor] = color
        }
        
        return self.addAttributes(attributes, range: range)
    }
    
    /**
     The value of this attribute is an NSNumber object containing a floating-point value.
     This value specifies the number of points by which to adjust kern-pair characters.
     Kerning prevents unwanted space from occurring between specific characters and depends on the font.
     The value 0 means kerning is disabled. The default value for this attribute is 0.
     
     - Parameters:
       - value: The default value for this attribute is 0
       - range: Range to apply. The value `nil` means full range.
     */
    func kerning(_ value: Double, range: NSRange? = nil) -> NSMutableAttributedString {
        return self.addAttribute(.kern, value: value, range: range)
    }
    
    /**
     The value of this attribute is an NSShadow object.
     
     - Parameters:
        - offset: The offset values of the shadow.
        This property contains the horizontal and vertical offset values,
        specified using the width and height fields of the CGSize data type.
        These offsets are measured using the default user coordinate space and are not affected by custom transformations.
        This means that positive values always extend down and to the right from the user's perspective.
        
        - color: The color of the shadow.
        The default shadow color is black with an alpha of 1/3. If you set this property to nil,
        the shadow is not drawn. The color you specify must be convertible to an RGBA color and may contain alpha
        information.
        
        - blurRadius: The blur radius of the shadow.
        This property contains the blur radius, as measured in the default user coordinate space.
        A value of 0 indicates no blur, while larger  values produce    correspondingly larger blurring.
        This value must not be negative. The default value is 0.
        
        - range: Range to apply. The value `nil` means full range.
     */
    func shadow(
        offset: CGSize? = nil,
        color: UIColor? = nil,
        blurRadius: CGFloat? = nil,
        range: NSRange? = nil
    ) -> NSMutableAttributedString {
        let shadow = NSShadow()
        if let offset = offset {
            shadow.shadowOffset = offset
        }
        
        if let color = color {
            shadow.shadowColor = color
        }
        
        if let blurRadius = blurRadius {
            shadow.shadowBlurRadius = blurRadius
        }
        
        return self.addAttribute(.shadow, value: shadow, range: range)
    }
    
    
    /// The value of this attribute is an URL object. The default value of this property is nil, indicating no link.
    /// - Parameters:
    ///   - url: URL
    ///   - range: Range to apply. The value `nil` means full range.
    func link(url: URL, range: NSRange? = nil) -> NSMutableAttributedString {
        return self.addAttribute(.link, value: url, range: range)
    }
    
    /**
     The value of this attribute is an NSTextAttachment object. The default value of this property is nil, indicating no attachment.
     
     - Parameters:
       - image: Image representing the text attachment contents.
       - bounds: Defines the layout bounds of the receiver's graphical representation in the text coordinate system. The bounds rectangle origin is at the current glyph location on the text baseline. The default value is CGRectZero.
       - range: Range to apply. The value `nil` means full range.
     ```swift
     let attributedText = "text".attachment(image: UIImage(named: "image name"))
     
     let label = UILabel()
     label.attributedText = attributedText
     label.sizeToFit() // Required
     ```
     */
    func attachment(image: UIImage?, bounds: CGRect? = nil, range: NSRange? = nil) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        if let bounds = bounds {
            attachment.bounds = bounds
        }
        
        return self.addAttribute(.attachment, value: attachment, range: range)
    }
    
    /**
     The value of this attribute is an NSTextAttachment object.
  
     - Parameters:
       - image: Image representing the text attachment contents.
       - bounds: imageBounds The rectangle in which the image is laid out.
       - textContainer: The text container in which the image is laid out.
       - characterIndex: The character location inside the text storage for the attachment character.
       - range: Range to apply. The value `nil` means full range.
     ```swift
     let imageSize = CGRect(x: 0, y: 0, width: 30, height: 30)
     let attributedText = "text".attachment(image: UIImage(named: "image name"), bound: imageSize)
     
     let label = UILabel()
     label.attributedText = attributedText
     label.sizeToFit() // Required
     ```
     */
    func attachment(
        image: UIImage?,
        bounds imageBounds: CGRect,
        textContainer: NSTextContainer? = nil,
        characterIndex: Int,
        range: NSRange? = nil
    ) -> NSMutableAttributedString {
        let attachment = NSTextAttachment()
        attachment.image = image
        
        attachment.image(
            forBounds: imageBounds,
            textContainer: textContainer,
            characterIndex: characterIndex
        )
        
        return self.addAttribute(.attachment, value: attachment, range: range)
    }
}
