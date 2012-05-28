//
//  Solver.m
//  DistributedComputing
//
//  Created by Tatiana Petrova on 28.05.12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Solver.h"
#import "SolverDelegate.h"

@implementation Solver

@synthesize delegate = _delegate;

- (void)calculateFrom:(NSNumber *)from to:(NSNumber *)to
{
    dispatch_queue_t backgroundQueue = dispatch_queue_create("compute", NULL);
    
    dispatch_async(backgroundQueue, ^(void) {
        int iFrom = [from intValue];
        int iTo = [to intValue];
        int total = iTo - iFrom;

        NSDecimalNumber *up = [NSDecimalNumber one];
        NSDecimalNumber *down = [NSDecimalNumber one];

        for(int n = iFrom; n <= iTo; n++)
        {
            //(2n)^2
            NSDecimalNumber *curUp = [NSDecimalNumber decimalNumberWithString:@"2"];
            curUp = [curUp decimalNumberByMultiplyingBy: [NSDecimalNumber decimalNumberWithString: [[NSNumber numberWithInt:n] stringValue]]];
            curUp = [curUp decimalNumberByRaisingToPower:2];

            //2n-1
            NSDecimalNumber *curDownLeft = [NSDecimalNumber decimalNumberWithString:@"2"];
            curDownLeft = [curDownLeft decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString: [[NSNumber numberWithInt:n] stringValue]]];
            curDownLeft = [curDownLeft decimalNumberBySubtracting:[NSDecimalNumber one]];

            //2n+1
            NSDecimalNumber *curDownRight = [NSDecimalNumber decimalNumberWithString:@"2"];
            curDownRight = [curDownRight decimalNumberByMultiplyingBy:[NSDecimalNumber decimalNumberWithString: [[NSNumber numberWithInt:n] stringValue]]];
            curDownRight = [curDownRight decimalNumberByAdding: [NSDecimalNumber one]];

            //(2n-1)(2n+1)
            NSDecimalNumber *curDown = [curDownLeft decimalNumberByMultiplyingBy:curDownRight];

            //result
            up = [up decimalNumberByMultiplyingBy:curUp];
            down = [down decimalNumberByMultiplyingBy:curDown];

            [self.delegate solverDidProgressWithPercent:((float)n) / total];
        }

        [self.delegate solverDidFinishCalculateWithUp:up down:down];
    });    
    
    dispatch_release(backgroundQueue);
}

@end
