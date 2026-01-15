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

  // BASE MİKRO SQL FUNCTION
  Future<void> _getStockByStokod() async {
    final String arananDeger = _searchCtrl.text.trim();
    if (arananDeger.isEmpty) return;

    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      final response = await MikroService.getStockByStoKod(
        endpoint: 'SqlVeriOkuV2',
        db_name: '1234567890', // ileride backend session’dan alınacak
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

  Future<void> _urunSorgula() async {
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
      print("işte bu be");

      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name:
            '1234567890', // bu değer backend içerisinde session (get_tenant_db) ile alınmalı
        body: {
          "SQLSorgu":
              """
          SELECT 
            sto_kod AS StokKodu,
            sto_isim AS StokAdi
          FROM STOKLAR
          WHERE sto_kod = '$arananDeger'
        """,
        },
      );
        print("işte bu be2");


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

  @override
  Widget build(BuildContext context) {
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
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1200),
          padding: const EdgeInsets.all(24),
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
                      onTap: _urunSorgula,
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
                    if (_loading)
                      const Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(),
                      ),

                    if (_error != null)
                      Text(_error!, style: const TextStyle(color: Colors.red)),

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

                          const SizedBox(height: 6),
                          const Text(
                            "Ürün Temel Bilgileri",
                            style: TextStyle(color: Colors.black54),
                          ),
                          const SizedBox(height: 18),

                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.green.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Container(
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
                        child: const Icon(
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

              // ================= ACTION BAR =================
              Row(
                children: [
                  Expanded(
                    child: _actionButton2(
                      label: "Miktar Detay",
                      icon: Icons.inventory_2_outlined,
                      primary: false,
                      onTap: () {
                        if (_urunListesi.isEmpty) return;

                        _getStockByStokod();
                      },
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
            ],
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
