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


+(NSDictionary *)dictionary:(NSData *)data {
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *values=[dict objectForKey:@"def"];
    
    
    NSString *transcription=[NSString new];
    NSString *originalText=[NSString new];
    NSMutableDictionary *posDic=[NSMutableDictionary new];
    NSMutableArray *posArr=[NSMutableArray new];
    
    for(int i=0;i<values.count;i++){
        NSString *pos;
        if([values[i] objectForKey:@"pos"])
            pos=[[NSString alloc] initWithString:[values[i] objectForKey:@"pos"]];
        if([values[i] objectForKey:@"ts"])
            transcription=[values[i] objectForKey:@"ts"];
        
        if([values[i] objectForKey:@"text"])
            originalText=[values[i] objectForKey:@"text"];
        
        NSArray *tr=[NSArray new];
        if([values[i] objectForKey:@"tr"])
            tr=[values[i] objectForKey:@"tr"];
        
        
        NSMutableArray *difPos=[NSMutableArray new];
        
        for(int j=0;j<tr.count;j++){
            NSString *transText;
            if([tr[j] objectForKey:@"text"])
                transText=[[NSString alloc] initWithString:[tr[j] objectForKey:@"text"]];
            
            NSMutableArray *transSynonims;
            if([tr[j] objectForKey:@"syn"]){
                transSynonims=[NSMutableArray new];
                NSArray *synonimsStructure=[tr[j] objectForKey:@"syn"];
                for(int k=0;k<synonimsStructure.count;k++){
                    [transSynonims addObject:[synonimsStructure[k] objectForKey:@"text"]];
                }
            }
            
            NSMutableArray *meanings;
            if([tr[j] objectForKey:@"mean"]){
                meanings=[NSMutableArray new];
                NSArray *meaningsStructure=[tr[j] objectForKey:@"mean"];
                for(int k=0;k<meaningsStructure.count;k++){
                    [meanings addObject:[meaningsStructure[k] objectForKey:@"text"]];
                }
            }
            NSMutableArray *examples;
            NSMutableArray *transExamples;
            if([tr[j] objectForKey:@"ex"]) {
                examples=[NSMutableArray new];
                transExamples=[NSMutableArray new];
                NSArray *examplesStructure=[tr[j] objectForKey:@"ex"];
                for(int k=0;k<examplesStructure.count;k++){
                    [examples addObject:[examplesStructure[k] objectForKey:@"text"]];
                    [transExamples addObject:[[examplesStructure[k] objectForKey:@"tr"][0] objectForKey:@"text"]];
                }
            }
            
            
            
            NSMutableDictionary *caseDic=[NSMutableDictionary new];
            if(transText)
                [caseDic setObject:transText forKey:@"tText"];
            if(transSynonims)
                [caseDic setObject:transSynonims forKey:@"tSynonims"];
            if(meanings)
                [caseDic setObject:meanings forKey:@"meanings"];
            if(examples)
                [caseDic setObject:examples forKey:@"examples"];
            if(transExamples)
                [caseDic setObject:transExamples forKey:@"tExamples"];
            
            [difPos addObject:caseDic];
            
        }
        
        if (pos) {
            [posDic setObject:difPos forKey:pos];
            [posArr addObject:pos];
        }
        
        
    }
    
    NSMutableDictionary *returnDict=[NSMutableDictionary new];
    [returnDict setObject:posArr forKey:@"posArr"];
    [returnDict setObject:posDic forKey:@"posDic"];
    [returnDict setObject:originalText forKey:@"text"];
    [returnDict setObject:transcription forKey:@"transcription"];
    
    return returnDict;
}

@end
