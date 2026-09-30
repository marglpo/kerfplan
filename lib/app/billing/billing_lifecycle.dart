import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'billing_providers.dart';

class BillingLifecycle extends ConsumerStatefulWidget {
  const BillingLifecycle({super.key, required this.child});
  final Widget child;
  @override
  ConsumerState<BillingLifecycle> createState() => _BillingLifecycleState();
}

class _BillingLifecycleState extends ConsumerState<BillingLifecycle>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) ref.read(billingControllerProvider).start();
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(ref.read(billingControllerProvider).refreshEntitlements());
    }
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ref.watch(
      entitlementsProvider,
    ); // Load local cache independently of billing/network readiness.
    return widget.child;
  }
}
