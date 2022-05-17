% TK Lipstick Girl by Ariell

% Mencari solusi dari papan minesweeper (baru dapat mengatasi yang 1 baris)

% Inisiasi fakta yang akan digunakan untuk mencari solusi
angka(8).
angka(7).
angka(6).
angka(5).
angka(4).
angka(3).
angka(2).
angka(1).
angka(0).

kurangi_satu(8,7).
kurangi_satu(7,6).
kurangi_satu(6,5).
kurangi_satu(5,4).
kurangi_satu(4,3).
kurangi_satu(3,2).
kurangi_satu(2,1).
kurangi_satu(1,0).

% Main Program
solve_minesweeper(Papan, Result) :- 
    cari_solusi(Papan), 
    Result = Papan.

% Inisiasi
cari_solusi([BarisPertama, BarisKedua | Tail]) :-
    cari_solusi(none, BarisPertama, BarisKedua, Tail).

% Handle kasus board '1 x N'
cari_solusi([Baris]) :-
    cari_solusi(none, Baris, none, []).

% Handle Board Baris Pertama
cari_solusi(none, BarisNow, BarisKedua, [NextBaris | Tail]) :-
    operasi_baris_pertama(BarisNow,BarisKedua),
    cari_solusi(BarisNow, BarisKedua, NextBaris, Tail).

% Handle Board Baris Pertama apabila kasus board '2 x N'
cari_solusi(none, BarisNow, BarisKedua, []) :-
    operasi_baris_pertama(BarisNow,BarisKedua),
    cari_solusi(BarisNow, BarisKedua, none, []).

% Handle Baris Pertama saat kasus '1 x N'
cari_solusi(none, BarisNow, none, []) :-
    [_ | BarisNowTail] = BarisNow,
    data_baris_tetangga([BarisNowTail, [0 | BarisNow]], Tetangga),
    handle_baris(BarisNow, Tetangga).

% Handle Baris Tengah
cari_solusi(BarisAtas, BarisNow, BarisBawah, [NextBaris | Tail]) :-
    operasi_baris_tengah(BarisAtas, BarisNow, BarisBawah),
    cari_solusi(BarisNow, BarisBawah, NextBaris, Tail).

% Handle Baris Sebelum Terakhir
cari_solusi(BarisAtas, BarisNow, BarisBawah, []) :-
    operasi_baris_tengah(BarisAtas, BarisNow, BarisBawah),
    cari_solusi(BarisNow, BarisBawah, none, []).

% Handle Baris Terakhir
cari_solusi(BarisAtas, BarisNow, none, []) :-
    [_ | BarisAtasTail] = BarisAtas,
    [_ | BarisNowTail] = BarisNow,
    data_baris_tetangga([[0 | BarisAtas], BarisAtas, BarisAtasTail,[0 | BarisNow], BarisNowTail], Tetangga),
    handle_baris(BarisNow, Tetangga).

operasi_baris_pertama(BarisNow,BarisKedua) :-
    [_ | BarisKeduaTail] = BarisKedua,
    [_ | BarisNowTail] = BarisNow,
    data_baris_tetangga([BarisKedua,[0 | BarisKedua],BarisKeduaTail,[0 | BarisNow],BarisNowTail], Tetangga),
    handle_baris(BarisNow, Tetangga).

operasi_baris_tengah(BarisAtas, BarisNow, BarisBawah) :-
    [_ | BarisAtasTail] = BarisAtas,
    [_ | BarisBawahTail] = BarisBawah,
    [_ | BarisNowTail] = BarisNow,
    data_baris_tetangga([BarisAtas, [0 | BarisAtas], BarisAtasTail,
            BarisBawah, [0 | BarisBawah], BarisBawahTail,
            [0 | BarisNow], BarisNowTail], Tetangga),
    handle_baris(BarisNow, Tetangga).

% Melakukan data_baris_tetangga pada board
data_baris_tetangga(All, []) :- isListKosong(All).
data_baris_tetangga(All, [NewBaris | Result]) :-
    isListTidakKosong(All),
    cari_tetangga(All, Newdata_baris_tetangga, NewBaris),
    data_baris_tetangga(Newdata_baris_tetangga, Result).

% Validasi list
isListKosong([]).
isListKosong([[] | Tail]) :- isListKosong(Tail).

isListTidakKosong([[_|_] | _]).
isListTidakKosong([[] | Tail]) :- isListTidakKosong(Tail).


cari_tetangga([], [], []).
cari_tetangga([[] | Barisbaris], [[] | Sisa], Kolom) :-
    cari_tetangga(Barisbaris, Sisa, Kolom).

cari_tetangga([[Elemen | Baris] | Barisbaris], [Baris | Sisa], [Elemen | Kolom]) :-
    cari_tetangga(Barisbaris, Sisa, Kolom).

handle_baris([], _).
handle_baris([Tile | Baris], [Tetangga | Lainnya]) :-
    handle_kotak_sekarang(Tile, Tetangga),
    handle_baris(Baris, Lainnya).


handle_kotak_sekarang('x', _).
handle_kotak_sekarang(0, []).
handle_kotak_sekarang(Angka, ['x' | Tetangga]) :-
    Angka \== 'x',
    kurangi_satu(Angka,NewAngka),
    handle_kotak_sekarang(NewAngka, Tetangga).

handle_kotak_sekarang(Angka, [AngkaTetangga | Tetangga]) :-
    Angka \== 'x',
    angka(Angka),
    angka(AngkaTetangga),
    handle_kotak_sekarang(Angka, Tetangga).