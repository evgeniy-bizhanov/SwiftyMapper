//
//  ObjectFactory.h
//  SwiftyMapper
//
//  Created by Евгений Бижанов on 27.02.2018.
//

@interface Factory: NSObject
+ (NSObject *)getInstance:(NSString *) of;
+ (NSObject *)getClassInstance:(Class) of;
@end
