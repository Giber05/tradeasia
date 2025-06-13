import 'package:flutter/material.dart';

class OfflineIndicator extends StatelessWidget {
  final bool isOffline;
  final VoidCallback? onRetry;

  const OfflineIndicator({super.key, required this.isOffline, this.onRetry});

  @override
  Widget build(BuildContext context) {
    if (!isOffline) return const SizedBox.shrink();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      color: const Color(0xFFFF6B6B),
      child: Row(
        children: [
          const Icon(Icons.cloud_off_outlined, color: Colors.white, size: 20),
          const SizedBox(width: 12),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'No Internet Connection',
                  style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600, fontSize: 14),
                ),
                Text('Showing cached data', style: TextStyle(color: Colors.white70, fontSize: 12)),
              ],
            ),
          ),
          if (onRetry != null) ...[
            const SizedBox(width: 8),
            TextButton(
              onPressed: onRetry,
              style: TextButton.styleFrom(
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(6),
                  side: const BorderSide(color: Colors.white70),
                ),
              ),
              child: const Text('Retry', style: TextStyle(fontSize: 12)),
            ),
          ],
        ],
      ),
    );
  }
}

class ConnectivityIndicator extends StatelessWidget {
  final bool isConnected;
  final VoidCallback? onRetry;

  const ConnectivityIndicator({super.key, required this.isConnected, this.onRetry});

  @override
  Widget build(BuildContext context) {
    return OfflineIndicator(isOffline: !isConnected, onRetry: onRetry);
  }
}
