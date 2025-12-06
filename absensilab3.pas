program absensilab3;
uses crt;

type
  data = record
    nama : string[30];
    nim : string[9];
    keaktifan : 0..14;
    absen : 0..14;
    izin : 0..14;
    sakit : 0..14;
  end;

var
  absensi : array[1..22] of data;

//Fungsi

//Prosedurs

//Program Utama
begin
end.
