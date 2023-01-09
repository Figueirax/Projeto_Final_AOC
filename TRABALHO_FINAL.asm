.data	#OBS: Para leitura dos n�meros � necess�rio haver um espa�o entre eles e ao final do �ltimo n�mero a presen�a de 2 espa�os para identifica��o de fim 
	#Ol�, � neces�rio saber o local que o seu arquivo.asm se encontra para esse c�digo como no exemplo a seguir:
	#"C:/Users/pedro/Desktop/trabalho_final.txt"
	LocalArquivo: .asciiz "C:/Users/vitor/Desktop/trabalho_final.txt"
	Interface: .asciiz "\t\tMENU\n------------------------------------------\n\t1. Calcular M�dia \n------------------------------------------\n\t2.Calcular Mediana \n------------------------------------------\n\t3.Calcular Vari�ncia\n------------------------------------------\n\t0.Finalizar Programa\n------------------------------------------"
	Pula_Linha: .asciiz "\n"
	MensagemN: .asciiz "Os n�meros digitados no arquivo s�o:"
	Resultado_Mediana: .asciiz "O resultado da mediana �: "
	Resultado_Media: .asciiz "O resultado da media �: "
	Resultado_Variancia: .asciiz "O resultado da vari�ncia �: "
	espa�o1: .asciiz " "
	Conteudo: .space 1024
	dois: .float 2.0
	zero: .float 0.0
	
	num: 		#array para n�meros de caracteres
		.align 2
		.space 80
	MyArray: 	#array para conver��o 
		.align 2 
		.space 80
		
	MyArray2:	#array para os n�meros finais		
		.align 2
		.space 60
	ArrayMediana:	#array que organiza os n�meros em ordem decrescente
		.align 2
		.space 60

		
						
.text
	li $t9,0 #contador de numeros existentes dentro do vetor final
	li $t8,0 
	li $t6, 1
	li $t5, 0 #CONTADOR TXT
	li $v0, 13
	la $a0, LocalArquivo
	li $a1,0
	move $t0, $zero
	syscall
	
	
	move $s0, $v0
	#PEGANDO O CONTEUDO DO TXT EM STRING
	move $a0, $s0
	
	li $v0,14
	la $a1, Conteudo
	li $a2, 1024
	syscall

	
	move $t1, $zero	#CONTADOR VETOR
	li $v0,4
	la $a0,MensagemN
	syscall

	converteInt:			#Pega os n�meros do TXT e converte da tabela ASCCI para o n�mero inteiro correspondente
				
		lb $t4, Conteudo($t5) #NUMERO TXT
		div $t7, $t1, 4
		beq $t4, 32, potencia
		lb $a0, Conteudo($t5)
		move $t2,$a0
		#SUBTRAI O VALOR EM ASCCI PARA OBTER O VALOR CERTO EM DECIMAL
		sub $t2,$t2,48		#subtrai 48 para ter o n�mero correto, 0=48 na tabela ASCCI, logo esse procedimento � necess�rio para converter o n�mero
		sw $t2, MyArray($t1)
		addi $t1, $t1, 4
		addi $t5, $t5, 1
		j converteInt
	

	potencia:			# Multiplicar os algarismo por pot�ncias de 10 de acordo com as casas de centena, dezena e unidade
		subi $t7, $t7, 1
		beq $t7, $zero, multiplica
		mul  $t6, $t6, 10
		j potencia
	
	multiplica:			#multiplica o resultado ta pot�ncia presente em $t6 com os algarismos
		
		lw $t2, MyArray($t0)
		mul $s0, $t6, $t2
		addi $t0, $t0, 4
		 # Soma os algarismos
		add $t3, $t3,$s0 
		subi $t1, $t1, 4
		div $t7, $t1, 4
		li $t6, 1
		beq $t1, $zero, Verifica
		j potencia
		
		
	Verifica:	#verifica��o do final do TXT, considerando 2 espa�os vazios seguidos
		
		sw $t3, MyArray2($t8)
		addi $t9,$t9,1 #qunatidade de numeros no vetor final
		
		
		li $v0 4
		la $a0, espa�o1
		syscall
		
		li $v0, 1
		move $a0, $t3
		syscall
		

		move $t3, $zero
		addi $t8, $t8,4
		addi $t5, $t5, 1
		lb $t4, Conteudo($t5) #alterar o t5 para vir outros numeros
		beq $t4, 32, end
		move $t0, $zero
		j converteInt
	
	
		
	
	# AQUI VAI SER O CODIGO DA INTERFACE,  REINICIA��O DE VARIAVEIS	
	end:
		li $v0,4
		la $a0,Pula_Linha
		syscall
		
		sw $t9,num
		li $t0, 0
		li $t1, 0
		li $t2, 0
		li $t3, 0
		li $t4, 0
		li $t5, 0
		li $t6, 0
		li $t7, 0
		li $t8, 0
		lwc1 $f0, zero
		lwc1 $f1, zero
		lwc1 $f2, zero
		lwc1 $f3, zero
		lwc1 $f4, zero
		lwc1 $f5, zero
		lwc1 $f6, zero
		lwc1 $f7, zero
		lwc1 $f8, zero
		lwc1 $f9, zero
		
		
		
		lw $s0,-100($t2)  # Pegamos cada n�mero inteiro e tranformamos em float para os c�lculos futuros
		mtc1 $s0,$f2
		cvt.s.w $f2,$f2
		syscall
		
		lw $s1,num
		mtc1 $s1,$f9
		cvt.s.w $f9,$f9
		li $v0,4
		la $a0,Interface
		syscall
		
		li $v0,4
		la $a0,Pula_Linha
		syscall
		
		li $v0, 5
		syscall
		move $s4, $v0
		
		li $s1,1
		li $s2,2
		li $s3 3		#OP��ES DA INTERFACE
		beq $s4, $s1, media	# 1= M�DIA
		beq $s4, $s2, mediana	# 2= MEDIANA 
		beq $s4, $s3, variancia	# 3= VARIANCIA
		beq $s4, $zero, final_programa	# 0= FIM
		
		li $t0,0
		j mediana
	
	
	media:		# MEDIA DOS NUMEROS
		#Soma de todos os n�meros 
		beq $t5,$t9,media2
		addi $t5,$t5,1
		
		lw $s0, MyArray2($t0)
		mtc1 $s0,$f1
		cvt.s.w $f1,$f1
		
		add.s $f2,$f2,$f1
		addi $t0,$t0,4
		j media
		
	media2:		#divis�o pela quantidade de n�meros
		div.s $f2,$f2,$f9
		
		li $v0,4
		la $a0,Resultado_Media
		syscall
			
		li $v0,2
		mov.s $f12,$f2
		syscall
		
		j end
		
	mediana: #CALCULA A MEDIANA
		mul $t8,$t9,4 #QUANTIDADE DE NUMEROS MULTIPLICADA POR 4, PARA COMPARAR COM O T3
		
		lw $t1,MyArray2($t0)
		lw $t2,MyArray2($t3)
		
		blt $t1,$t2,mediana3 #ENTRA SE FOR MENOR
		beq $t8,$t3,mediana2 #entra quando acaba de comparar um numero com os demais
		addi $t3,$t3,4
		
		j mediana
			
	mediana2: #QUANDO PERCORRE O MYARRAY2 POR INTEIRO PELO REGISTRADOR $t3
	
		addi $t0,$t0,4
		sw $t1, ArrayMediana($t6)
		
		li $t6,0
		li $t3,0
		
		addi $t5,$t5,1  #T5 EH A QUNATIDADE DE VEZES QUE ENTRAMOS NA MEDIANA 2
		beq $t9,$t5,fim    #QUANDO T5 FOR IGUAL A T9, SIGNIFICA QUE ACABOU O PROCESSO
 		j mediana
		
	mediana3: #QUANTOS N�MEROS S�O MENORES QUE O N�MERO FIXADO
		
		addi $t6,$t6,4 #contador de quantos numeros ele eh menor
		addi $t3,$t3,4 
		j mediana
		
	fim:	#ORGANIZOU O VETOR PARA C�LCULO DA MEDIANA
		li $t0,0
		li $t1,0
		li $t3,0
		li $t4,2
		
		div $t9,$t4
		mfhi $t3
		
		beq $t3,0,caso_par
		j caso_impar
		

		# EXISTEM DOIS CASOS PARA A MEDIANA,
		#QUANTIDADE DE NUMEROS PAR OU IMPAR
		
		
	caso_par:
		div $t8,$t8,2
		lw $s0,ArrayMediana($t8)
		mtc1 $s0,$f4
		cvt.s.w $f4,$f4
		
		sub $t8,$t8,4
		lw $s1,ArrayMediana($t8)
		mtc1 $s1,$f5
		cvt.s.w $f5,$f5
		
		add.s $f5,$f5,$f4
		
		lwc1 $f12,dois
		
		div.s $f5,$f5,$f12
		
		li $v0,4
		la $a0,Resultado_Mediana
		syscall
		
		li $v0,2
		mov.s $f12,$f5  #printa o valor da mediana no caso par
		syscall
		
		j end
	caso_impar:
		div $s0,$t9,2
		mul $t8,$s0,4
		
		lw,$t7 ArrayMediana($t8)
		
		li $v0,4
		la $a0,Resultado_Mediana
		syscall
		
		li $v0,1
		move $a0,$t7  #printa a mediana no caso impar
		syscall
		
		j end
		
		
		
	variancia:	
	
		# MEDIA DOS NUMEROS
		beq $t5,$t9,variancia2
		addi $t5,$t5,1
		
		lw $s0, MyArray2($t0)
		mtc1 $s0,$f1
		cvt.s.w $f1,$f1
		
		add.s $f2,$f2,$f1
		addi $t0,$t0,4
		j variancia
		
	variancia2:		#DIVIDI A M�DIA PELA QUANTIDADE DE N�MEROS 		
		div.s $f2,$f2,$f9
		
		variancia3:	#SUBTRAI CADA N�MERO PELA M�DIA E ELEVA O RESULTADO AO QUADRADO
			
			beq $t1,$t9,variancia4
			addi $t1,$t1,1
		
			lw $s0, MyArray2($t2)
			mtc1 $s0,$f3
			cvt.s.w $f3,$f3
			sub.s $f3, $f3, $f2
			mul.s $f3, $f3, $f3
			add.s $f5, $f5, $f3
			
			add.s $f4,$f4,$f3
			addi $t2,$t2,4
			

			j variancia3
			
	variancia4:		#SUBRTRAI A QUANTIDADE DE N�MEROS PELA SOMA ANTERIOR
		div.s $f5,$f5,$f9
		
		li $v0,4
		la $a0,Resultado_Variancia
		syscall
		
		li $v0,2
		mov.s $f12,$f5
		syscall
		
		j end
	
	final_programa: #ENCERRA O PROGRAMA
		li $v0, 10
		syscall