============================================================
PANDUAN MENJALANKAN SERVER BACKEND (BIJI COFFEE SHOP)
============================================================

Aplikasi mobile ini membutuhkan server backend agar fitur Login, 
Register, dan CRUD Produk dapat berfungsi. 

Silakan ikuti langkah-langkah di bawah ini:

1. PERSIAPAN (PREREQUISITES)
Pastikan di komputer Anda sudah terinstall:
- Node.js (Minimal versi 14 ke atas).
  Cek dengan perintah di terminal: node -v
- NPM (Node Package Manager).
  Cek dengan perintah di terminal: npm -v

------------------------------------------------------------

2. INSTALASI LIBRARY
a. Buka Terminal atau Command Prompt (CMD).
b. Masuk ke folder backend yang sudah diekstrak:
   (Contoh: cd biji_coffee_backend)
c. Ketik perintah berikut lalu tekan Enter:
   
   npm install

   (Tunggu hingga proses selesai dan muncul folder 'node_modules')

------------------------------------------------------------

3. MENJALANKAN SERVER
Setelah instalasi selesai, jalankan server dengan perintah:

   node server.js

Jika berhasil, akan muncul pesan:
"Database SQLite terkoneksi & sinkron."
"Server berjalan di http://localhost:8000"

PENTING:
Jangan tutup terminal ini selama Anda menggunakan aplikasi mobile. 
Jika terminal ditutup, server akan mati.

------------------------------------------------------------

4. INFO TAMBAHAN
- Port Server: 8000
- Database: database.sqlite (Dibuat otomatis saat server jalan)
- IP Emulator Android: 10.0.2.2 (Gunakan ini di kodingan Flutter)
- IP Web/Browser: 127.0.0.1 atau localhost

------------------------------------------------------------

5. TROUBLESHOOTING (MASALAH UMUM)

Masalah: Error "Module not found"
Solusi: Anda belum menjalankan 'npm install'. Jalankan perintah itu dulu.

Masalah: Error "Address already in use"
Solusi: Port 8000 sedang dipakai aplikasi lain. Matikan aplikasi tersebut 
atau ubah angka PORT di file server.js, lalu restart server.

============================================================
