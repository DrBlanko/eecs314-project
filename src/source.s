# Team RUBIKs
# John Cleaver
# Travis Dillan
# William Earley: Different Rotates
# Joseph Sewell : File I/O and Data Structure Planning

# Rubik’s Cube Solver
# EECS 314
# Project Source Code

# YOU MUST SIGN YOUR SECTIONS WITH YOUR NAME

#
# Static data declaration
#
	.data
	    # Strings
introTxt: .asciiz "Rubik's Cube Solver.\nTeam RUBIKs (John Cleaver, Travis Dillan, Willian Earley, Joe Sewell)\nLoading configuration from "
filename: .asciiz "input.bin"
outFnme : .asciiz "output.txt"
fErrTxt : .asciiz "\nFile error..."
exitTxt : .asciiz "\nProgram exiting. Results output to "
debug   : .asciiz "\nDebug assertion."

outBgn  : .ascii "Rubik's Cube Solver Output\n---\n"   # Len: 31
instBgn : .ascii "Rotate "          # Len: 7
nameF   : .ascii "Front  face "     # Len: 12
nameR   : .ascii "Right  face "
nameB   : .ascii "Back   face "
nameL   : .ascii "Left   face "
nameU   : .ascii "Bottom face "
nameT   : .ascii "Top    face "
instCtr : .ascii "counter-"         # Len: 8
instEnd : .ascii "clockwise.\n"     # Len: 11
outEnd  : .ascii "End of output.\n" # Len: 15

        # Data for cube itself
        # each stored in phone keypad order
dF:      .byte 0xAA
frontA:  .byte 0, 0, 0, 0, 0, 0, 0, 0, 0 # Front of cube
dR:      .byte 0xBB
rightA:  .byte 0, 0, 0, 0, 0, 0, 0, 0, 0 # Right of cube
dB:      .byte 0xCC
backA:   .byte 0, 0, 0, 0, 0, 0, 0, 0, 0 # Back of cube
dL:      .byte 0xDD
leftA:   .byte 0, 0, 0, 0, 0, 0, 0, 0, 0 # Left of cube
dU:      .byte 0xEE
bottomA: .byte 0, 0, 0, 0, 0, 0, 0, 0, 0 # Bottom of cube
dT:      .byte 0xFF
topA:    .byte 0, 0, 0, 0, 0, 0, 0, 0, 0 # Top of cube

        # Other data
outDesc : .word 0         # File descriptor for output
storedRt: .word 0         # Stored return address from start

#
# Code Start
#
	.text
        # actual start of the main program, taken from example code
	.globl main
main:				#main has to be a global label
	sw      $ra, storedRt
	
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
        
    # Open the file, store file descriptor in $s1
    li  $v0, 13     # open (syscall 13)
    la  $a0, filename
    li  $a1, 0      # read
    li  $a2, 0
    syscall
                    # Exit if there's an error
    blt $v0, $zero, sFileErr
    add $s1, $v0, $zero  # Store file descriptor in $s1
    
    # Read front face
    li  $v0, 14     # read (syscall 14)
    add $a0, $s1, $zero
    la  $a1, frontA
    li  $a2, 9
    syscall
    blt $v0, $zero, sFileErr
    
    # Read right face
    li  $v0, 14     # read (syscall 14)
    add $a0, $s1, $zero
    la  $a1, rightA
    li  $a2, 9
    syscall
    blt $v0, $zero, sFileErr
    
    # Read back face
    li  $v0, 14     # read (syscall 14)
    add $a0, $s1, $zero
    la  $a1, backA
    li  $a2, 9
    syscall
    blt $v0, $zero, sFileErr
    
    # Read left face
    li  $v0, 14     # read (syscall 14)
    add $a0, $s1, $zero
    la  $a1, leftA
    li  $a2, 9
    syscall
    blt $v0, $zero, sFileErr
    
    # Read bottom face
    li  $v0, 14     # read (syscall 14)
    add $a0, $s1, $zero
    la  $a1, bottomA
    li  $a2, 9
    syscall
    blt $v0, $zero, sFileErr
    
    # Read top face
    li  $v0, 14     # read (syscall 14)
    add $a0, $s1, $zero
    la  $a1, topA
    li  $a2, 9
    syscall
    blt $v0, $zero, sFileErr
    
    # Close the file
    li  $v0, 16     # close (syscall 16)
    add $a0, $s1, $zero
    syscall

sSetupOutput:
        # Sets up the output operations for output file
        # JOE SEWELL (jks51)
    # Open the file, store file descriptor in outDesc
    li  $v0, 13     # open (syscall 13)
    la  $a0, outFnme
    li  $a1, 1      # write
    li  $a2, 0
    syscall
                    # Exit if there's an error
    blt $v0, $zero, sFileErr
    sw $v0, outDesc # Store file descriptor in outDesc
    
    # Write file header
    li  $v0, 15     # write (syscall 15)
    lw  $a0, outDesc
    la  $a1, outBgn
    li  $a2, 31
    syscall
    
    j sBegin

sPrintStep:
        # Prints a step of the solution to the output file
        # Does not actually perform the action
        #  - Face # to rotate in $a0 (0, 1, 2, 3, 4, 5)
        #  - Direction in        $a1 (0-clockwise, 1-counterclockwise)
        # JOE SEWELL (jks51)
        
    # Load $a0 and $a1 into $t0 and $t1
    move $t0, $a0
    move $t1, $a1
    
    # Print first part of line
    li  $v0, 15     # write (syscall 15)
    lw  $a0, outDesc
    la  $a1, instBgn
    li  $a2, 7
    syscall
    
    # Print face
    li  $v0, 15     # write (syscall 15)
    lw  $a0, outDesc
    
    # Choose which face we're rotating
    li  $t2, 0
    beq $t0, $t2, sPrintStep_front
    li  $t2, 1
    beq $t0, $t2, sPrintStep_right
    li  $t2, 2
    beq $t0, $t2, sPrintStep_back
    li  $t2, 3
    beq $t0, $t2, sPrintStep_left
    li  $t2, 4
    beq $t0, $t2, sPrintStep_bottom
    li  $t2, 5
    beq $t0, $t2, sPrintStep_top
    j sPrintStep_Next

    # Load the appropriate string and length
    # JOE SEWELL (jks51)
sPrintStep_front:
    la  $a1, nameF
    j sPrintStep_Next
    
sPrintStep_right:
    la  $a1, nameR
    j sPrintStep_Next
    
sPrintStep_back:
    la  $a1, nameB
    j sPrintStep_Next
    
sPrintStep_left:
    la  $a1, nameL
    j sPrintStep_Next
    
sPrintStep_bottom:
    la  $a1, nameU
    j sPrintStep_Next
    
sPrintStep_top:
    la  $a1, nameT
    j sPrintStep_Next
    
sPrintStep_Next:
    # Actually print the face
    li  $a2, 12
    syscall
    
    # Print "counter" if $t1 set
    beq $t1, $zero, sPrintStep_End
    
sPrintStep_Counter:
    li  $v0, 15     # write (syscall 15)
    lw  $a0, outDesc
    la  $a1, instCtr
    li  $a2, 8
    syscall
    
sPrintStep_End:
    # Print out the end of the line
    li  $v0, 15     # write (syscall 15)
    lw  $a0, outDesc
    la  $a1, instEnd
    li  $a2, 11
    syscall
    
        # DEBUG:
    li	$v0, 4		  #print_str (system call 4)
    la	$a0, debug
    syscall
    
    # Return
    jr $ra

sBegin:

#
# REST OF THE CODE GOES HERE
#
    # DEBUG:
    li  $a0 0
    li  $a1 1
    jal sPrintStep
    li  $a0 1
    li  $a1 0
    jal sPrintStep
    li  $a0 2
    li  $a1 0
    jal sPrintStep
    li  $a0 3
    li  $a1 1
    jal sPrintStep
    li  $a0 4
    li  $a1 1
    jal sPrintStep
    li  $a0 5
    li  $a1 0
    jal sPrintStep
    
    # Jump to sEnd when cube has been solved
    # and all steps output
    j sEnd;

sFileErr:
        # Displays file error message
        # JOE SEWELL (jks51)
    li	$v0, 4		  #print_str (system call 4)
	la	$a0, fErrTxt # takes the address of string as an argument 
	syscall
        
sEnd:
        # Exits program
        # JOE SEWELL (jks51)    
    # Write closing line to file
    li  $v0, 15     # write (syscall 15)
    lw  $a0, outDesc
    la  $a1, outEnd
    li  $a2, 15
    syscall
    
    # Close outputFile
    lw  $s1, outDesc
    li  $v0, 16     # close (syscall 16)
    add $a0, $s1, $zero
    syscall

    # Print exit info
    li	$v0, 4		  #print_str (system call 4)
	la	$a0, exitTxt # takes the address of string as an argument 
	syscall
	li	$v0, 4		  #print_str (system call 4)
	la	$a0, outFnme  # takes the address of string as an argument 
	syscall
                       #Usual stuff at the end of the main
	lw  	$ra, storedRt	#restore the return address
	jr	    $ra		        #return to the main program
	nop                     # Makes the assembler happy
