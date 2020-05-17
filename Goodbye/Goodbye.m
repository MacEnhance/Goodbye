//
//  Goodbye.m
//  Goodbye
//
//  Created by Wolfgang Baird on 4/14/20.
//  Copyright © 2020 Wolfgang Baird. All rights reserved.
//

#import "ZKSwizzle.h"
#import <Cocoa/Cocoa.h>
#import <Foundation/Foundation.h>

@interface Goodbye : NSObject
@end

@interface ME_Goodbye_Whitelisted_NSApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@interface ME_Goodbye_NSApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@implementation ME_Goodbye_NSApplicationDelegate
- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    NSArray *windows = [NSApp NSWindowControllers];
    NSMutableString *windowClasses = [NSMutableString stringWithString:@""];
    for (NSWindow *aWindow in windows) {
        [windowClasses appendString:(NSStringFromClass([aWindow class]))];
    }
    [self performSelector:@selector(closeIfRightConditions:) withObject:windowClasses afterDelay:0.1 ];
    
    return false;
    
}

- (void)closeIfRightConditions:(NSMutableString*)prevWindowClasses {
    NSArray *windows = [NSApp NSWindowControllers];
    NSMutableString *windowClasses = [NSMutableString stringWithString:@""];
    for (NSWindow *aWindow in windows) {
        [windowClasses appendString:(NSStringFromClass([aWindow class]))];
    }
    NSLog(@"%@",windowClasses);
    NSLog(@"%@",prevWindowClasses);
    if ([windowClasses isEqualToString:prevWindowClasses] || [windows count] == 0) {
        [NSApp terminate:self];
    }
}

@end

@implementation Goodbye
+ (void)load {
    
    NSArray *globalBlacklist = [NSArray arrayWithContentsOfFile:[[NSBundle bundleForClass:[self class]] pathForResource:@"globalBlacklist" ofType:@"plist"]];
    
    if (![globalBlacklist containsObject: [[NSBundle mainBundle] bundleIdentifier]] && ![NSUserDefaults.standardUserDefaults boolForKey:@"GoodbyeBlacklist"] && ![[NSBundle mainBundle] objectForInfoDictionaryKey:@"LSUIElement"]) {
        _ZKSwizzle(ME_Goodbye_NSApplicationDelegate.class, NSApp.delegate.class);
    }
}
@end
