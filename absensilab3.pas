program absensilab3;
uses crt;

const
  BMAHASISWA := 23;
  BPERTEMUAN := 14;

type
  data = record
    nama : string[30];
    nim : string[9];
    kehadiran : 1..BPERTEMUAN;
    absen : 1..BPERTEMUAN;
    izin : 1..BPERTEMUAN;
    sakit : 1..BPERTEMUAN;
  end;

var
  absensi : array[1..22] of data;

//Fungsi

//Prosedurs

//Program Utama
begin
end.
