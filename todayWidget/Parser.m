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


+(NSDictionary *)Dictionary:(NSData *)data {
    NSDictionary *dict=[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:nil];
    
    NSArray *values=[dict objectForKey:@"def"];
    NSNumber *code=[dict valueForKey:@"code"];
    
    switch ([code intValue]) {
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
        default:
            break;
    }
    
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
+(NSAttributedString *)outputStringForMainAppDictionary:(NSDictionary *)receivedData {

    NSMutableAttributedString *outputText=[NSMutableAttributedString new];
    NSMutableAttributedString *newLineString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    
    //Font attributes base
    NSFont *translatedWordFont = [NSFont boldSystemFontOfSize:18.0];
    NSDictionary *translatedWordAttributes = @{NSFontAttributeName : translatedWordFont};
    
    NSFont *translatedSynonimsFont = [NSFont systemFontOfSize:17.0];
    NSDictionary *translatedSynonimsAttributes = @{NSFontAttributeName : translatedSynonimsFont};
    
    NSFont *speechPartFont = [NSFont systemFontOfSize:15.5];
    NSDictionary *speechPartAttributes = @{NSFontAttributeName : speechPartFont};
    
    NSColor *lightColor = [NSColor grayColor];
    NSFont *transcriptionFont = [NSFont systemFontOfSize:24.0];
    NSDictionary *transcriptionAttributes = @{NSFontAttributeName : transcriptionFont, NSForegroundColorAttributeName : lightColor};
    
    NSFont *meaningsFont = [NSFont systemFontOfSize:16.0 weight:NSFontWeightLight];
    NSDictionary *meaningsAttributes = @{NSFontAttributeName : meaningsFont};
    
    NSFont *examplesFont = [NSFont systemFontOfSize:14.0 weight:NSFontWeightLight];
    NSDictionary *examplesAttribtes = @{NSFontAttributeName : examplesFont};
    
    //Creating layout for a dictionary response
    NSString *transcription=[receivedData objectForKey:@"transcription"];
    if ([transcription length]){
        [outputText appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"[%@]\n",transcription] attributes:transcriptionAttributes]];
        [outputText appendAttributedString:newLineString];
    }
    
    NSArray *posArray=[receivedData objectForKey:@"posArr"];
    for(int i=0;i<[posArray count];i++) {
        
        NSMutableAttributedString *posString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@:", posArray [i]] attributes:speechPartAttributes];
        
        [outputText appendAttributedString:posString];
        [outputText appendAttributedString:newLineString];
        
        NSArray *allMeanings=[[receivedData objectForKey:@"posDic"] objectForKey:posArray[i]];
        for(int j=0;j<[allMeanings count];j++) {
            NSArray *synonims = [allMeanings[j] objectForKey:@"tSynonims"];
            NSString *translation = [[NSString alloc] initWithString:[allMeanings[j] objectForKey:@"tText"]];
            [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",translation] attributes:translatedWordAttributes]];
            
            if (![synonims count])
                [outputText appendAttributedString:newLineString];
            
            else {
                for(int k=0;k<[synonims count];k++) {
                    [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@",synonims[k]]attributes:translatedSynonimsAttributes]];
                }
                [outputText appendAttributedString:newLineString];
            }
            
            NSArray *meanings = [allMeanings[j] objectForKey:@"meanings"];
            if([meanings count]) {
                for(int k=0;k<[meanings count];k++) {
                    if (k != [meanings count] - 1)
                        [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@, ",meanings[k]]attributes:meaningsAttributes]];
                    else
                        [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@ ",meanings[k]]attributes:meaningsAttributes]];
                }
                
                [outputText appendAttributedString:newLineString];
                [outputText appendAttributedString:newLineString];
            }
            
            
            NSArray *examples = [allMeanings[j] objectForKey:@"examples"];
            NSArray *translatedExamples = [allMeanings[j] objectForKey:@"tExamples"];
            if([examples count]) {
                for(int k=0;k<[examples count];k++) {
                    
                    [outputText appendAttributedString: [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@  %C  %@ \n",examples[k], 0x2014, translatedExamples[k]]attributes:examplesAttribtes]];
                    
                }
                [outputText appendAttributedString:newLineString];
            }
            
            [outputText appendAttributedString:newLineString];
        }
    }
    

    return outputText;
}
+(NSAttributedString *)outputStringForWidgetAppDictionary:(NSDictionary *)receivedData {
   
    NSMutableAttributedString *outputText=[NSMutableAttributedString new];
    NSMutableAttributedString *newLineString = [[NSMutableAttributedString alloc] initWithString:@"\n"];
    
    //Font attributes base
    NSColor *whiteColor = [NSColor whiteColor];
    NSFont *mainFont = [NSFont systemFontOfSize:12.0];
    NSDictionary *mainAttributes = @{NSFontAttributeName : mainFont, NSForegroundColorAttributeName : whiteColor};
    NSFont *firstTranslationFont = [NSFont systemFontOfSize:16.0];
    NSDictionary *firstTranslationAttributes = @{NSFontAttributeName : firstTranslationFont, NSForegroundColorAttributeName : whiteColor};
    
    //Creating layout for a dictionary response
    NSString *transcription=[receivedData objectForKey:@"transcription"];
    if ([transcription length]){
        [outputText appendAttributedString: [[NSAttributedString alloc] initWithString: [NSString stringWithFormat: @"[%@]",transcription] attributes:mainAttributes]];
        [outputText appendAttributedString:newLineString];
    }
    
    NSArray *posArray=[receivedData objectForKey:@"posArr"];
    NSArray *allMeanings=[[receivedData objectForKey:@"posDic"] objectForKey:posArray[0]];
        for(int j=0;j<[allMeanings count];j++) {
            NSString *translation = [[NSString alloc] initWithString:[allMeanings[j] objectForKey:@"tText"]];
            if (j == 0)
                [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@",translation] attributes:firstTranslationAttributes]];
            else
                [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@",translation] attributes:mainAttributes]];
            NSArray *synonims = [allMeanings[j] objectForKey:@"tSynonims"];
            
                    for(int k=0;k<[synonims count];k++) {
                        [outputText appendAttributedString:[[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@", %@",synonims[k]]attributes:mainAttributes]];
            }
        }
    
    return outputText;

}

+(NSAttributedString *)parsedResult:(NSDictionary *)receivedData {
    if([receivedData objectForKey:@"text"] && [receivedData objectForKey:@"text"][0]) {
        NSDictionary *translateResponseFontAttributes = @{NSFontAttributeName : [NSFont systemFontOfSize:16.0]};
        return [[NSAttributedString alloc] initWithString:[receivedData objectForKey:@"text"][0] attributes:translateResponseFontAttributes];
    }
    else {
        //TODO: Somehow handle mainApp/widget detection/switch
        return [Parser outputStringForMainAppDictionary:receivedData];
    }
}
@end
