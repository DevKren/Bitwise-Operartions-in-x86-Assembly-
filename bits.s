# Read the following instructions carefully
# You will provide your solution to this part of the project by
# editing the collection of functions in this source file.
#
# Some rules from Project 2 are still in effect for your assembly code here:
#  1. No global variables are allowed
#  2. You may not define or call any additional functions in this file
#  3. You may not use any floating-point assembly instructions
# You may assume that your machine:
#  1. Uses two's complement, 32-bit representations of integers.

# isZero - returns 1 if x == 0, and 0 otherwise
#   Argument 1: x
#   Examples: isZero(5) = 0, isZero(0) = 1
#   Rating: 1
.global isZero
isZero:
    cmpl $0, %edi 
    je is_zero #Jump if edi is equal to 0
    movl $0, %eax #Return 0 if x is NOT equal to 0 
    ret 
is_zero: 
    movl $1, %eax #Return 1 if x is equal to 0 
    ret


# bitNor - ~(x|y)
#   Argument 1: x
#   Argument 2: y
#   Example: bitNor(0x6, 0x5) = 0xFFFFFFF8
#   Rating: 1
.global bitNor
bitNor:
    movl %edi, %eax
    orl %esi, %eax # Perform a bitwise OR between x and y, storing the result in ea
    notl %eax #Perform a bitwise NOT operation, effectively inverting all bits
    ret 
    
    
    

# distinctNegation - returns 1 if x != -x.
#     and 0 otherwise
#   Argument 1: x
#   Rating: 2
.global distinctNegation
distinctNegation:
   cmpl %edi, %eax 
   negl %eax #Negate the value in eax to calculate -x
   cmpl %eax, %edi # Compare the negated value in eax with the original value in edi
   jne not_equal # Check if the values are not equal jump to not_equal if they are distinct
   movl $0, %eax  #If x is equal to -x, set eax to 0
   ret 
not_equal:
    movl $1,%eax  #If x is equal to -x, set eax to 1
    ret



# dividePower2 - Compute x/(2^n), for 0 <= n <= 30
#  Round toward zero
#   Argument 1: x
#   Argument 2: n
#   Examples: dividePower2(15,1) = 7, dividePower2(-33,4) = -2
#   Rating: 2
.global dividePower2
dividePower2:
    movl %edi, %eax # x
    sarl $31, %eax  # sign of x
    movl %eax, %r8d # copy sign to r8d
    movl %esi, %ecx # n
    movl $1, %r9d
    shll %cl, %r9d  # bias = (1 << n)
    decl %r9d       # bias = (1 << n) - 1
    andl %r8d, %r9d # bias = bias & sign
    movl %edi, %eax # x
    addl %r9d, %eax # x = x + bias
    sarl %cl, %eax  # x = x >> n
    ret
    
   
   


# getByte - Extract byte n from word x
#   Argument 1: x
#   Argument 2: n
#   Bytes numbered from 0 (least significant) to 3 (most significant)
#   Examples: getByte(0x12345678,1) = 0x56
#   Rating: 2
.global getByte
getByte:
    sal $3, %esi #Arthimetic Shift to left by 3
    movl %esi, %ecx  #Can only shift by ecx so we need to move esi into ecx
    sarl %ecx, %edi #Shifting by ecx then storing result in edi 
    andl $0xFF, %edi  #Apply a bitwise & operation to extract the least significant 8 bits (0xFF)
    movl %edi, %eax 
    ret
    # $0xFF = $255
    # %rdi = (x >> shift_sig_bytes)


# isPositive - return 1 if x > 0, return 0 otherwise
#   Argument 1: x
#   Example: isPositive(-1) = 0.
#   Rating: 2
.global isPositive
isPositive:
    cmpl $0, %edi 
    jg positive #Jump to Positive if edi is > than 0 
    movl $0, %eax #Return 0 if X is not positive 
    ret
positive: 
    movl $1, %eax #Returning 1 if x is greater than 0
    ret 

# floatNegate - Return bit-level equivalent of expression -f for
#   floating point argument f.
#   Both the argument and result are passed as unsigned int's, but
#   they are to be interpreted as the bit-level representations of
#   single-precision floating point values.
#   When argument is NaN, return argument.
#   Argument 1: f
#   Rating: 2
.global floatNegate
floatNegate:
.exp: 
    movl %edi, %r8d #Exponent = uf 
    movl $1,%ecx 
    shll %ecx,%r8d #Exponent = uf << 1 
    shrl %ecx,%r8d  #Exponent = (uf << 1) >> 1
.mantissa: 
    movl %edi, %r9d # Copy the mantissa (uf) to r9d
    andl $0x7FFFFF, %r9d # Mask the lower 23 bits (0x7FFFFF) to extract the mantissa
    movl $23, %ecx # Shift the Exponent right by 23 bits to prepare for NaN check
    shrl %ecx, %r8d 
.NaN_Check: 
    cmpl $0xFF, %r8d # Compare the Exponent to 0xFF (floating-point NaN check)
    jne not_equal_to #Jump if not equal too
    cmpl $0, %r9d  # Compare the mantissa to 0 to ensure it's not zero
    je not_equal_to # If mantissa is zero, jump to "not_equal_to"
    movl %edi, %eax 
    ret 
 not_equal_to: 
    # If Exponent is not 0xFF or mantissa is zero, negate the value
    movl %edi, %eax 
    xor $0x80000000, %eax 
    ret 
# isLessOrEqual - if x <= y  then return 1, else return 0
#   Argument 1: x
#   Argument 2: y
#   Example: isLessOrEqual(4,5) = 1.
#   Rating: 3
.global isLessOrEqual
isLessOrEqual:
    cmpl %esi, %edi #Comparing X and Y 
    jle less_or_equal #If X>=Y
    movl $0, %eax #Returning 0 
    ret
less_or_equal: 
    movl $1, %eax #If x<=y then return 1 
    ret
# bitMask - Generate a mask consisting of all 1's between
#   lowbit and highbit
#   Argument 1: highbit
#   Argument 2: lowbit
#   Examples: bitMask(5,3) = 0x38
#   Assume 0 <= lowbit <= 31, and 0 <= highbit <= 31
#   If lowbit > highbit, then mask should be all 0's
#   Rating: 3
.global bitMask
bitMask:
low_bit:
    movl %esi, %ecx 
    # Initialize edx to all 1's
    movl $0, %edx
    notl %edx  
    shll %ecx, %edx # Shift the 1's left by the value in ecx to create a mask
high_bit: 
    movl %edi, %ecx
    movl $0, %r9d # Initialize r9d to all 1's
    notl %r9d 
    shll %ecx, %r9d # Shift the 1's left by the value in ecx to create another mask
one_bit: 
    movl $1, %ecx
    shll %ecx, %r9d # Shift the 1 left by one position in r9d and invert it to create a 1-bit mask
    notl %r9d 
    andl %edx, %r9d # Perform a bitwise & operation to combine the masks created for lowbit and highbit
    movl %r9d, %eax 
    ret

# addOK - Determine if can compute x+y without overflow
#   Argument 1: x
#   Argument 2: y
#   Example: addOK(0x80000000,0x80000000) = 0,
#            addOK(0x80000000,0x70000000) = 1,
#   Rating: 3
.global addOK
addOK:
    addl %edi, %esi 
    setno %al # Set the overflow flag in the condition register (OF) to al
    movzbl %al, %eax #Zero-extend the value in al to eax
    ret # Return the result in eax, where 1 indicates overflow and 0 indicates no overflow
    
   

# floatScale64 - Return bit-level equivalent of expression 64*f for
#   floating point argument f.
#   Both the argument and result are passed as unsigned int's, but
#   they are to be interpreted as the bit-level representation of
#   single-precision floating point values.
#   When argument is NaN, return argument
#   Argument 1: f
#   Rating: 4
.global floatScale64
floatScale64:

.signBit:
    # Extract the sign bit from uf and store it in r8d
    movl %edi, %r8d
    movl $31, %ecx

    # Shift right by 31 bits to isolate the sign bit and then left by 31 bits to fill the register
    shrl %ecx, %r8d
    shll %ecx, %r8d

.exp2:
    # Extract the exponent from uf and store it in r9d
    movl %edi, %r9d
    movl $1, %ecx

    # Shift left by 1 to obtain the mantissa's leading 1
    shll %ecx, %r9d
    movl $24, %ecx

    # Shift right by 24 to isolate the exponent
    shrl %ecx, %r9d

    # Create a mask to isolate the mantissa
    movl %edi, %r10d
    movl $9, %ecx
    shll %ecx, %r10d
    shrl %ecx, %r10d
    movl $0, %edx

.NaNcheck:
    # Check if the exponent is 0xFF (NaN or infinity)
    cmpl $0xFF, %r9d
    jne .normalizedCheck

    # Check if the mantissa is zero
    cmpl $0, %r10d
    je .normalizedCheck

.equalNaN:
    # If uf is a NaN, return it as is
    movl %edi, %eax
    ret

.normalizedCheck:
    # Check if the exponent is zero (denormalized or zero)
    cmpl $0, %r9d
    jle .denormalizedCheck

.equalNormalized:
    # Check if the exponent is greater than 249 (overflow)
    cmpl $249, %r9d
    jg .OverflowOccurs

.OverflowNone:
    # If no overflow occurs, add 6 to the exponent, shift left by 23 bits
    addl $6, %r9d
    movl $23, %ecx
    shll %rcx, %r9d

    # Jump to the combining step
    jmp .combine

.OverflowOccurs:
    # In case of overflow, set the exponent to 0xFF, shift left by 23 bits, and clear the mantissa
    movl $0xFF, %r9d
    movl $23, %ecx
    shll %rcx, %r9d
    movl $0, %r10d

    # Jump to the combining step
    jmp .combine

.denormalizedCheck:
    # Check if the mantissa is greater than 0x01FFFF
    cmpl $0x01FFFF, %r10d
    jg .denormalizedToNormalized

.denormalizedEqual:
    # If the mantissa is already in normalized form, shift it left by 6 bits
    movl $6, %ecx
    shll %rcx, %r10d

    # Jump to the combining step
    jmp .combine

.denormalizedToNormalized:
    # Check if the mantissa is greater than or equal to 0x800000
    cmpl $0x800000, %r10d
    jge .denormalizedToNormalizedAgain

.loop:
    # Shift the mantissa to the left by one bit and increment the exponent
    movl $1, %ecx
    shll %rcx, %r10d
    incl %edx

    # Check if the mantissa has reached 0x800000
    cmpl $0x800000, %r10d
    jl .loop

.denormalizedToNormalizedAgain:
    # Calculate the new exponent by subtracting the number of shifts from 7
    movl $7, %r9d
    subl %edx, %r9d
    movl $23, %ecx
    shll %rcx, %r9d
    movl $1, %r11d
    movl $23, %ecx
    shll %ecx, %r11d

    # Create a mask to clear the bits below the exponent
    notl %r11d
    andl %r11d, %r10d

.combine:
    # Combine the sign, exponent, and mantissa to form the final floating-point representation
    movl %r8d, %eax
    orl %r9d, %eax
    orl %r10d, %eax

    # Return the result in eax
    ret


# floatPower2 - Return bit-level equivalent of the expression 2.0^x
#   (2.0 raised to the power x) for any 32-bit integer x.
#
#   The unsigned value that is returned should have the identical bit
#   representation as the single-precision floating-point number 2.0^x.
#   If the result is too small to be represented as a denorm, return
#   0. If too large, return +INF.
#
#   Argument 1: x
#   Rating: 4
.global floatPower2
floatPower2:
    .global floatPower2
floatPower2:
    # Compare x (Argument 1) to 127 (127 is too large for single-precision representation)
    cmpl $127, %edi
    jg too_large

    # Compare x to -126 (the smallest exponent for normalized numbers)
    cmpl $-126, %edi
    jge normalized

    # Compare x to -149 (the smallest exponent for denormalized numbers)
    cmpl $-149, %edi
    jge denormalized

    # If x is less than -149, return 0 (too small to represent)
    movl $0, %eax
    ret

too_large:
    # If x is greater than 127, return +∞ (exponent = 255)
    movl $0x7F800000, %eax
    ret

normalized:
    # Calculate the exponent for normalized numbers by adding 127 to x
    leal 127(%edi), %eax
    sall $23, %eax
    ret

denormalized:
    # Calculate the exponent for denormalized numbers by adding 149 to x
    leal 149(%edi), %eax

    # Create a mask with the shifted value (1 << x)
    movl $1, %edx
    sall %cl, %edx
    movl %edx, %eax
    ret

# Function epilogue: none needed for this simple function

greater_than_equal_to:
    # Add 127 to the exponent for normalized numbers
    addl $127, %edi
    movl %edi, %eax
    movl $23, %ecx
    shrl %ecx, %eax
    ret

small_number:
    # Return 0 for small numbers
    movl $0, %eax
    ret
