.386
.model flat, stdcall
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;includem biblioteci, si declaram ce functii vrem sa importam
includelib msvcrt.lib
extern exit: proc
extern malloc: proc
extern memset: proc

includelib canvas.lib
extern BeginDrawing: proc
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;declaram simbolul start ca public - de acolo incepe executia
public start
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

;sectiunile programului, date, respectiv cod
.data
;aici declaram date
window_title DB "Mini calculator",0
area_width EQU 320
area_height EQU 420
area DD 0

counter DD 0 ; numara evenimentele de tip timer

arg1 EQU 8
arg2 EQU 12
arg3 EQU 16
arg4 EQU 20
nr DD 0
nr1 DD 0
t DD 10
N DD 0
afis dd 0
operatie dd 0

symbol_width EQU 10
symbol_height EQU 20
button_width EQU 80
button_height EQU 60
include buttons.inc
include buttons1.inc
include buttons2.inc
include buttons3.inc
include buttons4.inc
include buttons5.inc
include buttons6.inc
include buttons7.inc
include buttons8.inc
include buttons9.inc
include buttonsX.inc
include buttonsE.inc
include buttonsP.inc
include buttonsM.inc
include buttonsD.inc
include buttonsR.inc
include letters.inc
include digits.inc
include characters.inc

.code
; procedura make_text afiseaza o litera sau o cifra la coordonatele date
; arg1 - simbolul de afisat (litera sau cifra)
; arg2 - pointer la vectorul de pixeli
; arg3 - pos_x
; arg4 - pos_y
make_text proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	cmp eax, 'A'
	jl make_digit
	cmp eax, 'Z'
	jg make_digit
	sub eax, 'A'
	lea esi, letters
	jmp draw_text
make_digit:
	cmp eax, '0'
	jl make_space
	cmp eax, '9'
	jg make_space
	sub eax, '0'
	lea esi, digits
	jmp draw_text
make_space:	
	mov eax, 26 ; de la 0 pana la 25 sunt litere, 26 e space
	lea esi, letters
	
draw_text:
	mov ebx, symbol_width
	mul ebx
	mov ebx, symbol_height
	mul ebx
	add esi, eax
	mov ecx, symbol_height
bucla_simbol_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, symbol_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, symbol_width
bucla_simbol_coloane:
	cmp byte ptr [esi], 0
	je simbol_pixel_alb
	mov dword ptr [edi], 0
	jmp simbol_pixel_next
simbol_pixel_alb:
	mov dword ptr [edi], 0FFFFFFh
simbol_pixel_next:
	inc esi
	add edi, 4
	loop bucla_simbol_coloane
	pop ecx
	loop bucla_simbol_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_text endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_button proc
    push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1] ; citim simbolul de afisat
	
	cmp eax, 'A0'
	je A0
	cmp eax, 'B1'
	je B1
	cmp eax, 'C2'
	je C2
	cmp eax, 'D3'
	je D3
	cmp eax, 'E4'
	je E4
	cmp eax, 'F5'
	je F5
	cmp eax, 'G6'
	je G6
	cmp eax, 'H7'
	je H7
	cmp eax, 'I8'
	je I8
	cmp eax, 'J9'
	je J9
	cmp eax, 'X'
	je X
	cmp eax, 'E'
	je E
	cmp eax, 'P'
	je P
	cmp eax, 'M'
	je M
	cmp eax, 'D'
	je D
	cmp eax, 'R'
	je R
	
A0:
	mov eax,0
	lea esi, zero
	jmp draw_button
B1:
	mov eax,0
	lea esi, unul
	jmp draw_button	
C2:
	mov eax,0
	lea esi, doi
	jmp draw_button	
D3:
	mov eax,0
	lea esi, trei
	jmp draw_button	
E4:
	mov eax,0
	lea esi, patru
	jmp draw_button	
F5:
	mov eax,0
	lea esi, cinci
	jmp draw_button	
G6:
	mov eax,0
	lea esi, sase
	jmp draw_button	
H7:
	mov eax,0
	lea esi, sapte
	jmp draw_button	
I8:
	mov eax,0
	lea esi, opt
	jmp draw_button	
J9:
	mov eax,0
	lea esi, noua
	jmp draw_button	
X:
	mov eax,0
	lea esi,ori
	jmp draw_button	
E:
	mov eax,0
	lea esi,egal
	jmp draw_button
P:
	mov eax,0
	lea esi,plus
	jmp draw_button	
M:
	mov eax,0
	lea esi,minus
	jmp draw_button	
D:
	mov eax,0
	lea esi,diviz
	jmp draw_button		
R:
	mov eax,0
	lea esi,del
	jmp draw_button		

	
draw_button:
	mov ebx, button_width
	mul ebx
	mov ebx, button_height
	mul ebx
	add esi, eax
	mov ecx, button_height
bucla_button_linii:
	mov edi, [ebp+arg2] ; pointer la matricea de pixeli
	mov eax, [ebp+arg4] ; pointer la coord y
	add eax, button_height
	sub eax, ecx
	mov ebx, area_width
	mul ebx
	add eax, [ebp+arg3] ; pointer la coord x
	shl eax, 2 ; inmultim cu 4, avem un DWORD per pixel
	add edi, eax
	push ecx
	mov ecx, button_width
bucla_button_coloane:
	cmp dword ptr [esi],0h
	je button_pixel_alb
	mov dword ptr [edi], 0h
	push ecx
	mov ecx, dword ptr [esi]
	mov dword ptr [edi], ecx
	pop ecx	
	jmp button_pixel_next
button_pixel_alb:
	;mov dword ptr [edi], 0FFFFFFh
button_pixel_next:
	add esi,4
	add edi, 4
	loop bucla_button_coloane
	pop ecx
	loop bucla_button_linii
	popa
	mov esp, ebp
	pop ebp
	ret
make_button endp
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; un macro ca sa apelam mai usor desenarea simbolului
make_text_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_text
	add esp, 16
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
make_button_macro macro symbol, drawArea, x, y
	push y
	push x
	push drawArea
	push symbol
	call make_button
	add esp, 16
endm
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; functia de desenare - se apeleaza la fiecare click
; sau la fiecare interval de 200ms in care nu s-a dat click
; arg1 - evt (0 - initializare, 1 - click, 2 - s-a scurs intervalul fara click)
; arg2 - x
; arg3 - y
draw proc
	push ebp
	mov ebp, esp
	pusha
	
	mov eax, [ebp+arg1]
	cmp eax, 1
	jz evt_click
	cmp eax, 2
	jz evt_timer ; nu s-a efectuat click pe nimic
	;mai jos e codul care intializeaza fereastra cu pixeli albi
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	push 255
	push area
	call memset
	add esp, 12
    make_button_macro 'A0', area, 80, 360
	make_button_macro 'B1', area, 0,  300
	make_button_macro 'C2', area, 80,  300
	make_button_macro 'D3', area, 160,  300
	make_button_macro 'E4', area, 0,  240
	make_button_macro 'F5', area, 80,  240
	make_button_macro 'G6', area, 160,  240
	make_button_macro 'H7', area, 0,  180
	make_button_macro 'I8', area, 80,  180
	make_button_macro 'J9', area, 160,  180
	make_button_macro 'X', area, 160,  360
	make_button_macro 'E', area, 240,  360
	make_button_macro 'P', area, 240,  300
	make_button_macro 'M', area, 240,  240
	make_button_macro 'D', area, 240,  180
	make_button_macro 'R', area, 0,  360
	jmp final_draw
	
	
 evt_click:
	
	
	
	mov eax,[ebp+arg3]; y
	mov ebx,[ebp+arg2]; x
	cmp eax,180
	jg c_y240

	c_y240:
		cmp eax, 240
		jl c_x1						;eticheta catre compararea lui x cand y este intre 240 si 300
		jg c_y300
	c_x1:							;compararea lui x cand y este intre 240 si 300
		cmp ebx,80
		jl Buton7
		cmp ebx,160
		jl Buton8
		 cmp ebx,240
			jl Buton9
			cmp ebx,320
			jl Buton_div
	Buton7:
		mov eax,nr
		mul t
		add eax,7
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton8:
		mov eax,nr
		mul t
		add eax,8
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton9:
		mov eax,nr
		mul t
		add eax,9
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton_div:
		
		cmp operatie,0
		jg nextdiv
		mov edx,nr
		mov [nr1],edx
		jmp div1
	nextdiv:
		cmp operatie,1
		jg nextdiv1
		cmp nr,0
		je gata
		mov eax, nr1
		mov edx, 0     ;pt err de adaugat
		div nr
		mov [nr1],eax
		jmp div1
	nextdiv1:
		cmp operatie,2
		jg nextdiv2
		mov eax, nr1
		sub eax,nr
		mov [nr1],eax
		jmp div1
	nextdiv2:
		cmp operatie,3
		jg nextdiv3
		mov eax, nr1
		add eax,nr
		mov [nr1],eax
		jmp div1
	nextdiv3:
		mov eax, nr1
		mul nr
		mov [nr1],eax
	div1:
		mov [operatie],1
		
		push ecx
		mov eax,area
		mov ecx, 60
	loop2impartire:
		push ecx
		mov ecx,area_width
		loop3impartire:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3impartire
		pop ecx
	loop loop2impartire
		pop ecx
		
		mov [nr],0
		mov eax,nr1
		mov [N],eax
		mov [afis],1
		jmp afisare
	c_y300:
		cmp eax,300
		jl c_x2
		jg c_y360
	c_x2:									;compararea lui x cand y este intre 300 si 360
		cmp ebx,80
		jl Buton4
		cmp ebx,160
			jl Buton5
			 cmp ebx,240
				jl Buton6
				cmp ebx,320
				jl Buton_minus
	Buton4:
		mov eax,nr
		mul t
		add eax,4
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton5:
		mov eax,nr
		mul t
		add eax,5
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton6:
		mov eax,nr
		mul t
		add eax,6
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton_minus:
		cmp operatie,0
		jg nextminus
		mov edx,nr
		mov [nr1],edx
		jmp minus1
	nextminus:
		cmp operatie,1
		jg nextminus1
		cmp nr,0
		je gata
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
		jmp minus1
	nextminus1:
		cmp operatie,2
		jg nextminus2
		mov edx,nr1
		cmp nr,edx
		jg gata
		mov eax, nr1
		sub eax,nr
		mov [nr1],eax
		jmp minus1
	nextminus2:
		cmp operatie,3
		jg nextminus3
		mov eax, nr1
		add eax,nr
		mov [nr1],eax
		jmp minus1
	nextminus3:
		mov eax, nr1
		mul nr
		mov [nr1],eax
	minus1:
		mov [operatie],2
		push ecx
		mov eax,area
		mov ecx, 60
	loop2minus:
		push ecx
		mov ecx,area_width
		loop3minus:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3minus
		pop ecx
	loop loop2minus
		pop ecx
		mov [nr],0
		
		mov eax,nr1
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	c_y360:
		cmp eax,360
		jl	c_x3
		jg c_y420
	c_x3:												;compararea lui x cand y este intre 360 si 420
		cmp ebx,80
		jl Buton1
		cmp ebx,160
			jl Buton2
			 cmp ebx,240
				jl Buton3
				cmp ebx,320
				jl Buton_plus
	Buton1:
		mov eax,nr
		mul t
		add eax,1
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton2:
		mov eax,nr
		mul t
		add eax,2
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton3:
		mov eax,nr
		mul t
		add eax,3
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton_plus:
		cmp operatie,0
		jg nextplus
		mov edx,nr
		mov [nr1],edx
		jmp plus1
	nextplus:
		cmp operatie,1
		jg nextplus1
		cmp nr,0
		je gata
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
		jmp plus1
	nextplus1:
		cmp operatie,2
		jg nextplus2
		mov edx, nr1
		cmp nr,edx
		jg gata
		mov eax, nr1
		sub eax,nr
		mov [nr1],eax
		jmp plus1
	nextplus2:
		cmp operatie,3
		jg nextplus3
		mov eax, nr1
		add eax,nr
		mov [nr1],eax
		jmp plus1
	nextplus3:
		mov eax, nr1
		mul nr
		mov [nr1],eax
	plus1:
		mov [operatie],3
		push ecx
		mov eax,area
		mov ecx, 60
	loop2plus:
		push ecx
		mov ecx,area_width
		loop3plus:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3plus
		pop ecx
	loop loop2plus
		pop ecx
		mov nr,0
		mov eax,nr1
		mov [N],eax
		mov [afis],1
		jmp afisare
	c_y420:
		cmp ebx,80
		jl ButonC
		cmp ebx,160
			jl Buton0
			 cmp ebx,240
				jl Buton_mul
				cmp ebx,320
				jl Buton_egal
	ButonC:
		mov [operatie],0
		push ecx
		mov eax,area
		mov ecx, 180
	loop2C:
		push ecx
		mov ecx,area_width
		loop3C:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3C
		pop ecx
	loop loop2C
		pop ecx
		mov nr,0
		jmp evt_timer
	Buton0:
		mov eax,nr
		mul t
		add eax,0
		mov [nr],eax
		mov [N],eax
		mov [afis],1
		jmp afisare
		
	Buton_mul:
		cmp operatie,0
		jg nextmul
		mov edx,nr
		mov [nr1],edx
		jmp mul1
	nextmul:
		cmp operatie,1
		jg nextmul1
		cmp nr,0
		je gata
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
		jmp mul1
	nextmul1:
		cmp operatie,2
		jg nextmul2
		mov edx, nr1
		cmp nr,edx
		jg gata
		mov eax, nr1
		sub eax,nr
		mov [nr1],eax
		jmp mul1
	nextmul2:
		cmp operatie,3
		jg nextmul3
		mov eax, nr1
		add eax,nr
		mov [nr1],eax
		jmp mul1
	nextmul3:
		mov eax, nr1
		mul nr
		mov [nr1],eax
	mul1:
		mov [operatie],4
		push ecx
		mov eax,area
		mov ecx, 60
	loop2mul:
		push ecx
		mov ecx,area_width
		loop3mul:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3mul
		pop ecx
	loop loop2mul
		pop ecx
		mov nr,0
		mov eax,nr1
		mov [N],eax
		mov [afis],1
		jmp afisare
	Buton_egal:
		cmp operatie,0
		jg nextegal
		mov edx,nr
		mov [nr1],edx
		jmp egal1
	nextegal:
		cmp operatie,1
		jg nextegal1
		cmp nr,0
		je gata
		mov eax, nr1
		mov edx, 0
		div nr
		mov [nr1],eax
		jmp egal1
	nextegal1:
		cmp operatie,2
		jg nextegal2
		mov edx, nr1
		cmp nr,edx
		jg gata
		mov eax, nr1
		sub eax,nr
		mov [nr1],eax
		jmp egal1
	nextegal2:
		cmp operatie,3
		jg nextegal3
		mov eax, nr1
		add eax,nr
		mov [nr1],eax
		jmp egal1
	nextegal3:
		mov eax, nr1
		mul nr
		mov [nr1],eax
	egal1:
		mov [operatie],0
		push ecx
		mov eax,area
		mov ecx, 60
	loop2egal:
		push ecx
		mov ecx,area_width
		loop3egal:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3egal
		pop ecx
	loop loop2egal
		pop ecx
		mov nr,0
		mov eax,nr1
		mov [N],eax
		mov [afis],1
		jmp afisare
		; mov [afis],1
		; jmp afisare
		
gata:

		push ecx
		mov eax,area
		mov ecx, 180
	loop2_e:
		push ecx
		mov ecx,area_width
		loop3_e:
			mov dword ptr [eax],0ff0000h						;culoarea rosu semnalizeaza eroarea
			add eax,4
		loop loop3_e
		pop ecx
	loop loop2_e
		pop ecx
	jmp final_draw
	
		
afisare:
	cmp afis,0
	je evt_timer
	
		push ecx
		mov eax,area
		mov ecx, 60
	loop2:
		push ecx
		mov ecx,area_width
		loop3:
			mov dword ptr [eax],0ffffffh
			add eax,4
		loop loop3
		pop ecx
	loop loop2
		pop ecx
	
	mov ebx, 10
	mov eax, N
	mov ecx,area_width
	sub ecx, 10
	loop1:
	mov edx, 0
	div ebx
	add edx, '0'
	make_text_macro edx, area, ecx, 10
	sub ecx, 10
	cmp eax,0
	jg loop1
	mov [afis],0	
		
		
evt_timer:
	;make_button_macro 'A', area, 10, 10


	
final_draw:
	popa
	mov esp, ebp
	pop ebp
	ret
draw endp

start:
	;alocam memorie pentru zona de desenat
	mov eax, area_width
	mov ebx, area_height
	mul ebx
	shl eax, 2
	push eax
	call malloc
	add esp, 4
	mov area, eax
	;apelam functia de desenare a ferestrei
	; typedef void (*DrawFunc)(int evt, int x, int y);
	; void __cdecl BeginDrawing(const char *title, int width, int height, unsigned int *area, DrawFunc draw);
	push offset draw
	push area
	push area_height
	push area_width
	push offset window_title
	call BeginDrawing
	add esp, 20
	
	;terminarea programului
	push 0
	call exit
end start

