import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ZakatScreen extends ConsumerStatefulWidget {
  const ZakatScreen({super.key});

  @override
  ConsumerState<ZakatScreen> createState() => _ZakatScreenState();
}

class _ZakatScreenState extends ConsumerState<ZakatScreen> {
  final _cash = TextEditingController();
  final _gold = TextEditingController();
  final _silver = TextEditingController();
  final _investments = TextEditingController();
  final _debts = TextEditingController();
  final _goldPrice = TextEditingController(text: '75');
  final _silverPrice = TextEditingController(text: '1.00');

  @override
  void dispose() {
    for (final c in [
      _cash,
      _gold,
      _silver,
      _investments,
      _debts,
      _goldPrice,
      _silverPrice,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  double _parse(TextEditingController c) =>
      double.tryParse(c.text.replaceAll(',', '')) ?? 0;

  double _nisab() {
    // Silver nisab = 595g silver (preferred by most scholars, lower threshold
    // benefits more recipients). Gold nisab = 87.48g gold.
    final silverNisab = 595 * _parse(_silverPrice);
    final goldNisab = 87.48 * _parse(_goldPrice);
    // Use the lower of the two (silver) per Hanafi preference.
    return silverNisab < goldNisab ? silverNisab : goldNisab;
  }

  double _totalWealth() {
    final goldValue = _parse(_gold) * _parse(_goldPrice);
    final silverValue = _parse(_silver) * _parse(_silverPrice);
    return _parse(_cash) + goldValue + silverValue + _parse(_investments);
  }

  double _zakatable() {
    final wealth = _totalWealth() - _parse(_debts);
    return wealth < 0 ? 0 : wealth;
  }

  double _zakatDue() {
    final z = _zakatable();
    final nisab = _nisab();
    if (z < nisab) return 0;
    return z * 0.025;
  }

  @override
  Widget build(BuildContext context) {
    final nisab = _nisab();
    final wealth = _zakatable();
    final due = _zakatDue();
    final meets = wealth >= nisab;

    return Scaffold(
      appBar: AppBar(title: const Text('Zakat Calculator')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _sectionHeader('Wealth'),
          _numberField(_cash, 'Cash on hand + bank balance'),
          _numberField(_gold, 'Gold (grams)'),
          _numberField(_silver, 'Silver (grams)'),
          _numberField(_investments,
              'Investments (stocks, crypto, business inventory)'),
          const SizedBox(height: 8),
          _sectionHeader('Liabilities'),
          _numberField(_debts, 'Debts owed (short-term)'),
          const SizedBox(height: 8),
          _sectionHeader('Metal prices (per gram)'),
          Row(
            children: [
              Expanded(child: _numberField(_goldPrice, 'Gold')),
              const SizedBox(width: 12),
              Expanded(child: _numberField(_silverPrice, 'Silver')),
            ],
          ),
          const SizedBox(height: 20),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _row('Nisab threshold (silver basis)',
                      _formatCurrency(nisab)),
                  _row('Zakatable wealth', _formatCurrency(wealth)),
                  const Divider(),
                  _row(
                    meets ? 'Zakat due (2.5%)' : 'Below nisab — no zakat due',
                    meets ? _formatCurrency(due) : '—',
                    emphasized: true,
                    color: meets
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).colorScheme.outline,
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Note: use current local gold and silver prices in your currency. '
            'Nisab is calculated on silver (~595g) as it is the lower, more beneficial threshold for recipients.',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }

  String _formatCurrency(double v) {
    return v.toStringAsFixed(2).replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (m) => '${m[1]},',
        );
  }

  Widget _sectionHeader(String s) => Padding(
        padding: const EdgeInsets.only(bottom: 8, top: 4),
        child: Text(
          s.toUpperCase(),
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.primary,
            letterSpacing: 0.8,
          ),
        ),
      );

  Widget _numberField(TextEditingController c, String label) => Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextField(
          controller: c,
          keyboardType:
              const TextInputType.numberWithOptions(decimal: true),
          inputFormatters: [
            FilteringTextInputFormatter.allow(RegExp(r'[0-9\.,]'))
          ],
          decoration: InputDecoration(
            labelText: label,
            border: const OutlineInputBorder(),
            isDense: true,
          ),
          onChanged: (_) => setState(() {}),
        ),
      );

  Widget _row(String label, String value,
      {bool emphasized = false, Color? color}) {
    final style = TextStyle(
      fontSize: emphasized ? 18 : 14,
      fontWeight: emphasized ? FontWeight.bold : FontWeight.normal,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
