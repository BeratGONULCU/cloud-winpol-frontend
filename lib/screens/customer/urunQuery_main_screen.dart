import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/service/mikro_connection_service.dart';

class UrunQueryMainScreen extends StatefulWidget {
  static const String routeName = '/productQuery';

  const UrunQueryMainScreen({super.key});

  @override
  State<UrunQueryMainScreen> createState() => UrunQueryMainScreenState();
}

class UrunQueryMainScreenState extends State<UrunQueryMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final TextEditingController _searchCtrl = TextEditingController();

  // mikrodan dönen verileri tutacak
  List<Map<String, dynamic>> _urunListesi = [];
  bool _loading = false;
  String? _error;
  int? _mevcutStok;

  // geçici dummy depo verileri

  List<Map<String, dynamic>> _depoStoklari = [
    {"depoKod": "MERKEZ", "depoAdi": "Merkez Depo", "miktar": 120},
    {"depoKod": "SUBE-1", "depoAdi": "Şube 1 Deposu", "miktar": 35},
    {"depoKod": "SUBE-2", "depoAdi": "Şube 2 Deposu", "miktar": 0},
  ];

  void _showImageModal(BuildContext context, String imageUrl) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (_) {
        return Dialog(
          backgroundColor: Colors.transparent,
          insetPadding: const EdgeInsets.all(16),
          child: GestureDetector(
            onTap: () => Navigator.pop(context),
            child: InteractiveViewer(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  imageUrl,
                  fit: BoxFit.contain,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) return child;
                    return const Center(child: CircularProgressIndicator());
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  // BASE MİKRO SQL FUNCTION
  Future<void> _getStockByStokod() async {
    final String arananDeger = _searchCtrl.text.trim();
    if (arananDeger.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tenantDB = await MikroService.getTenantName();
      final response = await MikroService.getStockByStoKod(
        endpoint: 'SqlVeriOkuV2',
        db_name: tenantDB, // ileride backend session’dan alınacak
        body: {
          "SQLSorgu":
              """
          "SELECT SUM(sth_miktar * CASE WHEN sth_evraktip IN (1,2,3) THEN 1 WHEN sth_evraktip IN (4,5,6) THEN -1 ELSE 0 END) AS mevcut_stok FROM STOK_HAREKETLERI WHERE sth_stok_kod = '$arananDeger' GROUP BY sth_stok_kod"
        """,
        },
      );

      final result = response['result']?[0];
      final data = result?['Data']?[0]?['SQLResult1'];

      setState(() {
        _mevcutStok = (data != null && data.isNotEmpty)
            ? (data.first['mevcut_stok'] ?? 0)
            : 0;
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Future<void> _urunSorgula(String urun_kodu) async {
    if (urun_kodu.isEmpty) {
      print("değer boş geldi");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
      _getStockByStokod();
    });

    try {
      final tenantDB = await MikroService.getTenantName();
      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name:
            tenantDB, // bu değer backend içerisinde session (get_tenant_db) ile alınmalı
        body: {
          "SQLSorgu":
              """
          SELECT 
            sto_kod AS StokKodu,
            sto_isim AS StokAdi,
            sto_resim_url AS StokResim
          FROM STOKLAR
          WHERE sto_kod = '$urun_kodu'
        """,
        },
      );

      // Mikro response parse
      final result = response['result']?[0];
      final data = result?['Data']?[0]?['SQLResult1'];

      setState(() {
        _urunListesi = List<Map<String, dynamic>>.from(data ?? []);
        print(_urunListesi);
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  Widget _depoListesi() {
    return Container(
      height: 260, // SABİT
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.04), blurRadius: 12),
        ],
      ),
      child: ListView.separated(
        padding: const EdgeInsets.all(16),
        itemCount: 10,
        separatorBuilder: (_, __) => const Divider(),
        itemBuilder: (context, index) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text("Depo ${index + 1}"),
              Text("${(index + 1) * 5} ADET"),
            ],
          );
        },
      ),
    );
  }

  Widget _depoItem(Map<String, dynamic> depo) {
    final int miktar = depo['miktar'] ?? 0;

    Color renk;
    if (miktar > 0) {
      renk = Colors.green;
    } else if (miktar == 0) {
      renk = Colors.grey;
    } else {
      renk = Colors.red;
    }

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF9FAFB),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Row(
        children: [
          // LEFT
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  depo['depoAdi'],
                  style: const TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 15,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Kod: ${depo['depoKod']}",
                  style: const TextStyle(color: Colors.black54),
                ),
              ],
            ),
          ),

          // RIGHT BADGE
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: renk.withOpacity(0.12),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              "$miktar ADET",
              style: TextStyle(color: renk, fontWeight: FontWeight.w700),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _getStockByBarkodNo() async {
    final String arananDeger = _searchCtrl.text.trim();

    print("Ürün sorgulama başladı");
    if (arananDeger.isEmpty) {
      print("değer boş geldi");
      return;
    }

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final tenantDB = await MikroService.getTenantName();
      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name:
            tenantDB, // bu değer backend içerisinde session (get_tenant_db) ile alınmalı
        body: {
          "SQLSorgu":
              """
              SELECT bar_stokkodu FROM BARKOD_TANIMLARI WHERE bar_kodu = '$arananDeger' OR bar_stokkodu = '$arananDeger'
              """,
        },
      );

      // Mikro response parse
      final result = response['result']?[0];
      final data = result?['Data']?[0]?['SQLResult1'];
      print(data);

      setState(() {
        _urunListesi = List<Map<String, dynamic>>.from(data ?? []);
        if (_urunListesi.isNotEmpty) {
          print(
            "Barkod ile bulunan stok kodu: ${_urunListesi.first['bar_stokkodu']}",
          );
          _urunSorgula(_urunListesi.first['bar_stokkodu']);
        } else {
          print("Barkod ile eşleşen ürün bulunamadı.");
        }
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    } finally {
      setState(() {
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final String? imageUrl = _urunListesi.isNotEmpty
        ? _urunListesi.first['StokResim']
        : null;

    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Ürün Sorgulama",
        onBack: null,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),

      // ===================== FIX =====================
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(24),
        child: Center(
          child: Container(
            constraints: const BoxConstraints(maxWidth: 1200),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ================= HERO SEARCH =================
                Container(
                  height: 56,
                  padding: const EdgeInsets.symmetric(horizontal: 18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(32),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.05),
                        blurRadius: 16,
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.qr_code_scanner, color: Colors.black38),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: _searchCtrl,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Ürün Kodu / Barkod okut",
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(20),
                        onTap: _getStockByBarkodNo,
                        child: Container(
                          height: 40,
                          width: 40,
                          decoration: const BoxDecoration(
                            color: Color(0xFF065186),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(
                            Icons.search,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 32),

                // ================= PRODUCT CARD =================
                Container(
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 20,
                      ),
                    ],
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // LEFT
                      Expanded(
                        flex: 3,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              _urunListesi.isNotEmpty
                                  ? _urunListesi.first['StokAdi'] ?? '—'
                                  : 'Ürün Adı',
                              style: const TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            const SizedBox(height: 8),

                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 6,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.green.withOpacity(0.12),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: Text(
                                _mevcutStok != null
                                    ? "STOKTA · $_mevcutStok ADET"
                                    : "STOK BİLGİSİ YOK",
                                style: const TextStyle(
                                  color: Colors.green,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 24),

                      // RIGHT IMAGE
                      Expanded(
                        flex: 2,
                        child: Container(
                          height: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFFF4F6FA),
                            borderRadius: BorderRadius.circular(16),
                          ),
                          clipBehavior: Clip.antiAlias,
                          child: imageUrl != null && imageUrl.isNotEmpty
                              ? Image.network(
                                  imageUrl,
                                  fit: BoxFit.cover,
                                  errorBuilder: (_, __, ___) =>
                                      const Icon(Icons.broken_image),
                                )
                              : const Icon(
                                  Icons.image_outlined,
                                  size: 48,
                                  color: Colors.black26,
                                ),
                        ),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 24),

                const SizedBox(height: 24),

                // ================= ACTION BAR =================
                Row(
                  children: [
                    Expanded(
                      child: _actionButton2(
                        label: "Miktar Detay",
                        icon: Icons.inventory_2_outlined,
                        primary: false,
                        onTap: _getStockByStokod,
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: _actionButton(
                        label: "Fiyat Detay",
                        iconText: "₺",
                        primary: true,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ================= DEPOLAR =================
                if (_urunListesi.isNotEmpty) _depoListesi(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/* ========================================================= */
/* ======================= ACTION BUTTON =================== */
/* ========================================================= */

Widget _actionButton({
  required String label,
  IconData? icon,
  String? iconText,
  required bool primary,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: () {},
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: primary ? const Color(0xFF065186) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary ? Colors.transparent : const Color(0xFFC9D6E2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: primary ? Colors.white : Colors.black54),
          if (iconText != null)
            Text(
              iconText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primary ? Colors.white : Colors.black54,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primary ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}

Widget _actionButton2({
  required String label,
  IconData? icon,
  String? iconText,
  required bool primary,
  VoidCallback? onTap,
}) {
  return InkWell(
    borderRadius: BorderRadius.circular(16),
    onTap: onTap,
    child: Container(
      height: 56,
      decoration: BoxDecoration(
        color: primary ? const Color(0xFF065186) : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: primary ? Colors.transparent : const Color(0xFFC9D6E2),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (icon != null)
            Icon(icon, color: primary ? Colors.white : Colors.black54),
          if (iconText != null)
            Text(
              iconText,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w700,
                color: primary ? Colors.white : Colors.black54,
              ),
            ),
          const SizedBox(width: 8),
          Text(
            label,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: primary ? Colors.white : Colors.black87,
            ),
          ),
        ],
      ),
    ),
  );
}
