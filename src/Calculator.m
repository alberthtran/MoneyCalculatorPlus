//
//  Calculator.m
//  pocketCalc
//
//  Created by Albert Tran on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Calculator.h"
#import "ConstantValues.h"
#import "UserDatabase.h"

static Calculator *instance = nil;

@implementation Calculator

//Implicity declaring the setters and getters for the properties
@synthesize tips_percentage,heads_count,each_tip,each_amount,total_tip,total_amount,tip_current_number,tip_decimal_number;

@synthesize orig_price,tax_percent,tax_amount,discount_rate,discount_amount,total_after_tax,saved_amount,coupon,gotCoupon, gotSaleTax,gotOrigPrice,gotDiscountRate,tax_current_number,tax_decimal_number;

@synthesize conversion_type,table_row,table_col,from_unit_type,to_unit_type,to_result_val;

@synthesize mathOp,running_total,unitConv_current_number,unitConv_decimal_number,mass_conversion_list,length_conversion_list,temperature_conversion_list, pressure_conversion_list,area_conversion_list,volumn_conversion_list,cooking_conversion_list;

const float massConverterTable[TOTAL_NUM_MASS_UNIT_CNT][TOTAL_NUM_MASS_UNIT_CNT] = {
    //mg        g           kg          oz              lb    
    {1.0,       0.001,      0.000001,    3.52734E-05,    0.00001},       //mg
    {1000,      1.0,        0.001,      0.0352733,      0.002204623},   //g
    {1000000,   1000,       1.0,        35.273368,      2.2046226},     //kg
    {28349.52316,     28.35,      0.02835,    1.0,            0.062501},      //oz
    {453592.37, 453.59237,  0.45359237, 15.99973,       1.0}            //lb
    
};

const float lengthConverterTable[TOTAL_NUM_LENGTH_UNIT_CNT][TOTAL_NUM_LENGTH_UNIT_CNT] = {
    //mm    cm      m          km    in          ft              yd             ml      nm  
    {1.0,	0.1,	0.001,  0.000001, 0.03937,	0.00328084,     0.001093613, 6.214E-7,5.39665E-7},     //mm
    {10,	1.0,	0.01,	0.00001, 0.3937,	0.032808399,    0.010936133, 6.2137E-06,	5.3996E-06},     //cm
    {1000,	100,	1.0,	0.001,   39.37007874, 3.280839895,  1.0936,     0.000621371, 0.000539957},//m
    {1000000, 100000, 1000,	1.0,	 39370.07874, 3280.839895,  1093.613298, 0.6214,	0.5399568},   //km
    {25.4,	2.54,	0.0254,	0.0000254, 1.0,     0.08333333,     0.02777777,	0.00001578,	1.37149E-05}, //in
    {304.8,	30.48,	0.3048,	0.0003048, 12,      1.0,            0.333333333, 0.00018939, 0.000164579},//ft
    {914.4,	91.44,	0.9144,	0.0009144, 36,      3,              1.0,        0.000568182, 0.000493737},//yd
    {1609344,160934.4, 1609.344,1.6093,	63360,	5280,           1760,       1.0,        0.868976242}, //ml
    {1852000, 185200, 1852,	1.852,	72913.38583, 6076.115486,	2025.3718,	1.150779448, 1.0}         //nm
};

const float pressureConverterTable[TOTAL_NUM_PRESSURE_UNIT_CNT][TOTAL_NUM_PRESSURE_UNIT_CNT] = {
    //Pa	kPa	psi	atm	kgf/cm^2	bar	mmHg	mmH20    
    {1,	0.001,	0.000145038,	0.000009869,	0.000010197,	0.00001,	0.007500638,	0.101971621},       //Pa
    {1000,	1,	0.14503774,	0.009869233,	0.010197162,	0.01,	7.500637554,	101.97},   //kPa
    {6894.744825,	6.894757185,	1,	0.068045963,	0.070306957,	0.068947572,	51.72,	703.07},     //psi
    {101325,	101.32,	14.7,	1,	1.033227453,	1.01325, 760,	10332.27},      //atm
    {98066.5,	98.07,	14.22,	0.967841105,	1,	0.980665,	735.56,	10000},            //kgf/cm^2
    {100000,	100,	14.5,	0.986923267,	1.019716213,	1,	750.06,	10197.16},     //bar
    {133.32,	0.133322,	0.019336722,	0.001315786,	0.001359506,	0.00133322,	1,	13.6},      //mmHg
    {9.80665,	0.00980665,	0.001422334,	0.000096784,	0.0001,	0.000098066,	0.073556127, 1}            //mmH20
    
};

const float areaConverterTable[TOTAL_NUM_AREA_UNIT_CNT][TOTAL_NUM_AREA_UNIT_CNT] = {
    //m^2	ft^2	yd^2	acre	a	ha    
    {1,	10.76,	1.195990046,	0.000247105,	0.01,	0.0001},       //m^2
    {0.09290304,	1,	0.111111111,	0.000022957,	0.00092903,	0.00000929},   //ft^2
    {0.83612736,	9,	1,	0.000206612,	0.008361274,	0.000083613},     //yd^2
    {4046.86,	43560,	4840,	1,	40.47,	0.404685642},      //acre
    {100,	1076.39,	119.6,	0.024710538,	1,	0.01},            //a
    {10000,	107639.1,	11959.9,	2.471053815,	100,	1} //ha
};

const float volumnConverterTable[TOTAL_NUM_VOLUMN_UNIT_CNT][TOTAL_NUM_VOLUMN_UNIT_CNT] = {
    //m^3	cm^3	galloon	bbl	ft^3	dl	ml	l	in^3	yd^3	cc    
    {1,	1000000,	264.17,	6.28981077,	35.31,	10000,	1000000,	1000,	61023.74,	1.307950619,	1000000},//m^3
    {0.000001,	1,	0.000264172,	0.00000629,	0.000035315,	0.01,	1,	0.001,	0.061023744,	0.000001308,1},//cm^3
    {0.003785412,	3785.41,	1,	0.023809524,	0.133680556,	37.85,	3785.41,	3.785411784,	231,0.004951132,3785.41}, //galloon	
    {0.158987295,	158987.29,	42,	1,	5.614583333,	1589.87,	158987.29,	158.99,	9702,	0.207947531,	158987.29},//bbl
    {0.028316847,	28316.85,	7.480519481,	0.178107607,	1,	283.17,	28316.85,	28.32,	1728,	0.037037037,	28316.85}, //ft^3/cm^2
    {0.0001,	100,	0.026417205,	0.000628981,	0.003531467,	1,	100,	0.1,	6.102374409,	0.000130795,	100},//dl
    {0.000001,	1,	0.000264172,	0.00000629,	0.000035315,	0.01,	1,	0.001,	0.061023744,	0.000001308,	1}, //ml
    {0.001,	1000,	0.264172052,	0.006289811,	0.035314667,	10,	1000,	1,	61.02,	0.001307951,	1000}, //l
    {0.000016387,	16.39,	0.004329004,	0.000103072,	0.000578704,	0.16387064,	16.39,	0.016387064,	1,	0.000021433,	16.39},//in^3
    {0.764554858,	764554.86,	201.97,	4.80890538,	27,	7645.55,	764554.86,	764.55,	46656,	1,	764554.86}, //yd^3
    {0.000001,	1,	0.000264172,	0.00000629,	0.000035315,	0.01,	1,	0.001,	0.061023744,	0.000001308,	1} //cc     
};

const float cookingConverterTable[TOTAL_NUM_COOKING_UNIT_CNT][TOTAL_NUM_COOKING_UNIT_CNT] = {
    //gallons	quarts	pints	fluid ounces	cups	table spoons	tea spoons	liters	mililiters   
    {1,	4,	8,	128,	16,	256,	768,	3.785411776,	3785.411792},       //gallons
    {0.25,	1,	2,	32,	4,	64,	192,	0.946352944, 946.352948},   //quarts
    {0.125,	0.5,	1,	16,	2,	32,	96,	0.473176472,	473.176474},     //pints
    {0.0078125,	0.03125,	0.0625,	1,	0.125,	2,	6,	0.02957353,	29.57352963},      //fluid ounces
    {0.0625,	0.25,	0.5,	8,	1,	16,	48,	0.236588236,	236.588237},            //cups
    {0.00390625,	0.015625,	0.03125,	0.5,	0.0625,	1,	3,	0.014786765,	14.78676481},     //table spoons
    {0.001302083,	0.005208333,	0.010416667,	0.166666667,	0.020833333,	0.333333333,	1,	0.004928922,	4.928921604},      //tea spoons
    {0.264172053,	1.056688212,	2.113376423,	33.81402277,	4.226752847,	67.62804555,	202.8841366,	1,	1000},            //liters
    {0.000264172,	0.001056688,	0.002113376,	0.033814023,	0.004226753,	0.067628045,	0.202884136,	0.0009999,	1} //mililiters
};


- (id) init {
    if ( self = [super init] )
    {
        [self initTaxParams];
        [self initTipParams];
        [self initUnitConvParams];
    }
    
    return self;
}

- (void)dealloc
{

    [self calcCleanup];
    
    [super dealloc];
}

// Create a singleton for calculator which other objects will use for computation
+ (Calculator*)calcInstance {
    // the instance of this class is stored here
	//static Calculator *instance = nil;
    @synchronized (instance)
    {    
        // check to see if an instance already exists
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
	return instance;
    
}

// Implement the computeNewVal method
- (void) computeTipsResult{

    // calculate data
    float new_total_amount = 0.0;
    float new_total_tip = 0.0;
    float new_each_amount = 0.0;
    float new_each_tip = 0.0;
    
    // retrieve user's information
    float current_total_amount = [tip_current_number floatValue];
    float tip = [tips_percentage floatValue] / 100.00;
    unsigned int heads_cnt = [heads_count intValue];
    
    new_total_amount = current_total_amount * (1.0+tip);
    new_each_amount = new_total_amount / heads_cnt;
    new_total_tip = current_total_amount * tip;
    new_each_tip = new_total_tip / heads_cnt;
 
    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    [total_amount setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:new_total_amount]]];

    [each_amount setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:new_each_amount]]];

    [total_tip setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:new_total_tip]]];
    
    [each_tip setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:new_each_tip]]];
        
}

- (void) initTipParams {   
    
    tips_percentage = [[NSMutableString alloc] init];   
    
    heads_count = [[NSMutableString alloc] init];   
    
    tip_current_number = [[NSMutableString alloc] init];   
    
    each_amount = [[NSMutableString alloc] init];     
    
    each_tip = [[NSMutableString alloc] init];   
    
    total_amount = [[NSMutableString alloc] init];   
    
    total_tip = [[NSMutableString alloc] init];    
    
    [self setDefaultTipVal];
    
}

- (void) setDefaultTipVal{ 
    [tips_percentage setString:@"0"];  
    [heads_count setString:@"1"];   
    [tip_current_number setString:@"0"];   
    [each_amount setString:@"0"];     
    [each_tip setString:@"0"]; 
    [total_amount setString:@"0"];  
    [total_tip setString:@"0"];  
    
    tip_decimal_number = NO;
    
}

- (void) calcCleanup {
    // release memory used by tip calculator
    [self tipCleanup];
    // release memory used by sale tax calculator
    [self taxCleanup];
    // release all memory used by unit converter
    [self unitConvCleanup];
    // release the calculator instance memory
    //[[Calculator calcInstance] release];
}

- (void) tipCleanup{
    [tips_percentage release];
    [heads_count release];
    
    [tip_current_number release];
    [each_amount release];
    [each_tip release];
    [total_amount release];
    [total_tip release];
    
}

- (enum SaleTaxCalcStatus) computeSaleTaxResult{
    // calculate data
    float totalAfterTax = 0.0;
    float origPrice = 0.0;
    float savedAmount = 0.0;
    float saleTaxPercent = 0;
    int discountRate = 0;
    float saleTaxAmount = 0.0;
    float discountAmount = 0.0;
    float couponAmount = 0.0;    
    
    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle: NSNumberFormatterCurrencyStyle];
    
    NSMutableString *tempValue = [[[NSMutableString alloc] init] autorelease];
    
    // retrieve user's information
    if (gotCoupon) {
        
        [tempValue setString:orig_price];
        
        // remove the dollar sign & comma using orig_price is using the currency format
        [tempValue replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        [tempValue replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempValue length])];
        
        origPrice = [tempValue floatValue];
        
        couponAmount = [tax_current_number floatValue];
        
        if (origPrice < couponAmount){
            [tax_current_number setString:@"0"];
            [coupon setString:@"0"];
            tax_decimal_number = NO;
            return INVALID_COUPON_AMOUNT;
        }
        
        [coupon setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:couponAmount]]];
        
    }
    else{
        [tempValue setString:coupon];
        
        // remove the dollar sign & comma using orig_price is using the currency format
        [tempValue replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        [tempValue replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempValue length])];        
        couponAmount = [tempValue floatValue];
    }
    
    if (gotOrigPrice) {    
        origPrice = [tax_current_number floatValue];
        
        [orig_price setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:origPrice]]];
    }
    else{
        [tempValue setString:orig_price];
        
        // remove the dollar sign & comma using orig_price is using the currency format
        [tempValue replaceCharactersInRange:NSMakeRange(0, 1) withString:@""];
        [tempValue replaceOccurrencesOfString:@"," withString:@"" options:NSCaseInsensitiveSearch range:NSMakeRange(0, [tempValue length])];        
        origPrice = [tempValue floatValue];
    }
    
    if (gotSaleTax) {
        saleTaxPercent = [tax_current_number floatValue];
        [tax_percent setString:tax_current_number];
    }
    else
        saleTaxPercent = [tax_percent intValue];
    

    if (gotDiscountRate){
        discountRate = [tax_current_number intValue];
        [discount_rate setString:tax_current_number];
    }
    else
        discountRate = [discount_rate intValue];
    
    discountAmount = origPrice * (discountRate / 100.00);
    
    savedAmount = discountAmount + couponAmount;
    
    totalAfterTax = (origPrice - savedAmount)*(1+(saleTaxPercent / 100.00));
    
    saleTaxAmount = (origPrice - savedAmount) * (saleTaxPercent / 100.00);
    
    [tax_amount setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:saleTaxAmount]]];
    
    [discount_amount setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:discountAmount]]];
    
    [total_after_tax setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:totalAfterTax]]];
    
    [saved_amount setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:savedAmount]]];
    
    return NO_SALE_TAX_ERRORS;
    
}

- (void) initTaxParams{
    
    tax_current_number = [[NSMutableString alloc] init];   
    
    orig_price = [[NSMutableString alloc] init];   

    tax_percent = [[NSMutableString alloc] init];   
    
    tax_amount = [[NSMutableString alloc] init];   

    discount_rate = [[NSMutableString alloc] init];   
    
    discount_amount = [[NSMutableString alloc] init];   

    total_after_tax = [[NSMutableString alloc] init];   
    
    saved_amount = [[NSMutableString alloc] init];   

    coupon = [[NSMutableString alloc] init];   
    
    [self setDefaultTaxVal];
    
}

- (void) setDefaultTaxVal{
    [tax_current_number setString:@"0"];
    
    [orig_price setString:@"0"];
 
    [tax_percent setString:@"0"];
      
    [tax_amount setString:@"0"];
      
    [discount_rate setString:@"0"];
       
    [discount_amount setString:@"0"];
       
    [total_after_tax setString:@"0"];
     
    [saved_amount setString:@"0"];
    
    [coupon setString:@"0"];
    
    tax_decimal_number = NO;
    
    gotSaleTax = NO;
    gotOrigPrice = YES;
    gotDiscountRate = NO;
    gotCoupon = NO;   
    
    // initialize the tax percent from default value if available
    UserDatabase *sharedUserInfo = [UserDatabase shared];
    //float sale_tax_percent = [[sharedUserInfo default_sale_tax] floatValue];
    float sale_tax_percent = [sharedUserInfo default_sale_tax];
    
    if (sale_tax_percent != 0){ 
        NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numFormatter setNumberStyle: NSNumberFormatterNoStyle ];
        [numFormatter setMinimumFractionDigits:0];
        [numFormatter setMaximumFractionDigits:4];
        
        [tax_percent setString:[numFormatter stringFromNumber:[NSNumber numberWithFloat:sale_tax_percent]]];

        if (DEBUG_MODE_ENABLE)
            NSLog(@"Default Sale Tax Percentage = %f",sale_tax_percent);
    }
    else{
        if (DEBUG_MODE_ENABLE)
            NSLog(@"Don't have default sale tax");
    }
    
}

- (void) taxCleanup{
    
    [tax_current_number release];
    [orig_price release];    
    [tax_percent release];
    [tax_amount release]; 
    [discount_rate release];
    [discount_amount release]; 
    [total_after_tax release];
    [saved_amount release]; 
    [coupon release];

}

// Unit Converter Methods
- (void) initUnitConvParams{
    from_unit_type = [[NSMutableString alloc] init];       
    
    to_unit_type = [[NSMutableString alloc] init];          
    
    to_result_val = [[NSMutableString alloc] init];   
    
    unitConv_current_number = [[NSMutableString alloc] init]; 
    
    [self setDefaultUnitConvVal:YES];

    mass_conversion_list = [[NSArray alloc] initWithObjects:@"mg",@"g",@"kg",@"oz",@"lb", nil];
    length_conversion_list = [[NSArray alloc] initWithObjects:@"mm",@"cm",@"m",@"km",@"in",@"ft",@"yd",@"ml",@"nm", nil];
    temperature_conversion_list = [[NSArray alloc] initWithObjects:@"ºC",@"ºF",@"K", nil];
 
    pressure_conversion_list = [[NSArray alloc] initWithObjects:@"Pa",@"kPa",@"psi",@"atm",@"kgf/cm²",@"bar",@"mmHg",@"mmH₂O", nil];
    area_conversion_list = [[NSArray alloc] initWithObjects:@"m²",@"ft²",@"yd²",@"acre",@"a",@"ha", nil];
    volumn_conversion_list = [[NSArray alloc] initWithObjects:@"m³",@"cm³",@"gal",@"bbl",@"ft³",@"dl",@"ml",@"l",@"in³",@"yd³",@"cc", nil];
    cooking_conversion_list = [[NSArray alloc] initWithObjects:@"gal",@"quarts",@"pints",@"oz",@"cups",@"tbsp",@"tsp",@"l",@"ml", nil];
}

- (void) setDefaultUnitConvVal: (bool) clearCurNum{ 
    // clear math op params
    [self setDefaultMathOpVal];
    
    [from_unit_type setString:@""];     
    
    [to_unit_type setString:@""];  
    
    [to_result_val setString:@""];
    
    conversion_type = TOTAL_NUM_CONV_TYPES;
    if (clearCurNum){
        [unitConv_current_number setString:@"0"];        
    }

    
    table_row = 0;
    table_col = 0;  
    unitConv_decimal_number = NO;
    
}

- (void) convertUnit{
    
    float conversionFactor = 0.0;
    
    switch (conversion_type) {
        case MASS_UNIT:    
            [from_unit_type setString:[mass_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[mass_conversion_list objectAtIndex:table_col]];
            conversionFactor = massConverterTable[table_row][table_col];
            break;
        case LENGTH_UNIT:
            [from_unit_type setString:[length_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[length_conversion_list objectAtIndex:table_col]];
            conversionFactor = lengthConverterTable[table_row][table_col]; 
            break;
        case TEMPERATURE_UNIT:
            [from_unit_type setString:[temperature_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[temperature_conversion_list objectAtIndex:table_col]];            
            break;
            
        case PRESSURE_UNIT:    
            [from_unit_type setString:[pressure_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[pressure_conversion_list objectAtIndex:table_col]];
            conversionFactor = pressureConverterTable[table_row][table_col];
            break;
        case AREA_UNIT:
            [from_unit_type setString:[area_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[area_conversion_list objectAtIndex:table_col]];
            conversionFactor = areaConverterTable[table_row][table_col]; 
            break;
        case VOLUMN_UNIT:    
            [from_unit_type setString:[volumn_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[volumn_conversion_list objectAtIndex:table_col]];
            conversionFactor = volumnConverterTable[table_row][table_col];
            break;
        case COOKING_UNIT:
            [from_unit_type setString:[cooking_conversion_list objectAtIndex:table_row]];
            [to_unit_type setString:[cooking_conversion_list objectAtIndex:table_col]];
            conversionFactor = cookingConverterTable[table_row][table_col]; 
            break;
        default:
            break;
    }
    
    if (conversion_type == TOTAL_NUM_CONV_TYPES){
        [to_result_val setString:@""];
    }
    else {
        if (DEBUG_MODE_ENABLE)
            NSLog(@"conversion factor value = %f",conversionFactor);
        
        // calculate the unit conversion result
        float convResult = 0.0;
        if (conversion_type == TEMPERATURE_UNIT)
        {
            // use formula to convert temperature
            // Tc = (5/9)*(Tf - 32); Tf = (9/5)*Tc + 32
            if (table_row == 0){
                // from unit is Celcius
                if (table_col == 0){
                    // to unit is Celcius
                    convResult = [unitConv_current_number floatValue];
                }
                else if (table_col == 1){
                    // to unit is F
                    convResult = (9.0/5.0)*([unitConv_current_number floatValue])+32;
                }
                else {
                    // to unit is K; K = C + 273.15
                    convResult = [unitConv_current_number floatValue] + 273.15;
                }
            }
            else if (table_row == 1){
                // from unit is F
                if (table_col == 0){
                    // to unit is C
                    convResult = (5.0/9.0) * ([unitConv_current_number floatValue] - 32);
                }
                else if (table_col == 1){
                    // to unit is F
                    convResult = [unitConv_current_number floatValue];
                }
                else{
                    // to unit is K; K = (F - 32) * 5/9 + 273.15
                    convResult = ([unitConv_current_number floatValue] - 32) * (5.0/9.0) + 273.15;
                }
            }
            else {
                // from unit is K
                if (table_col == 0){
                    // to unit is C; C = K - 273.15
                    convResult = [unitConv_current_number floatValue] - 273.15;
                }
                else if (table_col == 1){
                    // to unit is F; F = (K - 273.15) * 9/5 + 32
                    convResult = ([unitConv_current_number floatValue] - 273.15) * (9.0/5.0) + 32;
                }
                else{
                    // to unit is K
                    convResult = [unitConv_current_number floatValue];
                }
            }
            
        }
        else
            convResult = [unitConv_current_number floatValue] * conversionFactor;
        
        NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
        [numFormatter setNumberStyle: NSNumberFormatterNoStyle ];
        [numFormatter setMinimumFractionDigits:0];
        [numFormatter setMaximumFractionDigits:4];
        [numFormatter setMinimumIntegerDigits:1];
        [numFormatter setMaximumIntegerDigits:20];        
        
        [to_result_val setString:[[numFormatter stringFromNumber:[NSNumber numberWithFloat:convResult]] stringByReplacingOccurrencesOfString:[numFormatter decimalSeparator] withString:@"."]];
    }
}

- (enum MathOpStatus) basicMathOperator{
    float curVal = [unitConv_current_number floatValue];
    enum MathOpStatus opStatus = NO_ERRORS;
    
    switch (mathOp) {
        case Addition:
            running_total += curVal; 
            break;
        case Subtraction:
            running_total -= curVal;
            break;
        case Multiplication:
            running_total *= curVal;
            break;
        case Division:
            if (curVal == 0){
                // cannot divide by zero
                opStatus = DIVISION_BY_ZERO;
                return opStatus;
            }
            running_total /= curVal;
            break;
        default:
            //return opStatus;
            break;
    }

    
    NSNumberFormatter *numFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    [numFormatter setNumberStyle: NSNumberFormatterNoStyle ];
    [numFormatter setMinimumFractionDigits:0];
    [numFormatter setMaximumFractionDigits:4];
    [numFormatter setMinimumIntegerDigits:1];
    [numFormatter setMaximumIntegerDigits:20]; 
     
    [unitConv_current_number setString:[[numFormatter stringFromNumber:[NSNumber numberWithFloat:running_total]] stringByReplacingOccurrencesOfString:[numFormatter decimalSeparator] withString:@"."]];

    return opStatus;
    
}

- (void) setDefaultMathOpVal{
    mathOp = TOTAL_NUM_MATH_OP_CNT;
    running_total = 0.0;
}

- (void) unitConvCleanup{
    [from_unit_type release];
    [to_unit_type release];
    [to_result_val release];
    [unitConv_current_number release];
    
    [mass_conversion_list release];
    [length_conversion_list release];
    [temperature_conversion_list release];
    
    [area_conversion_list release];
    [pressure_conversion_list release];
    [volumn_conversion_list release];
    [cooking_conversion_list release];
}

- (void) clearUnitResults{
    // clear math op params
    [self setDefaultMathOpVal];
    
    // clear unit converter params   
    [to_result_val setString:@"0"];
    unitConv_decimal_number = NO;
    [unitConv_current_number setString:@"0"];
    
}

@end
