//
//  Solver.h
//  DistributedComputing
//
//  Created by Tatiana Petrova on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Solver : NSObject
- (void)calculateFrom:(NSNumber *)from to:(NSNumber *)to up:(NSNumber **)up down:(NSNumber **)down;
@end
