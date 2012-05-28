//
// Created by igofed on 29.05.12.
//
// To change the template use AppCode | Preferences | File Templates.
//


@protocol SolverDelegate <NSObject>

-(void)solverDidProgressWithPercent:(float)percent;
-(void)solverDidFinishCalculateWithUp:(NSDecimalNumber *)up down:(NSDecimalNumber *)down;

@end