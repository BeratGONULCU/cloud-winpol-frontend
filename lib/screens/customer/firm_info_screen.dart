import 'package:flutter/material.dart';
import 'package:cloud_winpol_frontend/widgets/navigation/customer_app_draver.dart';
import 'package:cloud_winpol_frontend/widgets/app_header.dart';
import 'package:cloud_winpol_frontend/widgets/theme/app_colors.dart';
import 'package:cloud_winpol_frontend/screens/settings/settings_screen.dart';
import 'package:cloud_winpol_frontend/service/mikro_connection_service.dart';

class FirmaInfoMainScreen extends StatefulWidget {
  static const String routeName = '/firmaInfo';

  const FirmaInfoMainScreen({super.key});

  @override
  State<FirmaInfoMainScreen> createState() => _FirmaInfoMainScreenState();
}

class _FirmaInfoMainScreenState extends State<FirmaInfoMainScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  List<Map<String, dynamic>> _subeler = [];
  bool _isEditMode = false;
  bool _hasChanges = false;

  late TextEditingController _unvan1Ctrl;
  late TextEditingController _unvan2Ctrl;
  late TextEditingController _vergiDaireCtrl;
  late TextEditingController _vergiNoCtrl;
  late TextEditingController _tcCtrl;
  late TextEditingController _emailCtrl;
  late TextEditingController _webCtrl;

  bool _loading = true;
  String? _error;
  Map<String, dynamic>? _firma;

  @override
  void initState() {
    super.initState();
    _getFirmaBilgileri();
    _getSubeler();
  }

  void _onEditPressed() {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) {
        return Dialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(
              maxWidth: 420, 
            ),
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // HEADER
                    Row(
                      children: const [
                        Icon(Icons.edit, color: Color(0xFF065186), size: 22),
                        SizedBox(width: 10),
                        Text(
                          "Düzenleme Onayı",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 14),

                    const Text(
                      "Firma bilgilerini düzenlemek istediğinize emin misiniz?",
                      style: TextStyle(
                        fontSize: 14,
                        color: Color(0xFF374151),
                        height: 1.4,
                      ),
                    ),

                    const SizedBox(height: 26),

                    // ACTIONS
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.pop(context),
                          child: const Text(
                            "Vazgeç",
                            style: TextStyle(color: Color(0xFF6B7280)),
                          ),
                        ),
                        const SizedBox(width: 12),
                        InkWell(
                          borderRadius: BorderRadius.circular(12),
                          onTap: () {
                            Navigator.pop(context);
                            setState(() {
                              _isEditMode = true;
                              _hasChanges = false;
                            });
                          },
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 18,
                              vertical: 10,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF065186),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              "Evet, Düzenle",
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _saveButton() {
    return Opacity(
      opacity: _hasChanges ? 1 : 0.4, // sadece görsel ipucu
      child: _primaryButton(
        icon: Icons.save,
        label: "Kaydet",
        onTap: _hasChanges ? _save : () {},
      ),
    );
  }

  Future<void> _save() async {
    if (!_hasChanges) return;

    final tenantdb = await MikroService.getTenantName();

    setState(() => _loading = true);

    try {
      await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name: tenantdb,
        body: {
          "SQLSorgu":
              """
        UPDATE FIRMALAR
        SET
          fir_unvan = '${_escape(_unvan1Ctrl.text)}',
          fir_unvan2 = '${_escape(_unvan2Ctrl.text)}',
          fir_FVergiDaire = '${_escape(_vergiDaireCtrl.text)}',
          fir_FVergiNo = '${_escape(_vergiNoCtrl.text)}',
          fir_TCkimlik = '${_escape(_tcCtrl.text)}',
          fir_genel_email = '${_escape(_emailCtrl.text)}',
          fir_web_sayfasi = '${_escape(_webCtrl.text)}'
        WHERE fir_sirano = ${_firma!['Firma No']}
        """,
        },
      );

      setState(() {
        _isEditMode = false;
        _hasChanges = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Firma bilgileri güncellendi")),
      );
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => _loading = false);
    }
  }

  /* ========================================================= */
  /* =================== MIKRO SQL CALL ====================== */
  /* ========================================================= */

  Future<void> _getFirmaBilgileri() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    List<Map<String, dynamic>>? data;

    try {
      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name: '1234567890',
        body: {
          "SQLSorgu": """
        SELECT
          fir_sirano        AS [Firma No],
          fir_unvan         AS [Firma Ünvan1],
          fir_unvan2        AS [Firma Ünvan2],
          fir_FVergiDaire   AS [Vergi Dairesi],
          fir_FVergiNo      AS [Vergi No],
          fir_TCkimlik      AS [T.C. Kimlik],
          fir_genel_email   AS [E-Mail],
          fir_web_sayfasi   AS [Web Adresi]
        FROM FIRMALAR
        """,
        },
      );

      final result = response['result']?[0];
      final rawList = result?['Data']?[0]?['SQLResult1'];

      data = (rawList as List)
          .map((e) => Map<String, dynamic>.from(e))
          .toList();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _loading = false;
      });
      return;
    }

    setState(() {
      _firma = (data != null && data.isNotEmpty) ? data.first : null;

      if (_firma != null) {
        _unvan1Ctrl = TextEditingController(
          text: _firma!['Firma Ünvan1'] ?? '',
        );
        _unvan2Ctrl = TextEditingController(
          text: _firma!['Firma Ünvan2'] ?? '',
        );
        _vergiDaireCtrl = TextEditingController(
          text: _firma!['Vergi Dairesi'] ?? '',
        );
        _vergiNoCtrl = TextEditingController(text: _firma!['Vergi No'] ?? '');
        _tcCtrl = TextEditingController(text: _firma!['T.C. Kimlik'] ?? '');
        _emailCtrl = TextEditingController(text: _firma!['E-Mail'] ?? '');
        _webCtrl = TextEditingController(text: _firma!['Web Adresi'] ?? '');
      }

      _loading = false;
    });
  }

  String _escape(String? value) {
    if (value == null) return '';
    return value.replaceAll("'", "''");
  }

  Future<void> _updateFirmaBilgileri({
    required int firmaNo,
    required String unvan1,
    String? unvan2,
    String? vergiDairesi,
    String? vergiNo,
    String? tcKimlik,
    String? email,
    String? webAdresi,
  }) async {
    final tenantdb = await MikroService.getTenantName();
    setState(() {
      _loading = true;
      _error = null;
    });

    try {
      await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name: tenantdb,
        body: {
          "SQLSorgu":
              """
        UPDATE FIRMALAR
        SET
          fir_unvan = '${_escape(unvan1)}',
          fir_unvan2 = '${_escape(unvan2)}',
          fir_FVergiDaire = '${_escape(vergiDairesi)}',
          fir_FVergiNo = '${_escape(vergiNo)}',
          fir_TCkimlik = '${_escape(tcKimlik)}',
          fir_genel_email = '${_escape(email)}',
          fir_web_sayfasi = '${_escape(webAdresi)}'
        WHERE fir_sirano = $firmaNo
        """,
        },
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Firma bilgileri güncellendi")),
      );
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

  Future<void> _getSubeler() async {
    try {
      final response = await MikroService.connectMikroWithBody(
        endpoint: 'SqlVeriOkuV2',
        db_name: '1234567890',
        body: {
          "SQLSorgu": """
          SELECT
            Sube_no AS [Şube No],
            Sube_adi AS [Şube Adı],
            sube_Il  AS [Şehir]
          FROM SUBELER
        """,
        },
      );

      final result = response['result']?[0];
      final data = result?['Data']?[0]?['SQLResult1'];

      setState(() {
        _subeler = (data != null) ? List<Map<String, dynamic>>.from(data) : [];
      });
    } catch (e) {
      setState(() {
        _error = e.toString();
      });
    }
  }

  /* ========================================================= */
  /* ========================= UI ============================ */
  /* ========================================================= */

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: AppColors.body,
      drawer: const CustomerAppDrawer(),
      appBar: WinpolHeader(
        title: "Firma Yönetimi",
        onBack: null,
        onMenu: () => _scaffoldKey.currentState?.openDrawer(),
        onSettings: () =>
            Navigator.pushNamed(context, SettingsScreen.routeName),
      ),
      body: Center(
        child: Container(
          constraints: const BoxConstraints(maxWidth: 1400),
          padding: const EdgeInsets.all(24),
          child: SizedBox.expand(
            child: _loading
                ? const Center(child: CircularProgressIndicator())
                : _error != null
                ? Center(
                    child: Text(
                      _error!,
                      style: const TextStyle(color: Colors.red),
                    ),
                  )
                : _firma == null
                ? const Center(child: Text("Firma bilgisi bulunamadı"))
                : _mainLayout(),
          ),
        ),
      ),
    );
  }

  /* ========================================================= */
  /* ======================= LAYOUT ========================== */
  /* ========================================================= */

  Widget _mainLayout() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1000;

        if (isMobile) {
          // ================= MOBILE / TABLET =================
          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                _firmaDetailPanel(),
                const SizedBox(height: 16),
                _branchSidePanel(),
              ],
            ),
          );
        }

        // ================= DESKTOP / WEB =================
        return SizedBox(
          height: constraints.maxHeight,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(flex: 16, child: _firmaDetailPanel()),
              const SizedBox(width: 20),
              SizedBox(width: 320, child: _branchSidePanel()),
            ],
          ),
        );
      },
    );
  }

  /* ========================================================= */
  /* ================= FIRMA DETAIL PANEL =================== */
  /* ========================================================= */

  Widget _firmaDetailPanel() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: _panelBox(),
      child: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              "Firma Bilgileri",
              style: TextStyle(fontSize: 17, fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 18),

            _input("Firma Ünvanı", _unvan1Ctrl),
            _input("Firma Ünvanı 2", _unvan2Ctrl),

            Row(
              children: [
                Expanded(child: _input("Vergi Dairesi", _vergiDaireCtrl)),
                const SizedBox(width: 16),
                Expanded(child: _input("Vergi No", _vergiNoCtrl)),
              ],
            ),

            _input("T.C. Kimlik", _tcCtrl),
            _input("E-Mail", _emailCtrl),
            _input("Web Adresi", _webCtrl),

            const SizedBox(height: 32),

            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                _primaryButton(
                  icon: Icons.edit,
                  label: "Düzenle",
                  onTap: _isEditMode ? () {} : _onEditPressed,
                ),
                const SizedBox(width: 12),
                _saveButton(),
              ],
            ),
          ],
        ),
      ),
    );
  }

  /* ========================================================= */
  /* ==================== BRANCH SIDEBAR ===================== */
  /* ========================================================= */

  Widget _branchSidePanel() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isMobile = constraints.maxWidth < 1000;

        return Container(
          padding: const EdgeInsets.all(16),
          decoration: _panelBox(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // HEADER
              Row(
                children: [
                  const Text(
                    "Şubeler",
                    style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Icons.add),
                    tooltip: "Şube Ekle",
                    splashRadius: 18,
                    onPressed: () {
                      Navigator.pushNamed(context, '/branchInsertWeb');
                    },
                  ),
                ],
              ),

              const Divider(),

              // CONTENT
              if (isMobile)
                ListView.separated(
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: _subeler.length,
                  separatorBuilder: (_, __) => const Divider(height: 1),
                  itemBuilder: (context, index) {
                    final sube = _subeler[index];
                    return _subeRow(sube);
                  },
                )
              else
                Expanded(
                  child: _subeler.isEmpty
                      ? Center(
                          child: Text(
                            "Henüz şube bulunamadı",
                            style: TextStyle(
                              color: Colors.black.withOpacity(0.5),
                              fontSize: 13,
                            ),
                          ),
                        )
                      : ListView.separated(
                          itemCount: _subeler.length,
                          separatorBuilder: (_, __) => const Divider(height: 1),
                          itemBuilder: (context, index) {
                            final sube = _subeler[index];
                            return _subeRow(sube);
                          },
                        ),
                ),

              const SizedBox(height: 12),

              _outlineButton(
                icon: Icons.list,
                label: "Şube Listesi",
                onTap: () {
                  Navigator.pushNamed(context, '/branchList');
                },
              ),
            ],
          ),
        );
      },
    );
  }

  /* ========================================================= */
  /* ======================= HELPERS ========================= */
  /* ========================================================= */

  Widget _input(String label, TextEditingController controller) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            label,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
              fontWeight: FontWeight.w600,
            ),
          ),
          const SizedBox(height: 6),
          TextField(
            controller: controller,
            readOnly: !_isEditMode, //    SADECE BU
            style: const TextStyle(fontSize: 14, color: Color(0xFF111827)),
            decoration: InputDecoration(
              isDense: true,
              filled: true,
              fillColor: const Color(0xFFF9FAFB), // DEĞİŞMEDİ
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 12,
                vertical: 12,
              ),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
              disabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: Color(0xFFD1D5DB)),
              ),
            ),
            onChanged: (_) {
              if (_isEditMode && !_hasChanges) {
                setState(() => _hasChanges = true);
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _primaryButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        decoration: BoxDecoration(
          color: const Color(0xFF065186),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(icon, color: Colors.white, size: 18),
            const SizedBox(width: 8),
            Text(
              label,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _outlineButton({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 44,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.black12),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 16),
            const SizedBox(width: 6),
            Text(label),
          ],
        ),
      ),
    );
  }

  BoxDecoration _panelBox() => BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(16), // 22 → 16
    border: Border.all(
      color: const Color(0xFFE5E7EB), // hafif ama net
    ),
    boxShadow: [
      BoxShadow(
        color: Colors.black.withOpacity(0.03),
        blurRadius: 12,
        offset: const Offset(0, 4),
      ),
    ],
  );
}

Widget _subeRow(Map<String, dynamic> sube) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
    child: Row(
      children: [
        SizedBox(
          width: 40,
          child: Text(
            sube['Şube No']?.toString() ?? '-',
            style: const TextStyle(fontSize: 13),
            textAlign: TextAlign.center,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            sube['Şube Adı'] ?? '-',
            style: const TextStyle(fontSize: 13),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        const SizedBox(width: 8),
        SizedBox(
          width: 70,
          child: Text(
            sube['Şehir'] ?? '-',
            style: TextStyle(
              fontSize: 12,
              color: Colors.black.withOpacity(0.6),
            ),
            overflow: TextOverflow.ellipsis,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    ),
  );
}
