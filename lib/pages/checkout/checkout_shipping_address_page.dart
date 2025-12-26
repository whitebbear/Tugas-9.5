// lib/pages/checkout/checkout_shipping_address_page.dart
import 'package:flutter/material.dart';
import 'checkout_stepper.dart';
import 'checkout_coupon_apply_page.dart';

class CheckoutShippingAddressPage extends StatefulWidget {
  const CheckoutShippingAddressPage({Key? key}) : super(key: key);

  @override
  State<CheckoutShippingAddressPage> createState() =>
      _CheckoutShippingAddressPageState();
}

class _CheckoutShippingAddressPageState
    extends State<CheckoutShippingAddressPage> {
  final TextEditingController nameCtrl =
      TextEditingController(text: 'Samuel Witwicky');
  final TextEditingController zipCtrl = TextEditingController();
  final TextEditingController countryCtrl = TextEditingController();
  final TextEditingController stateCtrl = TextEditingController();
  final TextEditingController cityCtrl = TextEditingController();
  bool saveAddress = false;

  @override
  void dispose() {
    nameCtrl.dispose();
    zipCtrl.dispose();
    countryCtrl.dispose();
    stateCtrl.dispose();
    cityCtrl.dispose();
    super.dispose();
  }

  void _onNext() {
    Navigator.of(context).push(
      MaterialPageRoute(builder: (_) => const CheckoutCouponApplyPage()),
    );
  }

  Widget _roundedNextButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 0, 18, 24),
      child: SizedBox(
        height: 58,
        width: double.infinity,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF523946),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(18),
            ),
          ),
          onPressed: _onNext,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                'NEXT',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              SizedBox(width: 8),
              Icon(Icons.play_arrow, size: 22, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelledField(String label, TextEditingController ctrl,
      {String? hint, bool isDropdown = false}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            color: Colors.grey.shade500,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          readOnly: isDropdown,
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(color: Colors.black87),
            suffixIcon: isDropdown ? const Icon(Icons.arrow_drop_down) : null,
            filled: true,
            fillColor: Colors.white,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 20, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: Colors.grey.shade300, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide:
                  const BorderSide(color: Color(0xFF523946), width: 1.5),
            ),
          ),
        ),
        const SizedBox(height: 18),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, // Latar putih bersih
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: CheckoutStepper(
          step: 0,
          onBack: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelledField('Card Holder Name', nameCtrl),
                    _labelledField('Zip/postal Code', zipCtrl),
                    _labelledField('Country', countryCtrl,
                        hint: 'Choose your country', isDropdown: true),
                    _labelledField('State', stateCtrl, hint: 'Enter here'),
                    _labelledField('City', cityCtrl, hint: 'Enter here'),

                    const SizedBox(height: 6),

                    // ✅ Checkbox baris bawah
                    Row(
                      children: [
                        Checkbox(
                          activeColor: const Color(0xFF523946),
                          value: saveAddress,
                          onChanged: (v) =>
                              setState(() => saveAddress = v ?? false),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          'Save shipping address',
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: Colors.black,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),

            // ✅ Tombol NEXT
            _roundedNextButton(),
          ],
        ),
      ),
    );
  }
}
