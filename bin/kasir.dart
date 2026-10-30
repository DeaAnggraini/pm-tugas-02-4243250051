import 'dart:io';

/// Mengubah angka menjadi format rupiah, contoh: 45000 -> Rp45.000
String rupiah(int n) {
  final s = n.toString();
  final buf = StringBuffer();
  for (var i = 0; i < s.length; i++) {
    // sisipkan titik setiap 3 digit dari kanan
    if (i > 0 && (s.length - i) % 3 == 0) buf.write('.');
    buf.write(s[i]);
  }
  return 'Rp$buf';
}

void main() {
  final Map<String, ({String nama, String kategori, int harga})> katalog = {
    'P01': (nama: 'Kopi Sidikalang 250 g', kategori: 'Kopi', harga: 45000),
    'P02': (nama: 'Kopi Gayo 250 g', kategori: 'Kopi', harga: 55000),
    'P03': (nama: 'Teh Kayu Aro 100 g', kategori: 'Teh', harga: 25000),
    'P04': (nama: 'Gula Aren 500 g', kategori: 'Pemanis', harga: 30000),
    'P05': (nama: 'Bolu Meranti', kategori: 'Makanan', harga: 80000),
  };

  // TODO 1: tampilkan katalog sebagai tabel rapi
  print('KATALOG TOKO OLEH-OLEH MEDAN');
  print('=' * 44);
  print('${'Kode'.padRight(6)}${'Nama'.padRight(26)}${'Harga'.padLeft(12)}');
  print('-' * 44);
  for (final e in katalog.entries) {
    final kode = e.key.padRight(6);
    final nama = e.value.nama.padRight(26);
    final harga = rupiah(e.value.harga).padLeft(12);
    print('$kode$nama$harga');
  }
  print('=' * 44);

  stdout.write('Pesanan (contoh: P01x2, P03x1): ');
  final String input = stdin.readLineSync() ?? '';

  // TODO 2 & 3: urai input dan validasi
  final List<({String nama, String kategori, int harga, int jumlah})> pesanan =
      [];
  final List<String> ditolak = [];

  for (final bagian in input.split(',')) {
    final item = bagian.trim();
    if (item.isEmpty) continue; // lewati bagian kosong, misal "P01x2,,P03x1"

    final pecah = item.toLowerCase().split('x');
    if (pecah.length != 2) {
      ditolak.add('$item (format salah)');
      continue;
    }

    final kode = pecah[0].trim().toUpperCase();
    final jumlah = int.tryParse(pecah[1].trim()); // int? (bisa null)
    final produk = katalog[kode]; // record? (bisa null)

    if (produk == null) {
      ditolak.add('$item (kode produk tidak ada)');
      continue;
    }
    if (jumlah == null || jumlah <= 0) {
      ditolak.add('$item (jumlah tidak valid)');
      continue;
    }

    // Setelah dua pengecekan di atas, compiler tahu produk dan jumlah
    // tidak null, jadi operator ! tidak diperlukan.
    pesanan.add((
      nama: produk.nama,
      kategori: produk.kategori,
      harga: produk.harga,
      jumlah: jumlah,
    ));
  }

  print('Valid: ${pesanan.length}, ditolak: $ditolak'); // sementara
}