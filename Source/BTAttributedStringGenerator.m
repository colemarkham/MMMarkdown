//
//  BTAttributedStringGenerator.m
//  Literary Criticism
//
//  Created by Cole Markham on 1/30/15.
//  Copyright (c) 2015 Best of Texas Contest and Apps. All rights reserved.
//

#import "BTAttributedStringGenerator.h"
#import "MMElement.h"
#import "MMParser.h"
#import "MMMarkdown.h"
#import "MMDocument.h"

@implementation BTAttributedStringGenerator

+(void)applyAttributedText:(NSString *)markdown toLabel:(UILabel *)label{
    NSError *error;
    MMParser *parser = [[MMParser alloc] initWithExtensions:MMMarkdownExtensionsNone];
    MMDocument *document = [parser parseMarkdown:markdown error:&error];
    BTAttributedStringGenerator *generator = [[BTAttributedStringGenerator alloc] init];
    generator.baseFont = label.font;
    generator.italicFont = [UIFont fontWithName:@"SourceSansPro-It" size:label.font.pointSize];
    generator.boldFont = [UIFont fontWithName:@"SourceSansPro-Bold" size:label.font.pointSize];
    NSAttributedString* attrStr = [generator generateAttributedString:document];
    label.attributedText = attrStr;
}

#pragma mark - Public Methods

- (NSAttributedString *)generateAttributedString:(MMDocument *)aDocument
{
    if (string == nil)
    {
        NSString *reason = [NSString stringWithFormat:@"[%@ %@]: nil argument for markdown",
                            NSStringFromClass(self.class), NSStringFromSelector(selector)];
        @throw [NSException exceptionWithName:NSInvalidArgumentException reason:reason userInfo:nil];
    }
    
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] init];
    
    if (string.length == 0)
        return attributedString;
    
    for (MMElement *element in aDocument.elements)
    {
        // FIXME parse or strip HTML tags
        if (element.type == MMElementTypeHTML)
        {
            NSDictionary *attributes = @{};
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:[aDocument.markdown substringWithRange:element.range] attributes: attributes]];
        }
        else
        {
            [self _generateAttributesForElement:element
                                     inDocument:aDocument
                               attributedString:attributedString];
        }
    }
    
    return attributedString;
}


#pragma mark - Private Methods

- (void)_generateAttributesForElement:(MMElement *)anElement
                           inDocument:(MMDocument *)aDocument
                     attributedString:(NSMutableAttributedString *)attributedString
{
    NSUInteger startPos = attributedString.length;
    for (MMElement *child in anElement.children)
    {
        NSString *plainText = nil;
        if (child.type == MMElementTypeNone)
        {
            NSString *markdown = aDocument.markdown;
            if (child.range.length == 0)
            {
                plainText = @"\n";
            }
            else
            {
                plainText = [markdown substringWithRange:child.range];
            }
        }
        else if (child.type == MMElementTypeHTML)
        {
            // FIXME parse or strip HTML tags
            plainText = [aDocument.markdown substringWithRange:child.range];
        }
        else if (child.type == MMElementTypeLineBreak) {
            plainText = @"\n";
        }
        else
        {
            [self _generateAttributesForElement:child
                                     inDocument:aDocument
                               attributedString:attributedString];
        }
        if (plainText) {
            NSDictionary *attributes = @{};
            [attributedString appendAttributedString:[[NSAttributedString alloc] initWithString:plainText attributes: attributes]];
        }
    }
    NSDictionary *attributes = [self attributesForElement:anElement];
    NSUInteger length = attributedString.length - startPos;
    if (attributes && length > 0) {
        [attributedString addAttributes: attributes range: NSMakeRange(startPos, length)];
    }
}

-(NSDictionary *) attributesForElement:(MMElement *)anElement
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    switch (anElement.type)
    {
        case MMElementTypeHeader:
            attributes[NSFontAttributeName] = [self.baseFont fontWithSize: self.baseFont.pointSize * (1 + anElement.level / 10)];
            break;
//        case MMElementTypeBlockquote:
//            return @"<blockquote>\n";
//        case MMElementTypeCodeBlock:
//            return anElement.language ? [NSString stringWithFormat:@"<pre><code class=\"%@\">", anElement.language] : @"<pre><code>";
        case MMElementTypeStrikethrough:
            attributes[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInt:1];
            break;
        case MMElementTypeStrong:
            attributes[NSFontAttributeName] =  self.boldFont;
            break;
        case MMElementTypeEm:
            attributes[NSFontAttributeName] =  self.italicFont;
            break;
//        case MMElementTypeCodeSpan:
//            return @"<code>";
            //        case MMElementTypeParagraph:
            //            return self.baseFont;

        default:
//            attributes[NSParagraphStyleAttributeName] = [NSParagraphStyle defaultParagraphStyle];
            break;
    }
    return attributes;
}

@end
