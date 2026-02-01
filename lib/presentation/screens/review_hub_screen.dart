import 'package:flutter/material.dart';
import '../../l10n/app_localizations.dart';
import 'weekly_review_screen.dart';
import 'monthly_overview_screen.dart';

class ReviewHubScreen extends StatelessWidget {
  const ReviewHubScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.reflect),
        automaticallyImplyLeading: false,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Card(
            child: ListTile(
              leading: const Icon(Icons.event_note),
              title: Text(l10n.weeklyReview),
              subtitle: Text(l10n.weeklyReviewDescription),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const WeeklyReviewScreen()),
                );
              },
            ),
          ),
          const SizedBox(height: 12),
          Card(
            child: ListTile(
              leading: const Icon(Icons.calendar_month),
              title: Text(l10n.monthlyOverview),
              subtitle: Text(l10n.forThisMonth),
              trailing: const Icon(Icons.chevron_right),
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (context) => const MonthlyOverviewScreen()),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
