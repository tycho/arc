Attribute VB_Name = "modASM"
Public Function MemCopyMMX_PreFetch(ByVal Dest As Long, ByVal Source As Long, ByVal ln As Long) As Long
    '#ASM_START
    '.MMX
    '.XMM
    ' push ebp ;save registers
    ' mov ebp, esp
    ' push ebx
    ' push esi
    ' push edi
    '
    ' mov eax, [ebp+16] ; put byte count in eax
    ' mov esi, [ebp+12] ; copy source pointer into source index
    ' mov edi, [ebp+8] ; copy dest pointer into destination index
    ' cld ; copy bytes forward
    
    ' cmp eax, 64 ; if under 64 bytes long
    ' jl Under64PreFetch ; jump
    
    ' push eax ; place a copy of eax on the stack
    ' shr eax, 6 ; integer divide eax by 64
    ' shl eax, 6 ; multiply eax by 64 to get dividend
    ' mov ecx, eax ; copy it into variable
    ' pop eax ; retrieve length in eax off the stack
    ' sub eax, ecx ; subtract dividend from length to get remainder
    ' mov ebx, eax ; copy remainder into variable
    ' shr ecx, 6 ; divide by 64 for DWORD data size
    ' ;shr ecx, 6 ;// 64 bytes per iteration
    '
    'loop1PreFetch:
    '
    ' prefetchnta 64[ESI] ;// Prefetch next loop, non-temporal
    ' prefetchnta 96[ESI]
    ' movq mm1, 0[ESI] ;// Read in source data
    ' movq mm2, 8[ESI]
    ' movq mm3, 16[ESI]
    ' movq mm4, 24[ESI]
    ' movq mm5, 32[ESI]
    ' movq mm6, 40[ESI]
    ' movq mm7, 48[ESI]
    ' movq mm0, 56[ESI]
    '
    ' movntq 0[EDI], mm1 ;// Non-temporal stores
    ' movntq 8[EDI], mm2
    ' movntq 16[EDI], mm3
    ' movntq 24[EDI], mm4
    ' movntq 32[EDI], mm5
    ' movntq 40[EDI], mm6
    ' movntq 48[EDI], mm7
    ' movntq 56[EDI], mm0
    '
    ' Add esi, 64
    ' Add edi, 64
    ' dec ecx
    ' jnz loop1PreFetch
    '
    ' emms
    
    ' mov eax, ebx ; put remainder in ecx
    ' Under64PreFetch:
    ' push eax ; place a copy of eax on the stack
    ' shr eax, 2 ; integer divide eax by 4
    ' shl eax, 2 ; multiply eax by 4 to get dividend
    ' mov ecx, eax ; copy it into variable
    ' pop eax ; retrieve length in eax off the stack
    ' sub eax, ecx ; subtract dividend from length to get remainder
    ' mov ebx, eax ; copy remainder into variable
    ' shr ecx, 2 ; divide by 4 for DWORD data size
    ' rep movsd ; repeat while not zero, move string DWORD
    ' mov ecx, ebx ; put remainder in ecx
    ' Under4PreFetch:
    ' rep movsb ; copy remaining BYTES from source to dest
    '
    ' pop edi
    ' pop esi
    ' pop ebx
    ' mov esp, ebp
    ' pop ebp
    ' ret 12
    '
    '#ASM_END
End Function
