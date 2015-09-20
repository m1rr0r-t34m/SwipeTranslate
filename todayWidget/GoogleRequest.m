//
//  GoogleRequest.m
//  
//
//  Created by Mark Vasiv on 27/08/15.
//
//

#import "GoogleRequest.h"

@implementation GoogleRequest


- (instancetype)init
{
  self = [super init];
  if (self) {
    NSArray *keys = @[@"Auto",@"Afrikaans", @"Albanian", @"Arabic", @"Armenian", @"Azerbaijani",
                      @"Basque", @"Belarusian", @"Bengali", @"Bosnian", @"Bulgarian",
                      @"Catalan", @"Cebuano", @"Chichewa", @"Chinese Simplified", @"Chinese Traditional",
                      @"Croatian", @"Czech", @"Danish", @"Dutch", @"English",
                      @"Esperanto", @"Estonian", @"Filipino", @"Finnish", @"French", @"Galician",
                      @"Georgian", @"German", @"Greek", @"Gujarati", @"Haitian Creole",
                      @"Hausa", @"Hebrew", @"Hindi", @"Hmong", @"Hungarian",
                      @"Icelandic", @"Igbo", @"Indonesian", @"Irish", @"Italian",
                      @"Japanese", @"Javanese", @"Kannada", @"Kazakh", @"Khmer",
                      @"Korean", @"Lao", @"Latin", @"Latvian", @"Lithuanian",
                      @"Macedonian", @"Malagasy", @"Malay", @"Malayalam", @"Maltese",
                      @"Maori", @"Marathi", @"Mongolian", @"Myanmar", @"Nepale",
                      @"Norwegian", @"Persian", @"Polish", @"Portuguese", @"Punjabi", @"Romanian",
                      @"Russian", @"Serbian", @"Sesotho", @"Sinhala", @"Slovak",
                      @"Slovenian", @"Somali", @"Spanish", @"Sudanese", @"Swahili",
                      @"Swedish", @"Tajik", @"Tamil", @"Telugu", @"Thai", @"Turkish",
                      @"Ukrainian", @"Urdu", @"Uzbek", @"Vietnamese", @"Welsh",
                      @"Yiddish", @"Yoruba", @"Zulu"	];

    NSArray *values = @[@"auto",@"af", @"sq", @"ar", @"hy", @"az", @"eu", @"be", @"bn", @"bs", @"bg",
                        @"ca", @"ceb", @"ny", @"zh-CN", @"zh-TW", @"hr", @"cs",
                        @"da", @"nl", @"en", @"eo", @"et", @"tl", @"fi", @"fr",
                        @"gl", @"ka", @"de",@"el", @"gu",
                        @"ht", @"ha", @"iw",@"hi", @"hmn",@"hu", @"is",
                        @"ig", @"id", @"ga", @"it", @"ja", @"jw", @"kn", @"kk", @"km", @"ko", @"lo",
                        @"la", @"lv", @"lt", @"mk", @"mg", @"ms", @"ml", @"mt", @"mi", @"mr", @"mn",
                        @"my", @"ne", @"no", @"fa", @"pl", @"pt", @"ma", @"ro", @"ru",
                        @"sr", @"st", @"si", @"sk", @"sl", @"so", @"es", @"su", @"sw",
                        @"sv", @"tg", @"ta", @"te", @"th", @"tr", @"uk", @"ur", @"uz",
                        @"vi", @"cy", @"yi", @"yo", @"zu"];
    _languagesMap=[NSDictionary dictionaryWithObjects:values forKeys:keys];
  }
  return self;
}

-(void)sendRequestWithSourceLanguage:(NSString *)sLang TargetLanguage:(NSString *)tLang Text:(NSString *)inputText Sender:(id)sender {
    [self getDataFromUrlWithSourceLanguage:[_languagesMap valueForKey:sLang] TargetLanguage:[_languagesMap valueForKey:tLang] Text:inputText WithDelegate:sender];
}
- (void)getDataFromUrlWithSourceLanguage:(NSString *)SLanguage TargetLanguage:(NSString *)TLanguage Text:(NSString *)inputText WithDelegate:(NSObject<asynchronousRequests> *)delegate {

    //encode input
    NSString *escapedInput = [inputText stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLHostAllowedCharacterSet]];
    
    //prepare url
    NSString *urlString=[NSString stringWithFormat:@"https://translate.googleapis.com/translate_a/single?client=gtx&ie=UTF-8&oe=UTF-8&sl=%@&tl=%@&dt=t&q=%@", SLanguage, TLanguage, escapedInput];

    NSURL *url=[NSURL URLWithString:urlString];
    
    //prepare request
    NSURLRequest *request=[NSURLRequest requestWithURL:url];
    
    //make asynchronous request
    NSOperationQueue *queue = [[NSOperationQueue alloc] init];
    [NSURLConnection sendAsynchronousRequest:request queue:queue completionHandler:^(NSURLResponse *response, NSData *receivedData, NSError *error) {
        if (error)
        {
            //newWord=[NSString stringWithFormat:@"%@",error];
            
        }
        else
        {
            [delegate receivedResponseFromRequest:receivedData];
            
        }
    }];
    
}

@end


