//
//  REString.h
//
//  Created by Jerome Paschoud on 18.11.06.
//  Based on the code of David Teare 
//  http://tearesolutions.com/2006/09/how_to_use_regular_expressions_1.html
//  Updated on 16.05.07.
//	Source available at http://www.spikesoft.ch
//
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

#import <Foundation/Foundation.h>


@interface NSString(AWSRegex) 
/* This method return the list of all the matching characters (only the one delimited
 * by bracketed sub-expression) in a mutable array.
 * 
 * If an expression is composed of several enclosed sub-expression then the order
 * of the matching sub-string is given from the outermost expression to the innemost
 * and at the same level always from left to right.
 *
 * The escape char for the regex parameter is "\\"
 *
 * Example: regex = "((M)?[0-9]{2})" self = "M12" => substring[0] = 12 , substring[1]=M
 */
- (BOOL)matches:(NSString *) regex withSubstring:(NSMutableArray *) substring;

@end
