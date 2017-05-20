//
//  NSObject+DictionaryRep.m
//  FIR
//
//  Created by Vijay on 20/05/17.
//  Copyright © 2017 Vijay. All rights reserved.
//

#import "NSObject+DictionaryRep.h"
#import <objc/runtime.h>

@implementation NSObject (DictionaryRep)

- (NSDictionary *)dictionaryRepresentation {
    unsigned int count = 0;
    // Get a list of all properties in the class.
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    NSMutableDictionary *dictionary = [[NSMutableDictionary alloc] initWithCapacity:count];
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        NSString *value = [self valueForKey:key];
        
        // Only add to the NSDictionary if it's not nil.
        if (value)
            [dictionary setObject:value forKey:key];
    }
    
    free(properties);
    
    return dictionary;
}

@end
