.386
.model flat,stdcall
option casemap:none
WinMain proto :DWORD,:DWORD,:DWORD,:DWORD
Calc proto :DWORD ,:DWORD,:DWORD
Input proto :DWORD
include C:\masm32\include\windows.inc
include C:\masm32\include\user32.inc
include C:\masm32\include\kernel32.inc
include C:\masm32\m32lib\masm32.inc
includelib C:\masm32\m32lib\masm32.lib
includelib C:\masm32\lib\user32.lib
includelib C:\masm32\lib\kernel32.lib



.data
ClassName db "DLGCLASS",0
DlgName db "MyDialog",0
AppName db "Calculator",0
strerror db "Loi chia cho 0",0


.data?
wc WNDCLASSEX <?>
msg MSG	<?>
hDlg HWND ?
hInstance HINSTANCE ?
CommandLine LPSTR ?
buffer_input db 50 dup(?)
buffer_output db 50 dup(?)
lenInput dd ?
buffer_num db 50 dup(?)
opera db ?
opera1 db ?
buffer db 50 dup(?)
num dd ?

.const
BTN_0 		equ	3000
BTN_1	 	equ	3001
BTN_2		equ	3002
BTN_3		equ 3003
BTN_4		equ 3004
BTN_5		equ 3005
BTN_6		equ 3006
BTN_7		equ 3007
BTN_8		equ 3008
BTN_9		equ 3009 
BTN_DOT 	equ 3010
BTN_ADD 	equ 3011
BTN_SUB		equ 3012
BTN_DIV 	equ 3013
BTN_MUL		equ	3014
BTN_CALC	equ 3015
BTN_DEL		equ	3016
BTN_C		equ 3017
BTN_SIGN	equ 3018
BTN_MOD		equ	3019
EDIT_INPUT		equ 3020
EDIT_OUTPUT		equ 3021
ICO_CALC 		equ 3022
.code
start:
	;invoke GetModuleHandle, NULL
	push NULL
	call GetModuleHandle
	mov    hInstance,eax
	;invoke GetCommandLine
	call GetCommandLine
	mov CommandLine,eax
	;invoke WinMain, hInstance,NULL,CommandLine, SW_SHOWDEFAULT
	push SW_SHOWDEFAULT
	push CommandLine
	push NULL
	push hInstance
	call WinMain
	;invoke ExitProcess,eax
	push eax
	call ExitProcess
WinMain proc hInst:HINSTANCE,hPrevInst:HINSTANCE,CmdLine:LPSTR,CmdShow:DWORD
	
	mov   wc.cbSize,SIZEOF WNDCLASSEX
	mov   wc.style, CS_HREDRAW or CS_VREDRAW
	mov   wc.lpfnWndProc, OFFSET WndProc
	mov   wc.cbClsExtra,NULL
	mov   wc.cbWndExtra,DLGWINDOWEXTRA
	push  hInst
	pop   wc.hInstance
	mov   wc.hbrBackground,COLOR_BTNFACE+1
	;mov   wc.lpszMenuName,OFFSET MenuName
	mov   wc.lpszClassName,OFFSET ClassName
	;invoke LoadIcon,NULL,ICO_CALC
	push ICO_CALC
	push NULL
	call LoadIcon
	mov   wc.hIcon,eax
	mov   wc.hIconSm,eax
	;invoke LoadCursor,NULL,IDC_ARROW
	push IDC_ARROW
	push NULL
	call LoadCursor
	mov   wc.hCursor,eax
	;invoke RegisterClassEx, addr wc
	push offset wc
	call RegisterClassEx
	;invoke CreateDialogParam,hInstance,ADDR DlgName,NULL,NULL,NULL
	push NULL
	push NULL
	push NULL
	push offset DlgName
	push hInstance
	call CreateDialogParam
	mov   hDlg,eax
	;INVOKE ShowWindow, hDlg,SW_SHOWNORMAL
	push SW_SHOWNORMAL
	push hDlg
	call ShowWindow
	;INVOKE UpdateWindow, hDlg
	push hDlg
	call UpdateWindow
	;.WHILE TRUE
	loop_mesage:
        ;INVOKE GetMessage, ADDR msg,NULL,0,0
		push 0
		push 0
		push NULL
		push offset msg
		call GetMessage
        ;.BREAK .IF (!eax)
		or eax,eax
		je end_message
        ;invoke IsDialogMessage, hDlg, ADDR msg
		push offset msg
		push hDlg
		call IsDialogMessage
        ;.if eax==FALSE
		cmp eax,FALSE
		jne loop_mesage
            ;INVOKE TranslateMessage, ADDR msg
			push offset msg
			call TranslateMessage
            ;INVOKE DispatchMessage, ADDR msg
			push offset msg
			call DispatchMessage
		;.endif
		jmp loop_mesage
	;.ENDW
	end_message:
	mov     eax,msg.wParam
	ret
WinMain endp
WndProc proc hWnd:HWND, uMsg:UINT, wParam:WPARAM, lParam:LPARAM
	.if uMsg==WM_CREATE
		mov lenInput,0
	.ELSEIF uMsg==WM_DESTROY
		invoke PostQuitMessage,NULL
	.ELSEIF uMsg==WM_COMMAND
		mov eax,wParam
		.IF lParam==0
			
		.ELSE
			mov edx,wParam
			shr edx,16
			.IF dx==BN_CLICKED
				.IF ax==BTN_CALC	
					invoke Calc,addr buffer_input,lenInput,addr buffer_output
					invoke SetDlgItemText,hWnd,EDIT_OUTPUT,ADDR buffer_output
                 .elseif ax==BTN_0
					invoke Input,'0'
				.elseif ax==BTN_1
					invoke Input,'1'
				.elseif ax==BTN_2
					invoke Input,'2'
				.elseif ax==BTN_3
					invoke Input,'3'
				.elseif ax==BTN_4
					invoke Input,'4'
				.elseif ax==BTN_5
					invoke Input,'5'
				.elseif ax==BTN_6
					invoke Input,'6'
				.elseif ax==BTN_7
					invoke Input,'7'
				.elseif ax==BTN_8
					invoke Input,'8'
				.elseif ax==BTN_9
					invoke Input,'9'
				.elseif ax==BTN_ADD
					invoke Input,'+'
				.elseif ax==BTN_SUB
					invoke Input,'-'
				.elseif ax==BTN_MUL
					invoke Input,'*'
				.elseif ax==BTN_DIV
					invoke Input,'/'
				.elseif ax==BTN_DOT
					invoke Input,'.'
				.elseif ax==BTN_SIGN
					invoke Input,'-'
				.elseif ax==BTN_MOD
					invoke Input,'%'
				.elseif ax==BTN_DEL
					dec lenInput
					mov ebx,lenInput
					mov buffer_input[ebx],0
					invoke SetDlgItemText,hWnd,EDIT_INPUT,ADDR buffer_input
				.elseif ax==BTN_C
					mov lenInput,0
					mov buffer_input[0],0
					invoke SetDlgItemText,hWnd,EDIT_INPUT,ADDR buffer_input
				
				.ENDIF
			.ENDIF
		.ENDIF
	.ELSE
		invoke DefWindowProc,hWnd,uMsg,wParam,lParam
		ret
	.ENDIF
	xor    eax,eax
	ret
WndProc endp

Calc proc input:DWORD ,len :DWORD,output:DWORD
	push ebx
	push ecx
	push edx
	push edi
	
	
	mov byte ptr[buffer_num],0
	mov opera,'+'
	xor edi,edi
	xor ebx,ebx
	xor edx,edx
	loop_input:
		cmp ebx,len
		jg end_input
		
		mov cl,buffer_input[ebx]
		mov opera1,cl
		cmp cl,'+'
		je isoperator
		cmp cl,'-'
		je isoperator
		cmp cl,'*'
		je isoperator
		cmp cl,'/'
		je isoperator
		cmp cl,'%'
		je isoperator
		cmp cl,0
		je isoperator
		jmp isnum
		
		isnum:
			mov byte ptr [buffer_num+edx],cl
			inc edx
			mov byte ptr[buffer_num+edx],0
		jmp endcmp
		
		isoperator:
			;invoke atol,addr buffer_num
			push offset buffer_num
			call atol
			
			mov num,eax
			xor edx,edx
			cmp opera,'+'
			je isadd
			cmp opera,'-'
			je issub
			cmp opera,'*'
			je ismul
			cmp opera,'/'
			je isdiv
			cmp opera,'%'
			je ismod
			jmp endopera
			
			isadd:
				push num
				inc edi
			jmp endopera
		
			issub:
				mov eax,num
				not eax
				inc eax			
				push eax
				inc edi
			jmp endopera
			
			ismul:
				pop eax
				imul num
				push eax
			jmp endopera
			
			isdiv:
				cmp num,0
				jne notzero
				;invoke MessageBox,hDlg,NULL,NULL,MB_OK
				push MB_OK
				push NULL
				push offset strerror
				push hDlg
				call MessageBox
				
				jmp endopera
				notzero:
				pop eax
				cmp eax,0
				jge duong
					dec eax
					not eax
					idiv num
					not eax
					inc eax
					push eax
					jmp endopera
				duong:
				idiv num
				push eax
			
			jmp endopera
			
			ismod:
				pop eax
				idiv num
				push edx
			jmp endopera
				
			
			endopera:
			mov cl,opera1
			mov opera,cl
			xor edx,edx
			mov byte ptr[buffer_num],0
		jmp endcmp	
	
		endcmp:
		inc ebx
		jmp loop_input
	end_input:
	
	;invoke atol,input
	xor ebx,ebx
	xor eax,eax
	loop_sum:
		cmp ebx,edi
		jge end_sum
		
		pop edx
		add eax,edx
		
		inc ebx
		jmp loop_sum
	end_sum:
	
	;invoke ltoa,eax,output
	push output
	push eax
	call ltoa
	
	push edi
	pop edx
	pop ecx
	pop ebx
	ret
Calc endp
Input proc char:DWORD
	push ebx
	push eax
	mov ebx,lenInput
	push char
	call CheckInput
	cmp eax,0
	je 	noinput
	mov eax,char
	mov buffer_input[ebx],al
	mov buffer_input[ebx+1],0
	inc lenInput
	noinput:
	pop eax
	pop ebx
	;invoke SetDlgItemText,hDlg,EDIT_INPUT,ADDR buffer_input
	push offset buffer_input
	push EDIT_INPUT
	push hDlg
	call SetDlgItemText
	ret
Input endp
CheckInput proc char:DWORD
	push ebx
	mov eax,char
	mov ebx,lenInput
	cmp ebx,0
	jg check1
	cmp al,'-'
	je InputTRUE
	cmp al,'+'
	je InputTRUE
	cmp al,'0'
	jl InputFALSE
	cmp al,'9'
	jg InputFALSE
	jmp InputTRUE
	check1:
	cmp al,'0'
	jl checkop
	cmp al,'9'
	jg checkop
	jmp InputTRUE
	
	checkop:
		cmp buffer_input[ebx-1],'0'
		jl InputFALSE
		cmp buffer_input[ebx-1],'9'
		jg InputFALSE
	
	InputTRUE:
	mov eax,char
	pop ebx
	ret
	
	InputFALSE:
	mov eax,0
	pop ebx
	ret
	
	
CheckInput endp
Cong proc x1:DWORD,x2:DWORD
Cong endp
Tru proc x1:DWORD,x2:DWORD
Tru endp
Nhan proc x1:DWORD,x2:DWORD
Nhan endp
Chia proc x1:DWORD,x2:DWORD
Chia endp

end start
