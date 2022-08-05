{
  ## Tugas Besar Algoritma dan Pemrograman
Program ATM Sederhana

Nama anggota:
1. Bagas Setyawan             (222111947)
2. Muhammad Diva Amrullah     (222112210)
3. Muhammad Nur Alfian Syarif (222112218)

Program ATM sederhana menggunakan Pascal mengadopsi program ATM sebenarnya dengan menu sebagai berikut :
- Menu utama
- Transfer
- Setor tunai
- Penarikan tunai
- Pembayaran/pembelian
- Top Up e-Wallet
- Informasi saldo
- Ubah PIN
- Registrasi

Pengguna awal yang sudah terdaftar
| Nama  | Rekening  |  PIN   |  Saldo  |
| ----- | --------- | ------ | ------- |
| Wahyu | 112112210 | 222789 | 500000  |
| Rani  | 212112210 | 333789 | 1000000 |
| Rudi  | 222112210 | 111789 | 100000  |

}

program tubesATM;
uses crt, sysUtils;

type
  str = string[20];
  recordPengguna = record
    PIN       : string[6];
    norek     : str;
    saldo     : longword;
    nama      : str
  end;


var
  pengguna   : array[1..256] of recordPengguna;
  banyakData : byte = 3;
  i: byte;
  YY, MM, DD:Word;
  kodeBank : string[3];

function cariIndeks(norek : string) : byte;
  { menggunakan pencarian biner pada array pengguna yang berurutan }
  var
    kiri, tengah, kanan : integer;
  begin
    kiri:=1;
    kanan:=banyakData;

    while kiri<=kanan do
      begin
        tengah:=(kiri+kanan) div 2;
        if pengguna[tengah].norek>norek then kanan:=tengah-1
        else if pengguna[tengah].norek<norek then kiri:=tengah+1
        else break;
      end;

    if pengguna[tengah].norek=norek then cariIndeks:=tengah
    else cariIndeks:=0;
  end;


function terautentikasi(target : recordPengguna) : boolean;
  var
    ulang    : byte;
    inputPIN : string[6];
  begin
    ulang:=0;
    
    repeat
      write('Masukkan PIN: ');
      readln(inputPIN);

      if inputPIN=target.PIN then exit(true)
      else ulang:=ulang+1;
    until ulang=3;

    terautentikasi:=false;
  end;

//Subprogram-subprogram untuk Cetak Resi
function getRandom(n:integer): str;
var
  x : byte;
begin
  randomize; {to initialize the random number generator}
  for x := 1 to n do
    write(random(9));
end;

//Bagian header Resi
procedure headerResi;
begin
    clrscr;
    writeln('=========================================');
    writeln(
'           ___  ____________ ' + LineEnding + 
'          / _ \ | ___ \  _  \' + LineEnding +
'         / /_\ \| |_/ / | | |' + LineEnding +
'         |  _  || ___ \ | | |' + LineEnding +
'         | | | || |_/ / |/ /'  + LineEnding +
'         \_| |_/\____/|___/' + LineEnding +
'                           ');
    writeln('=========================================');
    
    DeCodeDate (Date, YY, MM, DD);
    GoToXY(1,10);
    writeln (format ('Tanggal  : %d/%d/%d ',[dd, mm, yy]));
    GoToXY(23,10);
    writeln ('Waktu     : ',TimeToStr(Time));
    GoToXY(1,11);
    writeln('ATM ID   : ', getRandom(4),'');
    GoToXY(23,11);
    writeln('No. REF   : ', getRandom(3),'');
    writeln('Lokasi   : POLITEKNIK STATISTIKA STIS');
    writeln('No.Kartu : ', getRandom(6),'..',getRandom(4),'');
end;


//Resi untuk Transfer
procedure resiTrans(pengirim, bankPenerima ,penerima, nomRek : str; tf, adminFee: longword);
var 
  jumlahTf  : longword;
begin 
    headerResi;
    //Aksi yang dilakukan (transfer. cek saldo)
    //Misal Transfer
    GoToXY(20,15);
    writeln('Transfer');
    writeln;
    writeln('DARI BANK   : BANK ABD');
    writeln('Nama        : ', pengirim);
    writeln('KEPADA BANK : BANK ', bankPenerima);
    if (penerima <> '') then
      writeln('Nama        : ', penerima);
    
    writeln('Rekening    : ', nomRek);

    writeln('=========================================');
    writeln('Transfer    : Rp. ', tf);
    writeln('Biaya Admin : Rp. ', adminFee);
    jumlahTf := adminFee + tf;
    writeln('Jumlah      : Rp. ', jumlahTf);
    writeln('=========================================');
end;

//Resi untuk E-Wallet
procedure resiEwallet(aksi: byte ; kode:str; jumlahTU:longword);
const 
  admin = 2000;
var
    jenis : str;
    totalBayar : longword;
begin
    headerResi;
    case aksi of 
      1 : jenis:= 'Dana';
      2 : jenis := 'Gopay';
      3 : jenis := 'Shopeepay'
    end;

    GoToXY(1,15);
    writeln('Status         : BERHASIL');
    GoToXY(1,16);
    writeln('Kode Transaksi : ', kode);
    writeln('Pembelian      : TOP UP ', jenis);
    writeln('=========================================');
    writeln('TOP UP         : Rp.', jumlahTU);    
    writeln('Biaya admin    : Rp.', admin);
    totalBayar := admin+jumlahTU;
    writeln('Total Dibayar  : Rp.', totalBayar);    
end;

//Cetak Resi Pembayaran
procedure resiPembayaran(aksi, pihak, kode:str; tagihan,admin:longword);
var 
    total   : longword;
    
begin
    headerResi;
    writeln('=========================================');
    GoToXY(6,15);
    writeln('Struk Pembayaran ', aksi);
    writeln('=========================================');
    writeln('Kode Transaksi: ', kode);
    writeln('Jumlah Tagihan: Rp.', tagihan);
    writeln('Biaya Admin   : Rp.', admin);
    total := tagihan + admin;
    writeln('Total Dibayar : Rp.', total);
    writeln(pihak, ' Menyatakan Struk Ini Sebagai Bukti');
    writeln('Pembayaran Yang Sah');
end;

//Cetak Resi Pembelian
procedure resiPembelian(aksi, no : str; jumlahIsi, admin : longword);
var 
    totalBayar : longword;
begin
    headerResi;
    writeln('=========================================');
    GoToXY(6,15);
    writeln('Struk Pembelian ', aksi);
    writeln('=========================================');
    writeln('Pembelian      : ', aksi);
    if (LowerCase(aksi) = 'token listrik') then 
        begin
            writeln('No. Token         : ', no);
            writeln('Pulsa Listrik     : ', jumlahIsi);
        end
    else if (LowerCase(aksi) = 'pulsa') then 
        writeln('No. Handphone  : ', no);
    totalBayar := admin + jumlahIsi;
    writeln('Biaya Admin    : Rp.', admin);
    writeln('Total Dibayar  : Rp.', totalBayar);
end;

//Cetak Resi cek saldo
procedure resiSaldo(saldo:LongInt);
begin 
    headerResi;
    writeln('=========================================');
    
    writeln('             Informasi Saldo            ');
    writeln('=========================================');
    writeln('Jumlah Saldo   : ', saldo);
end;

//End of Cetak resi
procedure tampil_kode;
begin
    writeln('Silakan memilih kode bank tujuan anda');
    writeln('==========================');
    writeln('| No | Nama Bank  | Kode |');
    writeln('==========================');
    writeln('| 1  | Bank ABC   | 123  |');
    writeln('| 2  | Bank CAB   | 321  |');
    writeln('| 3  | Bank BCA   | 213  |');
    writeln('| 4  | Bank ACB   | 132  |');
    writeln('| 5  | Bank BCD   | 122  |');
    writeln('| 6  | Bank ASW   | 234  |');
    writeln('| 7  | Bank ASD   | 232  |');
    writeln('| 8  | Bank BNP   | 233  |');
    writeln('| 9  | Bank BDP   | 432  |');
    writeln('==========================');  
end;
procedure masuk_kode;
  var
    bank, kode_bank : string[3];
  begin
    write('Masukkan Kode Bank yang dituju');
            read(kode_bank);
            repeat
            case kode_bank of
            '123': bank:='ABC';
            '321': bank:='CAB';
            '213': bank:='BCA';
            '132': bank:='ACB';
            '122': bank:='BCD';
            '234': bank:='ASW';
            '232': bank:='ASD';
            '233': bank:='BNP';
            '432': bank:='BDP';
            else bank:= '';
            end;
            readln;
            until (bank<>'');
            writeln('Bank yang akan anda tuju adalah : ',bank);
            kodeBank := bank;
            
  end;

procedure transfer(var asal : recordPengguna);
  var
    bank, tujuan, pil : byte;
    antarbank         : boolean;
    norekTujuan       : string[16];
    nominal           : longword;
    biayaAdmin        : longword = 2000;
    pilKode           : string[1];
  begin          
    repeat
      clrscr;
      writeln('===( TRANSFER )===');
      writeln('Pilih Nomor Bank Rekening Tujuan');
      writeln('  1. Bank ABD');
      writeln('  2. Bank lain');
      writeln('  3. Kembali ke Menu Utama');
      write('Pilihan: ');
      readln(pil);

      case pil of
        1: antarbank:=false;
        2: antarbank:=true;
        3: exit;
        else continue;
      end;
    until (bank=1) or (bank=2);

    

    if antarbank then
      begin
        write('Tampilkan Kode Bank (Y/T)');readln(pilKode);
        if (UpperCase(pilKode) = 'Y') then tampil_kode;
        masuk_kode;
        write('Masukkan rekening tujuan : ');
        readln(norekTujuan);
        write('Masukkan nominal transfer: ');
        readln(nominal);
        writeln('Biaya admin   : ', biayaAdmin);
        nominal:=nominal+biayaAdmin
      end
    else
      begin
        write('Masukkan rekening tujuan : ');
        readln(norekTujuan);
        write('Masukkan nominal transfer: ');
        readln(nominal);
        tujuan:=cariIndeks(norekTujuan);
        if tujuan=0 then
          begin
            writeln('Tidak dapat menemukan rekening tujuan!');
            exit;
          end
        else pengguna[tujuan].saldo:=pengguna[tujuan].saldo+nominal;
      end;
    
    if nominal > asal.saldo then
      begin
        writeln('Saldo tidak mencukupi!');
        exit;
      end;

    asal.saldo:=asal.saldo-nominal;
    clrscr;
    GoToXY(40,8);
    writeln('Transaksi Anda Sedang Diproses');
    delay(3000);
    clrscr;
    GoToXY(45,8);
    writeln('Silahkan Ambil Struk');
    delay(2000);
    clrscr;
    if not antarbank then 
    resiTrans(asal.nama,'ABD',pengguna[tujuan].nama, norekTujuan, nominal, biayaAdmin)
    else resiTrans(asal.nama,kodeBank, '' , norekTujuan, nominal, biayaAdmin)
    // writeln('Saldo sekarang: ', asal.saldo);
  end;


procedure tarikTunai(var target : recordPengguna);
  var
    nominal : longword;
  begin
    clrscr;
    writeln('===( PENARIKAN TUNAI )===');
    write('Masukkan nominal: ');
    readln(nominal);

    if nominal > target.saldo then writeln('Saldo tidak mencukupi!')
    else if (nominal mod 50000) <> 0 then
      writeln('Hanya dapat melakukan penarikan kelipatan 50.000!')
    else
      begin
        target.saldo:=target.saldo-nominal;
        writeln('Berhasil melakukan penarikan!');
        writeln('Silahkan Ambil Uang Anda');
        delay(3000);
        clrscr;
      end;
  end;

//Setor Tunai
procedure setor_tunai(var target : recordPengguna);
var 
  setor:longword;
begin
    write('Masukkan saldo yang ingin anda setor (kelipatan 50000) =');
    readln(setor);
    writeln('Transaksi Anda Sedang Diproses');
    delay(3000);
    if (setor mod 50000<>0) then 
        writeln('Setor tunai hanya bisa dengan kelipatan 50000')
    else
      begin
        writeln('Berhasil Melakukan Setoran'); 
        target.saldo:= target.saldo+setor;
      end;
end;


procedure barbel(var target : recordPengguna);
  procedure bpjs;
    var
      nomorPeserta : string[11];
      kodeTransaksi: str;
      nominal,admin      : longword;
    begin
      clrscr;
      admin := 0;
      writeln('===( PEMBAYARAN BPJS )===');
      write('Masukkan nomor BPJS        : ');
      readln(nomorPeserta);
      write('Masukkan nominal pembayaran: ');
      readln(nominal);

      if nominal>target.saldo then writeln('Saldo tidak mencukupi!')
      else 
        begin
          target.saldo:=target.saldo-nominal;
          kodeTransaksi := '88888' + nomorPeserta;
          clrscr;
          GoToXY(45,8);
          writeln('Silahkan Ambil Struk');
          delay(2000);
          clrscr;
          resiPembayaran('BPJS', 'BPJS', kodeTransaksi, nominal, admin);
          // writeln('Berhasil melakukan transaksi!');
          // writeln('Kode transaksi: ', '88888'+nomorPeserta);
          // writeln('Saldo sekarang: ', target.saldo);
        end;
    end;


  procedure tagihanListrik;
    var
      nomorMeter : string[12];
      nominal    : longword;
      biayaAdmin : longword = 3000;
      kodeTransaksi : str;
    begin
      clrscr;
      writeln('===( PEMBAYARAN TAGIHAN LISTRIK )===');
      write('Masukkan nomor meter       : ');
      readln(nomorMeter);
      write('Masukkan nominal pembayaran: ');
      readln(nominal);

      if nominal>target.saldo then writeln('Saldo tidak mencukupi!')
      else 
        begin
          target.saldo:=target.saldo-nominal-biayaAdmin;
          kodeTransaksi := '99999' + nomorMeter;
          clrscr;
          GoToXY(45,8);
          writeln('Silahkan Ambil Struk');
          delay(2000);
          clrscr;
          resiPembayaran('Listrik', 'PLN', kodeTransaksi, nominal, biayaAdmin);
        end;
    end;


  procedure tokenListrik;
    function buatToken : string;
      var
        i     : byte;
        token : str = '';
      begin
        {
        * membuat token listrik yang terdiri atas 16 digit karakter
        * numerik dengan menyusun string dari karakter acak dalam
        * range '0' (ascii 48) sampai '9' (ascii 57) dan memberi spasi
        * setiap 4 digit
        * }
        for i:=1 to 24 do
          begin
            if (i mod 5)=0 then token:=token+' '
            else token:=token+chr(random(10)+48);
          end;
        buatToken:=token;
      end;


    var
      nomorMeter : string[12];
      pulsa      : byte;
      token      : str;
      nominal    : longword;
      biayaAdmin : longword = 2500;
    begin
      clrscr;
      writeln('===( PEMBELIAN TOKEN LISTRIK )===');
      write('Masukkan nomor meter: ');
      readln(nomorMeter);
      repeat
        writeln('Silakan pilih nomor dari nominal pulsa');
        writeln('  1. 20.000');
        writeln('  2. 50.000');
        writeln('  3. 100.000');
        writeln('  4. 200.000');
        writeln('  5. 500.000');
        writeln('  6. 1.000.000');
        writeln('  7. Kembali ke Menu Utama');
        write('Pilihan: ');
        readln(pulsa);
      until (pulsa>=1) and (pulsa<=7);

      case pulsa of
        1: nominal:=20000;
        2: nominal:=50000;
        3: nominal:=100000;
        4: nominal:=200000;
        5: nominal:=500000;
        6: nominal:=1000000;
        7: exit;
      end;

      if nominal>target.saldo then writeln('Saldo tidak mencukupi!')
      else
        begin
          token:=buatToken;
          target.saldo:=target.saldo-nominal-biayaAdmin;
          clrscr;
          GoToXY(45,8);
          writeln('Silahkan Ambil Struk');
          delay(2000);
          clrscr;
          resiPembelian('token listrik', token, nominal, biayaAdmin);
          // writeln('Berhasil melakukan transaksi!');
          // writeln('Token listrik : ', token);
          // writeln('Pulsa listrik : ', nominal);
          // writeln('Biaya admin   : ', biayaAdmin);
          // writeln('Saldo sekarang: ', target.saldo);
        end;
    end;


  procedure pulsa;
    var
      nope       : string[13];
      nominal    : longword;
      biayaAdmin : longword = 1500;
    begin
      clrscr;
      writeln('===( PEMBELIAN PULSA HP )===');
      write('Masukkan nomor hp         : ');
      readln(nope);
      write('Masukkan nominal pembelian: ');
      readln(nominal);

      if nominal>target.saldo then writeln('Saldo tidak mencukupi!')
      else if (nominal mod 5000) <> 0 then
        writeln('Hanya dapat melakukan pembelian pulsa kelipatan 5.000!')
      else
        begin
          GoToXY(45,8);
          writeln('Transaksi Sedang Diproses');
          delay(3000);
          writeln('Pembelian Berhasil!');
          target.saldo:=target.saldo-nominal-biayaAdmin;
          clrscr;
          GoToXY(45,8);
          writeln('Silahkan Ambil Struk');
          delay(2000);
          clrscr;
          resiPembelian('pulsa', nope, nominal, biayaAdmin);
          // writeln('Berhasil melakukan penarikan!');
          // writeln('Biaya admin   : ', biayaAdmin);
          // writeln('Saldo sekarang: ', target.saldo);
        end;
    end;


  var
    pil : byte;
  begin
    repeat
      clrscr;
      writeln('===( PEMBAYARAN/PEMBELIAN )===');
      writeln('Silakan pilih nomor menu');
      writeln('  1. Bayar BPJS');
      writeln('  2. Bayar Tagihan Listrik');
      writeln('  3. Beli Token Listrik');
      writeln('  4. Beli Pulsa HP');
      writeln('  5. Kembali ke Menu Utama');
      write('Pilihan: ');
      readln(pil);

      case pil of
        1: bpjs;
        2: tagihanListrik;
        3: tokenListrik;
        4: pulsa;
        5: exit;
      end;
    until (pil>=1) and (pil<=4);
  end;


procedure eWallet(var target : recordPengguna);
  var
    dompet        : byte;
    kodetransaksi : string[5];
    nope          : string[13];
    kodeTrans     : str;
    biayaAdmin    : longword = 2000;
    nominal       : longword;
  begin
    repeat
      clrscr;
      writeln('===( E-WALLET )===');
      writeln('Silakan pilih nomor dompet digital');
      writeln('  1. Dana');
      writeln('  2. Gopay');
      writeln('  3. Shopeepay');
      writeln('  4. Kembali ke Menu Utama');
      write('Pilihan: ');
      readln(dompet);
  
      case dompet of
        1: kodeTransaksi:='74240';
        2: kodeTransaksi:='60747';
        3: kodeTransaksi:='50733';
        4: exit;
      end;
    until (dompet>=1) and (dompet<=3);

    write('Masukkan nomor handphone  : ');
    readln(nope);
    write('Masukkan nominal pengisian: ');
    readln(nominal);

    if nominal>target.saldo then writeln('Saldo tidak mencukupi!')
    else
      begin
        target.saldo:=target.saldo-nominal-biayaAdmin;
        kodeTrans := kodeTransaksi + nope;
        clrscr;
        GoToXY(45,8);
        writeln('Silahkan Ambil Struk');
        delay(2000);
        clrscr;
        resiEwallet(dompet, kodeTrans, nominal);
        // writeln('Biaya admin   : ', biayaAdmin);
        // writeln('Saldo sekarang: ', target.saldo);
      end;
  end;


procedure infoSaldo(target : recordPengguna);
  begin
    clrscr;
    writeln('===( INFORMASI SALDO )===');
    writeln('Nomor Rekening: ', target.norek);
    writeln('Saldo         : ', target.saldo);
    delay(5000);
    clrscr;
    GoToXY(45,8);
    writeln('Silahkan Ambil Struk');
    delay(2000);
    clrscr;
    resiSaldo(target.saldo);
  end;


function validPIN(inputPIN : string) : boolean;
  var
    hasil : boolean;
    digit : char;
  begin
    if length(inputPIN)<>6 then hasil:=false
    else
      begin
        hasil:=true;
        for digit in inputPIN do
          if not (digit in ['0'..'9']) then hasil:=false;
      end;
    validPIN:=hasil;
  end;


function ubahPIN(var target : recordPengguna; penggunaBaru : boolean) : boolean;
  var
    PINbaru, PINbaru2 : string[6];
  begin
    
    write('Masukkan 6 digit PIN baru: ');
    readln(PINbaru);
    write('Konfirmasi PIN baru      : ');
    readln(PINbaru2);

    if not penggunaBaru then
      begin
        writeln('Masukkan PIN lama untuk konfirmasi!');
        if not terautentikasi(target) then
          begin
            writeln('Gagal mengautentikasi, batal mengubah PIN!');
            exit(false);
          end;
      end;

    if (PINbaru=PINbaru2) and validPIN(PINbaru) then
      begin
        target.PIN:=PINbaru;
        ubahPIN:=true;
      end
    else ubahPIN:=false;
  end;


procedure registrasi;
  function buatNorek : string;
    var
      i     : byte;
      norek : string[9] = '';
    begin
      {
      * membuat nomor rekening yang terdiri atas 9 digit karakter
      * numerik dengan menyusun string dari karakter acak dalam
      * range '0' (ascii 48) sampai '9' (ascii 57)
      * }
      for i:=1 to 9 do norek:=norek+chr(random(10)+48);
      buatNorek:=norek;
    end;


  procedure urutkanData;
    var
      i   : byte;
      tmp : recordPengguna;
    begin
      { menggunakan insertion sort pada array pengguna }
      for i:=banyakData downto 2 do
        if pengguna[i].norek<pengguna[i-1].norek then
          begin
            tmp:=pengguna[i];
            pengguna[i]:=pengguna[i-1];
            pengguna[i-1]:=tmp;
          end;
    end;


  var
    norek : string[9];
  begin
    clrscr;
    writeln('===( REGISTRASI )===');
    banyakData:=banyakData+1;

    repeat norek:=buatNorek until cariIndeks(norek)=0;
    pengguna[banyakData].norek:=norek;
    writeln('Nomor rekening Anda: ', pengguna[banyakData].norek);
    writeln('Silakan buat PIN untuk rekening Anda');
    
    repeat 
      ubahPIN(pengguna[banyakData], true) until validPIN(pengguna[banyakData].PIN);
    pengguna[banyakData].saldo:=0;
    urutkanData;
    clrscr;
    GoToXY(45,8);
    writeln('Registrasi Sedang Diproses');
    delay(3000);
    clrscr;
    GoToXY(40,8);
    writeln('Berhasil membuat rekening!');
  end;


procedure selesai; 
const 
    kalimat1 = 'Silakan Ambil Kartu Anda';
begin
    headerResi;
    writeln('=========================================');
    GoToXY(6,15);
    writeln('Struk Pembelian ', aksi);
    writeln('=========================================');
    writeln('Pembelian      : ', aksi);
    if (LowerCase(aksi) = 'token listrik') then 
        begin
            writeln('No. Token         : ', no);
            writeln('Pulsa Listrik     : ', jumlahIsi);
        end
    else if (LowerCase(aksi) = 'pulsa') then 
        writeln('No. Handphone  : ', no);
    totalBayar := admin + jumlahIsi;
    writeln('Biaya Admin    : ', admin);
    writeln('Total Dibayar  : ', totalBayar);
end;

//Cetak Resi cek saldo
procedure resiSaldo(saldo:LongInt);
begin 
    headerResi;
    writeln('=========================================');
    
    writeln('             Informasi Saldo            ');
    writeln('=========================================');
    writeln('Jumlah Saldo   : ', saldo);
end;
//End of Cetak resi

procedure transfer(var asal : recordPengguna);
  var
    bank, tujuan, pil : byte;
    antarbank         : boolean;
    norekTujuan       : string[16];
    nominal           : longword;
    biayaAdmin        : longword = 2000;
  begin          
    repeat
      clrscr;
      writeln('===( TRANSFER )===');
      writeln('Pilih Nomor Bank Rekening Tujuan');
      writeln('  1. Bank ABD');
      writeln('  2. Bank lain');
      writeln('  3. Kembali ke Menu Utama');
      write('Pilihan: ');
      readln(pil);

      case pil of
        1: antarbank:=false;
        2: antarbank:=true;
        3: exit;
        else continue;
      end;
    until (bank=1) or (bank=2);

    write('Masukkan rekening tujuan : ');
    readln(norekTujuan);
    write('Masukkan nominal transfer: ');
    readln(nominal);

    if nominal > asal.saldo then
      begin
        writeln('Saldo tidak mencukupi!');
        exit;
      end
    else if antarbank then
      begin
        writeln('Biaya admin   : ', biayaAdmin);
        nominal:=nominal+biayaAdmin
      end
    else
      begin
        tujuan:=cariIndeks(norekTujuan);
        if tujuan=0 then
          begin
            writeln('Tidak dapat menemukan rekening tujuan!');
            exit;
          end
        else pengguna[tujuan].saldo:=pengguna[tujuan].saldo+nominal;
      end;

    asal.saldo:=asal.saldo-nominal;
    clrscr;
    GoToXY(45,7);
    TEXTCOLOR(RED+BLINK);
    writeln(kalimat1);
    delay(2000);
    clrscr;
end;

//Infor Lain
procedure infoLain;
const kalimat1 = '||   Terimakasih Sudah Menggunakan ATM ABD   ||';
const kalimat2 = '||Dukungan Anda Sangat Berarti Untuk Tim Kami||';
const anggota1 = '*Bagas Setyawan*';
const anggota2 = '*Muhammad Diva Amrullah*';
const anggota3 = '*Muhammad Nur Alfian Syarif*';
const copyright = '*copyright ABD TEAM*';

var
    i:integer;
begin
    GotoXY(33, 5);
    writeln('===============================================');
    GotoXY(33, 6);
    for i:=1 to Length(kalimat1) do
        begin
            write(kalimat1[i]);
            delay(25);
        end;
    
    GotoXY(33, 7);
    for i:= 1 to Length(kalimat2) do
        begin
            write(kalimat2[i]);
            delay(25);
        end;
    GotoXY(33,8);
    writeln('===============================================');
    
    GotoXY(52, 10);
    for i:=1 to Length(anggota1) do
        begin
            write(anggota1[i]);
            delay(25);
        end;
        
    GotoXY(48, 11);
    for i:=1 to Length(anggota2) do
        begin
            write(anggota2[i]);
            delay(25);
        end;
    GotoXY(46,12);
    for i:=1 to Length(anggota3) do
        begin  
            write(anggota3[i]);
            delay(25);
        end;
    GotoXY(49,13);
    for i:= 1 to Length(copyright) do
        begin
            write(copyright[i]);
            delay(25);
        end;
end;


procedure menuUtama;
  var
    pil, sah : byte;
    norek    : string[9];
  begin
    repeat
      clrscr;
      GoToXY(37,5);
      writeln('Selamat datang di ATM ABD!');
      GoToXY(20,7);
      writeln('  1. Transfer');
      GoToXY(20,8);
      writeln('  2. Penarikan tunai');
      GoToXY(20,9);
      writeln('  3. Pembayaran/pembelian');
      GoToXY(20,10);
      writeln('  4. TOP-UP e-Wallet');
      GoToXY(60,7);
      writeln('  5. Informasi saldo');
      GoToXY(60,8);
      writeln('  6. Ubah PIN');
      GoToXY(60,9);
      writeln('  7. Registrasi');
      GoToXY(60,10);
      writeln('  8. Setor Tunai');
      GoToXY(100,7);
      writeln('  9. Keluar');
      GoToXY(40,12);
      write('Masukkan nomor menu: ');
      readln(pil);
      clrscr;
      if pil=9 then 
        begin
            clrscr;
            infoLain;
            delay(500);
            clrscr;
            selesai;
            break;
        end;
      if (pil<1) or (pil>8) then continue;
      if pil=7 then
        begin
          registrasi;
          write('Enter untuk melanjutkan');
          readln;
          continue;
        end;
      
      write('Masukkan nomor rekening: ');
      readln(norek);

      { mencari indeks nomor rekening dari pengguna yang sah }
      sah:=cariIndeks(norek);
      if sah=0 then
        begin
          GoToXY(50,9);
          writeln('Nomor rekening tidak ditemukan. Harap Registrasi Terlebih Dahulu!');
          GoToXY(50,10);
          write('Enter untuk melanjutkan');
          readln;
          continue;
        end;

      { meminta PIN pengguna sebelum melakukan transaksi }
      if not terautentikasi(pengguna[sah]) then 
        begin
          GoToXY(50,9);
          writeln('Gagal mengautentikasi!');
          GoToXY(50,10);
          write('Enter untuk melanjutkan');
          readln;
          continue;
        end;

      case pil of
        1: transfer(pengguna[sah]);
        2: tarikTunai(pengguna[sah]);
        3: barbel(pengguna[sah]);
        4: eWallet(pengguna[sah]);
        5: infoSaldo(pengguna[sah]);
        6: begin
            clrscr;
            writeln('===( UBAH PIN )===');
            if ubahPIN(pengguna[sah], false) then writeln('Berhasil mengubah PIN!')
            else writeln('Gagal mengubah PIN!');
          end;
        8 : setor_tunai(pengguna[sah]);
      end;

      write('Enter untuk melanjutkan');
      readln;
    until false;
  end;


begin
  { daftar pengguna berdasarkan nomor rekening }
  pengguna[1].norek    :='112112210';
  pengguna[1].PIN      :='222789';
  pengguna[1].saldo    := 500000;
  pengguna[1].nama    := 'Wahyu';
  pengguna[2].norek    :='212112210';
  pengguna[2].PIN      :='333789';
  pengguna[2].saldo    :=1000000;
  pengguna[2].nama    := 'Rani';
  pengguna[3].norek    :='222112210';
  pengguna[3].PIN      :='111789';
  pengguna[3].saldo    :=100000;
  pengguna[3].nama    :='Rudi';
  clrscr;
  GoToXY(37,8);
  writeln('Masukkan Kartu ATM (Tekan Enter)');readln;
  clrscr;
  GoToXY(45,8);
  writeln('Tunggu Sebentar');
  delay(2000);
  clrscr;
  menuUtama;
  clrscr;
end.
