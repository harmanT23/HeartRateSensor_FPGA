
.equ Heart_Rate, 72

.data 

SEDENTARY: .word 4

MODERATE: .word 6

ATHLETIC: .word 9


.text 

Calculate_Calories:

bgt r4, 85, CHECK_MODERATE_OR_ATHLETIC

movi r2, SEDENTARY

ret

CHECK_MODERATE_OR_ATHLETIC:

bgt r4, 100, DECLARE_ATHLETIC

movi r2, MODERATE

ret

DECLARE_ATHLETIC:

movi r2, ATHLETIC

ret


	

 