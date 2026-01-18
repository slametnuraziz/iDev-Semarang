Apa itu State Management?
Bayangkan aplikasi Flutter itu seperti rumah dengan banyak lampu dan parabotan. State management adalah cara kita mengatur "apa yang sedang menyala, apa yang mati, dan apa yang berubah" di rumah itu, supaya semua orang (widget) tahu kondisinya tanpa bingung. Tanpa state management, setiap lampu harus di cek satu per satu, ribet dan rawan.

Apa itu Cubit dan Bloc?
Ibarat asistem rumah tangga. Cubit itu assisten yang sederhana, kalau bilang "nyalakan lampu", dia langsung menyalakannya. Bloc lebih formal dan terstruktur. dia menerima event("nyalakan lampu"), memprosesnya dengan logika tertenty, lalu mengirim state baru ke seluruh rumah. Jadi, Cubit cepat dan ringn, Bloc labih disiplin dan cocok untuk aplikasi yang kompleks.

Dengan BLoC, logika dan UI dipisahkan rapi. UI hanya “menggambar” rumah sesuai instruksi, sementara BLoC menangani semua aturan lampu/perabotan. Jadi kalau ada error, kamu tinggal periksa BLoC tanpa harus ubah UI, atau ubah UI tanpa ganggu logikanya. Ini membuat maintainable dan scalable, apalagi untuk aplikasi besar.
