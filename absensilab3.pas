program absensilab3;
uses crt, sysutils;

const 
  BMAHASISWA = 23;
  BPERTEMUAN = 14;

type
  data = record
    nama      : string[40];
    nim       : string[9];
    kehadiran : string[BPERTEMUAN];
    hadir     : 0..BPERTEMUAN;
    absen     : 0..BPERTEMUAN;
    izin      : 0..BPERTEMUAN;
    sakit     : 0..BPERTEMUAN;
  end;
  kumpulandata = array[1..BMAHASISWA] of data;
   
var
  absensi_lab : kumpulandata;
  absensi_lab_tersimpan: kumpulandata;
  absensi : file of data;
  input : char;
  i, j : byte;

function Akumulasi(mahasiswa : data): data;
var
  j : byte;
begin
  Akumulasi := mahasiswa;
  with Akumulasi do
  begin
    hadir := 0;
    absen := 0;
    izin  := 0;
    sakit := 0;
    for j := 1 to BPERTEMUAN do
      case upcase(kehadiran[j]) of
        'H' : inc(hadir);
        'A' : inc(absen); 
        'I' : inc(izin);
        'S' : inc(sakit)
      end;
  end;
end;

procedure LoadKeBin;
begin
  Rewrite(absensi);
  for i := 1 to BMAHASISWA do write(absensi, absensi_lab[i]);
  Close(absensi);
end;

procedure LoadDariBin;
begin
  Reset(absensi);
  for i := 1 to BMAHASISWA do
  begin
    Read(absensi, absensi_lab_tersimpan[i]);
  end;
  Close(absensi);
end;

procedure Bantuan;
begin
  clrscr;
  writeln('Key Binding:');
  writeln('1. Enter     = next/lanjut');
  writeln('2. Esc       = exit/keluar program');
  writeln('3. Y         = Yes/Ya');
  writeln('4. N         = No/Tidak');
  writeln('5. Arrow key = navigasi untuk menu "Tampilkan Absen"');
  writeln;
  writeln('Kehadiran:');
  writeln('1. H = hadir');
  writeln('2. A = absen');
  writeln('3. I = izin');
  writeln('4. S = sakit');
  writeln;
  writeln('Menu:');
  writeln('1. Tampilkan Absen');
  writeln('   Menampilkan data tersimpan.');
  writeln('   a. Arrow key vertikal untuk mengubah pertemuan.');
  writeln('   b. Arrow key horizontal untuk mengubah mahasiswa.');
  writeln('2. Isi Absen:');
  writeln('   Mengisi kehadiran mahasiswa.');
  writeln('3. Reset:');
  writeln('   Mengosongkan data tersimpan.');
  writeln('   a. Kehadiran      = Hanya mengosongkan status kehadiran mahasiswa.');
  writeln('   b. Data Mahasiswa = Mengisi ulang seluruh data (termasuk Nama & NIM).');
  writeln('4. Bantuan:');
  writeln('   Menampilkan informasi dan penjelasan penggunaan.');
  readln;
end;

procedure IsiAbsen;
var pertemuanke : byte;
begin
  clrscr;
  repeat
  write('Pertemuan ke : '); readln(pertemuanke);
  until(pertemuanke >= 1) and (pertemuanke <= BPERTEMUAN);
  for i := 1 to BMAHASISWA do
  begin
    clrscr;
    with absensi_lab[i] do
    begin
      writeln(i, '/', BMAHASISWA);
      nama := absensi_lab_tersimpan[i].nama;
      nim := absensi_lab_tersimpan[i].nim;
      writeln('Nama      : ', nama);
      writeln('NIM       : ', nim);
      repeat
      write('Kehadiran : '); readln(kehadiran[pertemuanke]);
      gotoxy(1, 4);
      clreol;
      until(upcase(kehadiran[pertemuanke]) = 'H') or (upcase(kehadiran[pertemuanke]) = 'I') or
      (upcase(kehadiran[pertemuanke]) = 'S') or (upcase(kehadiran[pertemuanke]) = 'A');
    end;
    absensi_lab[i] := Akumulasi(absensi_lab[i]);
  end;
  repeat
  clrscr;
  write('Simpan perubahan? (Y/N) ');
  input := readkey;
  if (upcase(input) = 'Y') then LoadKeBin;
  until (upcase(input) = 'Y') or (upcase(input) = 'N');
end;

procedure ResetAbsen;
begin
  clrscr;
  writeln('1. Reset Kehadiran');
  writeln('2. Reset Data Mahasiswa');
  input := readkey;
  for i := 1 to BMAHASISWA do
  begin
    with absensi_lab[i] do
    begin
      clrscr;
      writeln(i, '/', BMAHASISWA);
      if (input = '2') then
      begin
        write('Nama : '); readln(nama);
        write('NIM  : '); readln(nim);
      end
      else
      begin
        nama := absensi_lab_tersimpan[i].nama;
        nim  := absensi_lab_tersimpan[i].nim;
      end;
      kehadiran := #00;
    end;
    for j := 1 to BPERTEMUAN do absensi_lab[j] := Akumulasi(absensi_lab[j]);
  end;
  repeat
  clrscr;
  write('Simpan perubahan? (Y/N) ');
  input := readkey;
  if (upcase(input) = 'Y') then LoadKeBin;
  until (upcase(input) = 'Y') or (upcase(input) = 'N');
end;

procedure TampilkanAbsen;
begin
  LoadDariBin;
  i := 1;
  j := 1;
  repeat
  clrscr;
  writeln(i, '/', BMAHASISWA);
  with (absensi_lab_tersimpan[i]) do
  begin
    Writeln('Nama        : ', nama);
    Writeln('NIM         : ', nim);
    writeln('Pertemuan ', j,' : ', upcase(kehadiran[j]));
    writeln;
    writeln('Akumulasi');
    writeln('Hadir       : ', hadir);
    Writeln('Absen       : ', absen);
    Writeln('Sakit       : ', sakit);
    writeln('Izin        : ', izin);
  end; 
  input := readkey;
  case input of
    #72 : if (j < BPERTEMUAN) then inc(j);
    #80 : if (j > 1) then dec(j);
    #75 : if (i > 1) then dec(i);
    #77 : if (i < BMAHASISWA) then inc(i);
  end;
  until(input = #13) or (input = #10);
end;

begin
  assign(absensi, 'AbsensiLab3Base.bin');
  LoadDariBin;
  repeat
  clrscr;
  writeln('1. Tampilkan Absen');
  writeln('2. Isi Absen');
  writeln('3. Reset Absen');
  writeln('4. Bantuan');
  input := readkey;
  case input of
  '1' : TampilkanAbsen;
  '2' : isiAbsen;
  '3' : resetAbsen;
  '4' : bantuan;
  end;
  until(input = #27);
end.
