//
//  extract_num.c
//  display_number_onto_hex_segments
//
//  Created by KAMATH Manukiran on 11/04/2017.
//  Copyright © 2017 KAMATH Manukiran. All rights reserved.
//

#include <stdio.h>
#include <math.h>

int extract_digit0 (unsigned int num_to_be_extracted){
    
    return (num_to_be_extracted % 10);
    
}

int extract_digit1 (unsigned int num_to_be_extracted){
    
    return ((num_to_be_extracted/10) % 100);
    
}

int extract_digit2 (unsigned int num_to_be_extracted){
    
    return ((num_to_be_extracted/100) % 100);
    
}
