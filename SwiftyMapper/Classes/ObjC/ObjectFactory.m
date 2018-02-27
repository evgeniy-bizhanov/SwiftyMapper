//
//  ObjectFactory.m
//  SwiftyMapper
//
//  Created by Евгений Бижанов on 27.02.2018.
//

#import "ObjectFactory.h"

@implementation Factory
    + (NSObject *)getInstance:(NSString *) of {
        return [[NSClassFromString(of) alloc] init];
    }
    
    + (NSObject *)getClassInstance:(Class) of {
        NSString *name = NSStringFromClass(of);
        return [[NSClassFromString(name) alloc] init];
    }
@end
