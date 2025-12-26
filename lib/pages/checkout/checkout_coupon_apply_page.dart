// lib/pages/checkout/checkout_coupon_apply_page.dart
import 'package:flutter/material.dart';
import 'checkout_stepper.dart';

class CheckoutCouponApplyPage extends StatefulWidget {
  const CheckoutCouponApplyPage({super.key});

  @override
  State<CheckoutCouponApplyPage> createState() =>
      _CheckoutCouponApplyPageState();
}

class _CheckoutCouponApplyPageState extends State<CheckoutCouponApplyPage> {
  final TextEditingController couponCtrl =
      TextEditingController(text: '#54856913215');
  bool applyCoupon = false;

  @override
  void dispose() {
    couponCtrl.dispose();
    super.dispose();
  }

  // 🔹 Ubah bagian ini agar diarahkan ke halaman pelacakan
  void _onNext() {
    Navigator.pushNamed(context, '/tracker');
  }

  Widget _roundedNextButton() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: SizedBox(
        height: 60,
        child: ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFF523946),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(22),
            ),
          ),
          onPressed: _onNext,
          child: const Row(
            children: [
              SizedBox(width: 12),
              Text(
                'NEXT',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                  color: Colors.white,
                ),
              ),
              Spacer(),
              Icon(Icons.play_arrow, size: 22, color: Colors.white),
            ],
          ),
        ),
      ),
    );
  }

  Widget _labelledField(String label, TextEditingController ctrl,
      {String? hint}) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(color: Colors.grey.shade500),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: ctrl,
          decoration: InputDecoration(
            hintText: hint,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 18, vertical: 18),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: BorderSide(color: Colors.grey.shade300),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(22),
              borderSide: const BorderSide(color: Color(0xFF523946), width: 2),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(140),
        child: CheckoutStepper(
          step: 2,
          onBack: () => Navigator.of(context).maybePop(),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding:
                    const EdgeInsets.symmetric(horizontal: 18, vertical: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _labelledField('Enter Coupon Code', couponCtrl,
                        hint: '#54856913215'),
                    Row(
                      children: [
                        Checkbox(
                          value: applyCoupon,
                          onChanged: (v) =>
                              setState(() => applyCoupon = v ?? false),
                        ),
                        const SizedBox(width: 8),
                        const Text(
                          'Apply coupon automatically',
                          style: TextStyle(fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                    const SizedBox(height: 120),
                  ],
                ),
              ),
            ),
            _roundedNextButton(),
          ],
        ),
      ),
    );
  }
}
