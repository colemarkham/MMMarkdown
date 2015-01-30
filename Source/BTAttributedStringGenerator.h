//
//  BTAttributedStringGenerator.h
//  Literary Criticism
//
//  Created by Cole Markham on 1/30/15.
//  Copyright (c) 2015 Best of Texas Contest and Apps. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMarkdown.h"
#import "MMDocument.h"

@interface BTAttributedStringGenerator : NSObject
+ (void) applyAttributedText:(NSString *) markdown toLabel: (UILabel *) label;

@property (weak, nonatomic) UIFont *baseFont;
@property (weak, nonatomic) UIFont *boldFont;
@property (weak, nonatomic) UIFont *italicFont;
- (NSAttributedString *)generateAttributedString:(MMDocument *)aDocument;
@end
