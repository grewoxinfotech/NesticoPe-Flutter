import 'package:flutter/material.dart';
import 'package:nesticope_app/app/constants/color_res.dart';

/// Confirmation before POST `/subscription/activate/:id`.
class ActivateSubscriptionDialog extends StatefulWidget {
  const ActivateSubscriptionDialog({
    super.key,
    required this.planName,
    required this.onConfirm,
  });

  final String planName;
  final Future<bool> Function() onConfirm;

  @override
  State<ActivateSubscriptionDialog> createState() =>
      _ActivateSubscriptionDialogState();
}

class _ActivateSubscriptionDialogState extends State<ActivateSubscriptionDialog> {
  bool _busy = false;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      backgroundColor: ColorRes.white,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: const Text(
        'Activate Plan Immediately?',
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w600,
          color: ColorRes.textPrimary,
        ),
      ),
      content: Text(
        'This will start the ${widget.planName} plan right now. Your '
        'current active plan (if any) will be cancelled. Are you sure?',
        style: const TextStyle(
          fontSize: 14,
          height: 1.4,
          color: ColorRes.textPrimary,
        ),
      ),
      actions: [
        TextButton(
          onPressed: _busy ? null : () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        FilledButton(
          onPressed:
              _busy
                  ? null
                  : () async {
                    setState(() => _busy = true);
                    try {
                      final ok = await widget.onConfirm();
                      if (context.mounted && ok) {
                        Navigator.of(context).pop();
                      }
                    } finally {
                      if (mounted) setState(() => _busy = false);
                    }
                  },
          style: FilledButton.styleFrom(
            backgroundColor: ColorRes.primary,
            foregroundColor: Colors.white,
          ),
          child:
              _busy
                  ? const SizedBox(
                    width: 22,
                    height: 22,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                  : const Text('Active Now'),
        ),
      ],
    );
  }
}
