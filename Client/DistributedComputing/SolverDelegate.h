//
// Created by igofed on 30.05.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol SolverDelegate
- (void)solverDidProgressWithPercent:(NSNumber*)percent;
- (void)solverDidFinishWithUp:(NSDecimalNumber *)up down:(NSDecimalNumber *)down;
@end