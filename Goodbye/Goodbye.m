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

@interface ME_Goodbye_NSApplicationDelegate : NSObject <NSApplicationDelegate>
@end

@implementation ME_Goodbye_NSApplicationDelegate

- (BOOL)applicationShouldTerminateAfterLastWindowClosed:(NSApplication *)sender {
    
    BOOL origReturn = false;
    @try {
        origReturn = ZKOrig(BOOL);
    }
    @catch (NSException *e ) {
    }
    
    if (origReturn == true) {
        return true;
    }

    NSArray *windows = [NSApp windows];
    [self performSelector:@selector(closeIfRightConditions:) withObject:windows afterDelay:0.5 ];
    
    return false;

}

- (void)closeIfRightConditions:(NSMutableArray*)prevWindows {
    NSArray *windows = [NSApp windows];
    if ([windows isEqualToArray:prevWindows] || [prevWindows count] > [windows count]) {
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
