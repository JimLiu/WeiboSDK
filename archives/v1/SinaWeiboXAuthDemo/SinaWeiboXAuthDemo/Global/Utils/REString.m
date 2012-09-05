//
//  REString.m
//
//  Created by Jerome Paschoud on 18.11.06.
//  Based on the code of David Teare 
//  http://tearesolutions.com/2006/09/how_to_use_regular_expressions_1.html
//  Updated on 16.05.07.
//	Source available at http://www.spikesoft.ch
//  Copyright 2006-2007 SpikeSoft. All rights reserved.
//
//  This program is free software: you can redistribute it and/or modify
//  it under the terms of the GNU General Public License as published by
//  the Free Software Foundation, either version 3 of the License, or
//  (at your option) any later version.
//
//  This program is distributed in the hope that it will be useful,
//  but WITHOUT ANY WARRANTY; without even the implied warranty of
//  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
//  GNU General Public License for more details.
//
//  You should have received a copy of the GNU General Public License
//  along with this program.  If not, see <http://www.gnu.org/licenses/>.
//

#import <regex.h>
#import <string.h>
#import "REString.h"
//#define DEBUG

@implementation NSString(AWSRegex)

- (BOOL)matches:(NSString *) regex withSubstring:(NSMutableArray *) substring{
	BOOL result = NO;
    regex_t re;
    int ret;
    const char *str = [self UTF8String];
    char buf[strlen([self UTF8String]) + 1];
    if ((ret =regcomp(&re, [regex UTF8String], REG_EXTENDED)) == 0) {
		size_t nmatch = re.re_nsub +1;
		regmatch_t pmatch[nmatch];
		if (0 == regexec(&re, [self UTF8String], nmatch, pmatch, 0)) {
			result = YES;
			if (substring  != nil){
				int i = 1;
				for (i; i < nmatch; i++){
					if (pmatch[i].rm_so == pmatch[i].rm_eo & pmatch[i].rm_so == -1) {
						// there is no matching charaters for this partial expression
						[substring addObject:@""];
					}
					else {
						// return the found expressions
                        int len = pmatch[i].rm_eo - pmatch[i].rm_so;
                        buf[len] = 0;
                        strncpy(buf, &str[pmatch[i].rm_so], len);
                        [substring addObject:[NSString stringWithUTF8String:buf]];
					}
				}
			}
		}
    }
    else {
        char errbuf[100];
        regerror(ret, &re,errbuf,sizeof errbuf);
        NSLog(@"regcomp: %s",errbuf);
    }
    regfree(&re);
    return result;
}
  
@end
