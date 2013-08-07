//
//  NULDBDB+SizeEstimation.m
//  NULevelDB
//
//  Created by Brent Gulanowski on 11-11-04.
//  Copyright (c) 2011 Nulayer Inc. All rights reserved.
//

#import "NULDBDB_private.h"


@implementation NULDBDB (SizeEstimation)

- (NSUInteger)currentFileSizeEstimate {
    
    NSUInteger total = 0;
    
    NSFileManager *fm = [NSFileManager defaultManager];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"self ENDSWITH 'sst'"];
    NSArray *storageFiles = [[fm contentsOfDirectoryAtPath:self.location error:NULL] filteredArrayUsingPredicate:predicate];
    
    for(NSString *file in storageFiles)
        total += [[fm attributesOfItemAtPath:[self.location stringByAppendingPathComponent:file] error:NULL] fileSize];
    
    return total;
}

- (NSUInteger)sizeForKeyRangeFrom:(NSString *)start to:(NSString *)limit {
    
    NSUInteger total = 0;
    
    Range range(NULDBSliceFromString(start), NULDBSliceFromString(limit));
    Iterator*iter = db->NewIterator(readOptions);
    
    iter->Seek(range.start);
    if(!iter->Valid()) iter->Next();
    
    uint64_t size;
    
    while(iter->Valid() && BytewiseComparator()->Compare(iter->key(), range.limit) <= 0) {
        range.limit = iter->key();
        if(range.start.ToString().length() > 0) {
            size = 0;
            db->GetApproximateSizes(&range, 1, &size);
            total += size;
        }
        range.start = range.limit;
        iter->Next();
    }
    
    delete iter;
    
    return total;
}

- (NSUInteger)currentSizeEstimate {
    
    NSUInteger total = 0;
    
    Iterator*iter = db->NewIterator(readOptions);
    
    iter->SeekToFirst();
    
    if(!iter->Valid()) return 0;
    
    // The range.start is set to an empty slice; isn't used
    std::string *s1 = NULL;
    std::string *s2 = new std::string(iter->key().ToString());
    Range range = Range(Slice(), Slice(*s2));
    uint64_t size;
    
    while(iter->Next(), iter->Valid()) {
        
        s1 = s2;
        s2 = new std::string(iter->key().ToString());
        
        if(s1->length() > 0) {
            range = Range(Slice(*s1), Slice(*s2));
            size = 0;
            db->GetApproximateSizes(&range, 1, &size);
            total += size;
        }
        
        delete s1;
    }
    
    delete s2;
    delete iter;
    
    return total;
}

- (NSUInteger)sizeUsedByKey:(NSString *)key {
    
    NSUInteger result = 0;
    Range range;
    
    Iterator*iter = db->NewIterator(readOptions);
    Slice k = NULDBSliceFromString(key);
    
    range.start = k;
    
    iter->Seek(k);
    iter->Next();
    
    if(iter->Valid()) {
        
        uint64_t size;
        
        range.limit = iter->key();
        db->GetApproximateSizes(&range, 1, &size);
        result = size;
    }
    
    delete iter;
    
    return result;
}

@end
