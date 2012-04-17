# Team RUBIKs
# John Cleaver
# Travis Dillan
# William Earley: Different Rotates
# Joseph Sewell : File I/O and Data Structure Planning

# Rubik’s Cube Solver
# EECS 314
# Project Source Code

# YOU MUST SIGN YOUR SECTIONS WITH YOUR NAME
# Also, $s7 is reserved. You can't use it. Don't use it.

	    # Static data declaration
	.data
	    # Strings
introTxt: .asciiz "Rubik's Cube Solver.\nTeam RUBIKs (John Cleaver, Travis Dillan, Willian Earley, Joe Sewell)\nLoading configuration from "
filename: .asciiz "input.bin"
fErrTxt : .asciiz "\nFile error..."
exitTxt : .asciiz "\nProgram exiting. Results output to "
debug   : .asciiz "\nDebug assertion..."

        # File descriptor for output
outFnme: .asciiz "output.txt"
outDesc: .word 0
        # Data for cube itself
        # each stored in phone keypad order
frontA:  .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Front of cube
rightA:  .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Right of cube
backA:   .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Back of cube
leftA:   .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Left of cube
bottomA: .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Bottom of cube
topA:    .word 0, 0, 0, 0, 0, 0, 0, 0, 0 # Top of cube

	.text
        # actual start of the main program, taken from example code
	.globl main
main:				#main has to be a global label
	addu	$s7, $0, $ra	#save the return address in a global register
	
sStart:
        # Displays starting intormation
        #  and stores filename in $a0
        # JOE SEWELL (jks51)
	li	$v0, 4		  #print_str (system call 4)
	la	$a0, introTxt # takes the address of string as an argument 
	syscall
	li	$v0, 4		  #print_str (system call 4)
	la	$a0, filename
	syscall
    
sLoad:
        # Loads starting configuration from file
        # JOE SEWELL (jks51)
        
    # Open the file, store file descriptor in $s0
    li  $v0, 13     # open (syscall 13)
    la  $a0, filename
    li  $a1, 1      # read
    li  $a2, 0
    syscall
                    # Exit if there's an error
    blt $v0, $zero, fErr
    add $s1, $v0, $zero  # Store file descriptor in $s1
    
    # TODO: Read each face into the appropriate memory
    
    # Close the file
    # Open the file, store file descriptor in $s0
    li  $v0, 16     # close (syscall 16)
    add $a0, $s1, $zero
    syscall
                    # Exit if there's an error
    blt $v0, $zero, fErr

sSetupOutput:
        # Sets up the output operations for output file
        # JOE SEWELL (jks51)
    # TODO
                
sBegin:
        # Will jump to next part of the algorithm
        # JOE SEWELL (jks51)
        j sEnd

sPrintStep:
        # Prints a step of the solution to the output file
        #  - Face # to rotate in $a0 (0, 1, 2, 3, 4, 5)
        #  - Direction in        $a1 (0-clockwise, 1-counterclockwise)
        # JOE SEWELL (jks51)
    # TODO
        li	$v0, 4		  #print_str (system call 4)
	    la	$a0, debug
	    syscall
        jr $ra

#
# REST OF THE CODE GOES HERE
#

fErr:
        # Displays file error message
        # JOE SEWELL (jks51)
    li	$v0, 4		  #print_str (system call 4)
	la	$a0, fErrTxt # takes the address of string as an argument 
	syscall
        
sEnd:
        # Exits program
        # JOE SEWELL (jks51)
    li	$v0, 4		  #print_str (system call 4)
	la	$a0, exitTxt # takes the address of string as an argument 
	syscall
	li	$v0, 4		  #print_str (system call 4)
	la	$a0, outFnme  # takes the address of string as an argument 
	syscall
                       #Usual stuff at the end of the main
	addu	$ra, $0, $s7	#restore the return address
	jr	    $ra		        #return to the main program
	nop                     # Makes the assembler happy
