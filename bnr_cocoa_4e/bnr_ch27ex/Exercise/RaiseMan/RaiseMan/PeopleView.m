//
//  PeopleView.m
//  RaiseMan
//
//  Created by Can on 2/2/15.
//  Copyright (c) 2015 Can. All rights reserved.
//

#import "PeopleView.h"
#import "Person.h"

@implementation PeopleView

- (id)initWithPeople:(NSArray *)persons {
    self = [super initWithFrame:NSMakeRect(0, 0, 700, 700)]; // dummy frame
    if (self) {
        self.people = [persons copy];
        self.attributes = [[NSMutableDictionary alloc] init];
        NSFont *font = [NSFont fontWithName:@"Monaco" size:12.0];
        self.lineHeight = [font capHeight] * 1.7;
        [self.attributes setObject:font forKey:NSFontAttributeName];
    }
    return self;
}

#pragma mark Pagination

- (BOOL)knowsPageRange:(NSRangePointer)range {
    NSPrintOperation *po = [NSPrintOperation currentOperation];
    NSPrintInfo *printInfo = [po printInfo];
    self.pageRect = [printInfo imageablePageBounds];
    NSRect newFrame;
    newFrame.origin = NSZeroPoint;
    newFrame.size = [printInfo paperSize];
    self.frame = newFrame;
    
    self.linesPerPage = self.pageRect.size.height / self.lineHeight - 1; // -1 for the line of page numbers
    
    range->location = 1;
    range->length = self.people.count / self.linesPerPage;
    if (self.people.count % self.linesPerPage) {
        range->length ++;
    }
    return YES;
}

- (NSRect)rectForPage:(NSInteger)page {
    self.currentPage = page - 1;
    return self.pageRect;
}

#pragma mark Drawing

- (BOOL)isFlipped {
    return YES;
}

- (void)drawRect:(NSRect)dirtyRect {
    [super drawRect:dirtyRect];
    
    NSRect nameRect;
    NSRect raiseRect;
    NSRect pageNumberRect;
    pageNumberRect.size.height = raiseRect.size.height = nameRect.size.height = self.lineHeight;
    nameRect.origin.x = self.pageRect.origin.x;
    nameRect.size.width = 200.0;
    raiseRect.origin.x = NSMaxX(nameRect);
    raiseRect.size.width = 100.0;
    for (NSInteger i = 0; i < self.linesPerPage; ++i) {
        NSInteger index = (self.currentPage * self.linesPerPage) + i;
        if (index >= self.people.count) {
            break;
        }
        Person *p = [self.people objectAtIndex:index];
        raiseRect.origin.y = nameRect.origin.y = self.pageRect.origin.y + (i * self.lineHeight);
        NSString *nameString = [NSString stringWithFormat:@"%2ld %@", (long)index, p.personName];
        [nameString drawInRect:nameRect withAttributes:self.attributes];
        NSString *raiseString = [NSString stringWithFormat:@"%4.1f%%", p.expectedRaise * 100];
        [raiseString drawInRect:raiseRect withAttributes:self.attributes];
    }
    
    NSString *pageNumberString = [NSString stringWithFormat:@"%ld", (long)self.currentPage + 1]; // currentPage starts from 0
    pageNumberRect.size.width = [pageNumberString sizeWithAttributes:self.attributes].width;
    pageNumberRect.origin.x = (self.pageRect.size.width - pageNumberRect.size.width ) / 2;
    pageNumberRect.origin.y = self.pageRect.origin.y + self.linesPerPage * self.lineHeight;
    [pageNumberString drawInRect:pageNumberRect withAttributes:self.attributes];
}

@end
