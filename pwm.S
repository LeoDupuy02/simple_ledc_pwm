.global init_pwm

# Use CH3 + TIMER3
# Timer @1250Hz

init_pwm : 

    addi sp, sp, -4
	sw ra, 0(sp)

    # -----------------------------------------------------------------------------

    #### Base : 0x600C_0000 - System registers

    # SYSTEM_PERIP_RST_EN0_REG (0x0018) -> 0x0800 : RESET SYS_LEDC_CLK
    li a2, 0x600C0018
    li t5, 0x00000800
    lw t1, 0(a2)
    or t1, t1, t5
    sw t1, 0(a2)

    li a2, 0x600C0018
    li t5, 0x00000000
    lw t1, 0(a2)
    and t1, t1, t5
    sw t1, 0(a2)

    # SYSTEM_PERIP_CLK_EN0_REG (0x0010) -> 0x0800 : enable SYS_LEDC_CLK
    li a2, 0x600C0010
    li t6, 0x00000800
    lw t1, 0(a2)
    or t1, t1, t5
    sw t1, 0(a2)

    # SYSTEM_SYSCLK_CONF_REG (0x0058) -> 0x0400 : PLL as SOC CLK
    #li a2, 0x600C0058
    #li t5, 0x00400
    #lw t1, 0(a2)
    #or t1, t1, t5
    #sw t1, 0(a2)

    # SYSTEM_CLOCK_GATE_REG (0x0054) -> ori 0x0001

    # -------------------------------------------------------------
    # Base LEDC_PWM : 0x6001_9000

    # Register : LEDC_CONF_REG : 0x00D0 (general)  : APB_CLK as LEDC Timer
    li t5, 0x80000001
    li a2, 0x600190D0
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # Register : LEDC_TIMER3_CONF_REG : 0x00B8
	li t5, 0x0000F906
    li a2, 0x600190B8
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # Register : LEDC_CH3_HPOINT_REG : 0x00040
    li t5, 0x0000010
    li a2, 0x60019040
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # Register : LEDC_CH3_DUTY_REG : 0x0044
    li t5, 0x00000080
    li a2, 0x60019044
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # Register : LEDC_CH3_CONF0_REG : 0x003C
    li t5, 0x0000000f
    li a2, 0x6001903C
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # Register : LEDC_CH3_CONF1_REG : 0x0048
    li t5, 0x00000000
    li a2, 0x60019048
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # ---- UPDATE -----
    # Register : LEDC_CH3_CONF0_REG : 0x0000 (register 0)
    li t5, 0x00000010
    li a2, 0x6001903C
    lw t1, 0(a2)
	or t1, t1, t5
    sw t1, 0(a2)

    # Register : LEDC_TIMER3_CONF_REG : 0x00B8
    li t5, 0x02000000
    li a2, 0x600190B8
    lw t1, 0(a2)
    or t1, t1, t5
    sw t1, 0(a2)

    # ----------------------------------------------------------------------
    # Base GPIO : 0x6000_4000

    # Register : GPIO_FUNC48_IN_SEL_CFG_REG (n: 0-127) (0x0154+4*n) : bit 7 to 1
    #li t5, 0x0040
	#li a2, 0x60004214
    #lw t1, 0(a2)
	#or t1, t1, t5
    #sw t1, 0(a2)

    # Register : GPIO_FUNC8_OUT_SEL_CFG_REG (n: 0-21) (0x0554+4*n) : valeur sur 48 (ledc_ls_sig_out1 ) + 9ème bit sur 0 (to enable peripheral output)
	li a2, 0x60004574
	li t5, 0xfffff800
	li t6, 0x00000030
    lw t1, 0(a2)
    and t1, t1, t5
	or t1, t1, t6
    sw t1, 0(a2)

	# Register : IO_MUX_GPIO8_REG (0x0004+4*8) : CONFIG MUX : 0001010010100100
	li t5, 0x1000
    li t6, 0xfffff000
	li a2, 0x60009024
    lw t1, 0(a2)
	or t1, t1, t5
    and t1, t1, t6
    sw t1, 0(a2)

	# Register : GPIO_ENABLE_W1TC_REG (0x0028) : Clear ENABLE Reg

	# Register : GPIO_ENABLE_W1TS_REG (0x0024) : SET ENABLE
	li t5, 0x0100
	li a2, 0x60004024
    lw t1, 0(a2)
    or t1, t1, t5
    sw t1, 0(a2)

	# Register : GPIO_OUT_W1TS_REG (0x0008)
	li t5, 0x0100
	li a2, 0x60004000
    lw t1, 0(a2)
    or t1, t1, t5
    sw t1, 0(a2)

	# Register : GPIO_OUT_W1TC_REG (0x000C)

    addi sp, sp, 4
	jalr ra
