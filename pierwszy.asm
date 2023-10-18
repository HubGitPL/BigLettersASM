; wczytywanie i wyświetlanie tekstu wielkimi literami
; (inne znaki się nie zmieniają)
.686
.model flat
extern _ExitProcess@4 : PROC
extern __write : PROC ; (dwa znaki podkreślenia)
extern __read : PROC ; (dwa znaki podkreślenia)
public _main
.data
tekst_pocz db 10, 'Prosz',0A9H,' napisa',86H,' jaki',98H,' tekst '
db 'i nacisna',86H,' Enter', 10
koniec_t db ?
magazyn db 80 dup (?)
nowa_linia db 10
liczba_znakow dd ?
.code
_main PROC
; wyświetlenie tekstu informacyjnego
; liczba znaków tekstu
mov ecx,(OFFSET koniec_t) - (OFFSET tekst_pocz)
push ecx
push OFFSET tekst_pocz ; adres tekstu
push 1 ; nr urządzenia (tu: ekran - nr 1)
call __write ; wyświetlenie tekstu początkowego
add esp, 12 ; usuniecie parametrów ze stosu
; czytanie wiersza z klawiatury
push 80 ; maksymalna liczba znaków
push OFFSET magazyn
push 0 ; nr urządzenia (tu: klawiatura - nr 0)
call __read ; czytanie znaków z klawiatury
add esp, 12 ; usuniecie parametrów ze stosu
; kody ASCII napisanego tekstu zostały wprowadzone
; do obszaru 'magazyn'
; funkcja read wpisuje do rejestru EAX liczbę
; wprowadzonych znaków
mov liczba_znakow, eax
; rejestr ECX pełni rolę licznika obiegów pętli
mov ecx, eax
mov ebx, 0 ; indeks początkowy
ptl: mov dl, magazyn[ebx] ; pobranie kolejnego znaku
;cmp dl, 'ą'
cmp dl, 86h; ć
jne kolejna1
mov dl, 8fh ;Ć
jmp dalej
kolejna1:
cmp dl, 0A5H ;ą
jne kolejna2
mov dl, 0A4H
jmp dalej
kolejna2:
cmp dl, 0A9H ;ę
jne kolejna3
mov dl, 0A8H
jmp dalej
kolejna3:
cmp dl, 88H ;ł
jne kolejna4
mov dl, 9DH
jmp dalej
kolejna4:
cmp dl, 0E4H ;ń
jne kolejna5
mov dl, 0E3H
jmp dalej
kolejna5:
cmp dl, 0A2H ;ó
jne kolejna6
mov dl, 0E0H
jmp dalej
kolejna6:
cmp dl, 98H ;ś
jne kolejna7
mov dl, 097H
jmp dalej
kolejna7: ;
cmp dl, 0ABH ;ź
jne kolejna8
mov dl, 8DH
jmp dalej
kolejna8:
cmp dl, 0BEH ;ż
jne kolejna9
mov dl, 0BDH
jmp dalej
kolejna9:
cmp dl, 'a'
jb dalej ; skok, gdy znak nie wymaga zamiany
cmp dl, 'z'
ja dalej ; skok, gdy znak nie wymaga zamiany
sub dl, 20H ; zamiana na wielkie litery
; odesłanie znaku do pamięci
dalej: mov magazyn[ebx], dl
inc ebx ; inkrementacja indeksu
loop ptl ; sterowanie pętlą
; wyświetlenie przekształconego tekstu
push liczba_znakow
push OFFSET magazyn
push 1
call __write ; wyświetlenie przekształconego
add esp, 12 ; usuniecie parametrów ze stosu
push 0
call _ExitProcess@4 ; zakończenie programu
_main ENDP
END
