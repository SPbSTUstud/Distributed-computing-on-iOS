//
//  Solver.h
//  DistributedComputing
//
//  Created by Igor Fedchun on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol SolverDelegate;


@interface Solver : NSObject

@property (nonatomic) id<SolverDelegate> delegate;

- (void)calculateFrom:(NSNumber *)from to:(NSNumber *)to;

@end
