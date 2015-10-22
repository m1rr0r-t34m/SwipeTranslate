//
//  Parser.m
//  googleTranslateWidget
//
//  Created by Mark Vasiv on 22/10/15.
//  Copyright © 2015 Mark Vasiv. All rights reserved.
//

#import "Parser.h"

@implementation Parser
+(NSString *)Text:(NSData *)data {
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSNumber *code=[dict valueForKey:@"code"];
    NSString *text=[[dict valueForKey:@"text"]objectAtIndex:0];
    
    switch ([code intValue]) {
        case 200:
            NSLog(@"Operation completed successfully.");
            return text;
            break;
        case 401:
            NSLog(@"Invalid API key.");
            return nil;
            break;
        case 402:
            NSLog(@"This API key has been blocked.");
            return nil;
            break;
        case 403:
            NSLog(@"You have reached the daily limit for requests (including calls of the translate method).");
            return nil;
            break;
        case 404:
            NSLog(@"You have reached the daily limit for the volume of translated text (including calls of the translate method).");
            return nil;
            break;
        default:
            return nil;
            break;
    }
    
    return @"cool";
}
+(NSString *)AutoLanguage:(NSData *)data{

    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    NSNumber *code=[dict valueForKey:@"code"];
    NSString *detected=[[dict valueForKey:@"detected"] valueForKey:@"lang"];
    
    switch ([code intValue]) {
        case 200:
            NSLog(@"Operation completed successfully.");
            return detected;
            break;
        case 401:
            NSLog(@"Invalid API key.");
            return nil;
            break;
        case 402:
            NSLog(@"This API key has been blocked.");
            return nil;
            break;
        case 403:
            NSLog(@"You have reached the daily limit for requests (including calls of the translate method).");
            return nil;
            break;
        case 404:
            NSLog(@"You have reached the daily limit for the volume of translated text (including calls of the translate method).");
            return nil;
            break;
        default:
            return nil;
            break;
    }
    
}
@end
