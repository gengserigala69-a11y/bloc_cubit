# Category Feature - Flutter BLoC CRUD

## Struktur File

```
lib/category/
├── bloc/
│   ├── category_bloc.dart     ← BLoC utama (event handler)
│   ├── category_event.dart    ← Semua event (part of bloc)
│   └── category_state.dart    ← Semua state (part of bloc)
├── models/
│   └── category_model.dart    ← Model data
├── repository/
│   └── category_repository.dart ← HTTP API calls
└── view/
    ├── category_view.dart       ← Halaman list + delete dialog
    ├── add_category_page.dart   ← Halaman tambah
    └── edit_category_page.dart  ← Halaman edit
```

---

## Setup

### 1. pubspec.yaml — pastikan dependensi ini ada

```yaml
dependencies:
  flutter_bloc: ^8.1.3
  http: ^1.1.0
```

### 2. Repository — sesuaikan BASE URL & token

Buka `repository/category_repository.dart` dan ubah:

```dart
static const String _baseUrl = 'https://your-api.com/api';
```

Dan ubah cara ambil token sesuai project Anda (SharedPreferences, flutter_secure_storage, dll):

```dart
Future<Map<String, String>> _getHeaders() async {
  final prefs = await SharedPreferences.getInstance();
  final token = prefs.getString('token') ?? '';
  return {
    'Content-Type': 'application/json',
    'Authorization': 'Bearer $token',
  };
}
```

### 3. Daftarkan routes di MaterialApp

```dart
MaterialApp(
  routes: {
    '/category':      (_) => const CategoryView(),
    '/add-category':  (_) => const AddCategoryPage(),
    '/edit-category': (_) => const EditCategoryPage(),
    // ...route lain
  },
);
```

---

## Alur Navigasi

```
CategoryView (/category)
├── Klik "Tambah Kategori"
│   └── pushNamed('/add-category')
│       └── Submit → CategoryCreate event
│           └── pop(true) → CategoryView reload
│
├── Klik tombol edit (hijau)
│   └── pushNamed('/edit-category', arguments: category)
│       └── Submit → CategoryUpdate event
│           └── pop(true) → CategoryView reload
│
└── Klik tombol delete (merah)
    └── Dialog konfirmasi
        └── Klik "Hapus" → CategoryDelete event
            └── List update otomatis
```

---

## State yang Tersedia

| State                  | Kapan                          |
|------------------------|-------------------------------|
| `CategoryInitial`      | Awal sebelum fetch             |
| `CategoryLoading`      | Sedang proses API              |
| `CategoryLoaded`       | Berhasil load list             |
| `CategoryCreateSuccess`| Berhasil tambah kategori       |
| `CategoryUpdateSuccess`| Berhasil update kategori       |
| `CategoryDeleteSuccess`| Berhasil hapus kategori        |
| `CategoryError`        | API error / network error      |

---

## Catatan Penting

- **Optimistic update**: Data diupdate lokal di `_categories` cache dalam BLoC sebelum re-render, sehingga tidak perlu hit API ulang setelah setiap operasi.
- **Auto refresh**: Setelah create/edit, halaman utama memanggil `CategoryLoadAll()` untuk sinkronisasi penuh dengan server.
- **Delete**: Langsung hapus dari cache lokal, list langsung update tanpa reload.
