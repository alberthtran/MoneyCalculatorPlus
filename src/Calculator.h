//
//  Calculator.h
//  pocketCalc
//
//  Created by Albert Tran on 8/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

enum SaleTaxCalcStatus {
    NO_SALE_TAX_ERRORS = 0,
    INVALID_COUPON_AMOUNT = 1,
    INVALID_TAX_PERCENTAGE = 2,
    TOTAL_NUM_SALE_TAX_ERROR_CNT = 3
};

enum MathOpStatus {
    NO_ERRORS = 0,
    DIVISION_BY_ZERO = 1,
    INVALID_OP = 2,
    TOTAL_NUM_ERROR_CODE_CNT = 3
};

enum MathOperator {
    Addition = 0,
    Subtraction = 1,
    Multiplication = 2,
    Division = 3,
    TOTAL_NUM_MATH_OP_CNT = 4
};

enum ConversionType {
    LENGTH_UNIT = 0,
    MASS_UNIT = 1,
    TEMPERATURE_UNIT = 2,
    PRESSURE_UNIT = 3,
    AREA_UNIT = 4,
    VOLUMN_UNIT = 5,
    COOKING_UNIT = 6, 
    TOTAL_NUM_CONV_TYPES = 7
};

enum MassConverterUnit {
    MILLIGRAMS = 0,
    GRAMS = 1,
    KILOGRAMS = 2,
    OUNCES = 3,
    POUNDS = 4,
    TOTAL_NUM_MASS_UNIT_CNT = 5
};

enum LengthConverterUnit {
    MILLIMETERS = 0,
    CENTIMETERS = 1,
    METERS = 2,
    KILOMETERS = 3,
    INCHES = 4,
    FEET = 5,
    YARDS = 6,
    MILES = 7,
    NAUTICAL_MILES = 8,
    TOTAL_NUM_LENGTH_UNIT_CNT = 9
};

enum TemperatureConverterUnit {
    CELSIUS = 0,
    FAHRENHEIT = 1,
    TOTAL_NUM_TEMP_UNIT_CNT = 2
};

enum PressureConverterUnit {
    PA = 0,
    KPA = 1,
    PSI = 2,
    ATM = 3,
    KGF_CM_2 = 4,
    BAR = 5,
    MMHG = 6,
    MMH20 = 7,
    TOTAL_NUM_PRESSURE_UNIT_CNT = 8
};

enum AreaConverterUnit {
    METER_SQUARE = 0,
    FEET_SQUARE = 1,
    YARD_SQURE = 2,
    ACRE = 3,
    ARES = 4,
    HECTARES = 5,
    TOTAL_NUM_AREA_UNIT_CNT = 6
};

enum VolumnConverterUnit {
    METER_CUBE = 0,
    CENTIMETER_CUBE = 1,
    GALLON = 2,
    BBL = 3,
    FEET_CUBE = 4,
    DL = 5,
    ML = 6,
    L = 7,
    INCH_CUBE = 8,
    YARD_CUBE = 9,
    CC = 10,
    TOTAL_NUM_VOLUMN_UNIT_CNT = 11
};

enum CookingConverterUnit {
    GALLONS = 0,
    QUARTS = 1,
    PINTS = 2,
    FLUID_ONCES = 3,
    CUPS = 4,
    TABLE_SPOONS = 5,
    TEA_SPOONS = 6,
    LITERS = 7,
    MILILITERS = 8,
    TOTAL_NUM_COOKING_UNIT_CNT = 9
};

@interface Calculator : NSObject {
    
    // --- Tip Parameters ------
    NSMutableString* tips_percentage;
    NSMutableString* heads_count;
    
    // Calculated Results that caller can use them for displaying results
    NSMutableString* each_amount;
    NSMutableString* total_amount;
    NSMutableString* each_tip;
    NSMutableString* total_tip;
    bool tip_decimal_number;
    NSMutableString* tip_current_number;

    
    // --- End of Tip Parameters ------
    
    // --- Tax Parameters ------
    NSMutableString* orig_price;
    NSMutableString* tax_percent;    
    NSMutableString* tax_amount;
    NSMutableString* discount_rate;
    NSMutableString* discount_amount;
    NSMutableString* total_after_tax;
    NSMutableString* saved_amount;
    NSMutableString* coupon;  
    
    // gotOrigPrice
    bool gotOrigPrice;
    bool gotDiscountRate;
    bool gotSaleTax;
    bool gotCoupon;
    bool tax_decimal_number;
    NSMutableString* tax_current_number;
    // --- End of Tax Parameters ------

    // --- Unit Converter Parameters ------
    
    //NSMutableString* type_of_conversion;
    NSMutableString* from_unit_type;
    NSMutableString* to_unit_type;
    enum ConversionType conversion_type;
    int table_row;
    int table_col;

    NSMutableString* to_result_val;


    bool unitConv_decimal_number;
    NSMutableString* unitConv_current_number;
    
    // math operation
    float running_total;
    enum MathOperator mathOp;
    
    NSArray* mass_conversion_list;
    NSArray* length_conversion_list;
    NSArray* temperature_conversion_list;    
    
    NSArray* pressure_conversion_list;
    NSArray* area_conversion_list;
    NSArray* volumn_conversion_list; 
    NSArray* cooking_conversion_list;  
    
}

// Establish public properties
// Tip params properties

@property(nonatomic,retain) NSMutableString* tips_percentage;
@property(nonatomic,retain) NSMutableString* heads_count;

@property(nonatomic,retain) NSMutableString* each_amount;
@property(nonatomic,retain) NSMutableString* total_amount;
@property(nonatomic,retain) NSMutableString* each_tip;
@property(nonatomic,retain) NSMutableString* total_tip;

@property(nonatomic,retain) NSMutableString* tip_current_number;
@property(readwrite) bool tip_decimal_number;

@property(nonatomic,retain) NSMutableString* tax_current_number;
@property(readwrite) bool tax_decimal_number;

@property(nonatomic,retain) NSMutableString* unitConv_current_number;
@property(readwrite) bool unitConv_decimal_number;

// Tax params properties
@property(nonatomic,retain) NSMutableString* orig_price;
@property(nonatomic,retain) NSMutableString* tax_percent;
@property(nonatomic,retain) NSMutableString* tax_amount;
@property(nonatomic,retain) NSMutableString* discount_rate;
@property(nonatomic,retain) NSMutableString* discount_amount;
@property(nonatomic,retain) NSMutableString* total_after_tax;
@property(nonatomic,retain) NSMutableString* saved_amount;
@property(nonatomic,retain) NSMutableString* coupon;

@property(readwrite) bool gotOrigPrice;
@property(readwrite) bool gotDiscountRate;
@property(readwrite) bool gotSaleTax;
@property(readwrite) bool gotCoupon;

@property(readwrite) enum MathOperator mathOp;
@property(readwrite) float running_total;

// Unit Converter properties
@property(readwrite) enum ConversionType conversion_type;
@property (readwrite) int table_row;
@property (readwrite) int table_col;
@property(nonatomic,retain) NSMutableString* from_unit_type;
@property(nonatomic,retain) NSMutableString* to_unit_type;

@property(nonatomic,retain) NSMutableString* to_result_val;


@property(nonatomic,retain) NSArray* mass_conversion_list;
@property(nonatomic,retain) NSArray* length_conversion_list;
@property(nonatomic,retain) NSArray* temperature_conversion_list;

@property(nonatomic,retain) NSArray* pressure_conversion_list;
@property(nonatomic,retain) NSArray* area_conversion_list;
@property(nonatomic,retain) NSArray* volumn_conversion_list;
@property(nonatomic,retain) NSArray* cooking_conversion_list;


// Singleton or an instance
+ (Calculator*) calcInstance;

// Method for computing the new total

- (void) initTipParams;

- (void) setDefaultTipVal;

- (void) computeTipsResult;

- (void) calcCleanup;

- (void) tipCleanup;

// Tax Methods
- (enum SaleTaxCalcStatus) computeSaleTaxResult;
- (void) initTaxParams;
- (void) setDefaultTaxVal;

- (void) taxCleanup;

// unit converter methods
- (void) initUnitConvParams;
- (void) setDefaultUnitConvVal: (bool) clearCurNum;

- (void) convertUnit;

- (void) unitConvCleanup;

- (enum MathOpStatus) basicMathOperator;

- (void) setDefaultMathOpVal;

- (void) clearUnitResults;

@end
