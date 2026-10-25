import 'package:flutter/material.dart';

import '../../widgets/shell.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  static const sections = <({String title, String text, String note})>[
    (
      title: 'Use of the service and acceptance',
      text: 'Please read these terms before subscribing to a service. By creating an account, placing an order, or continuing to use the service, you agree to be bound by these terms. If you do not agree, do not subscribe to or use the service. Keep a copy of these terms for your records.',
      note: 'Using the service means that you accept the rules described here.',
    ),
    (
      title: 'Services',
      text: 'At registration or checkout, you may select from the service plans then available. An order is subject to acceptance by the service operator; a subscription is accepted when confirmation is provided. The operator may decline an order. Access may be interrupted when reasonably necessary for scheduled or emergency maintenance. Additional services may be ordered at their then-current prices and remain subject to availability and these terms.',
      note: 'Activation is confirmed after an order is accepted. Maintenance may sometimes require an interruption.',
    ),
    (
      title: 'Changes to these terms',
      text: 'These terms may be revised from time to time. A revised version replaces the prior version when it is published, unless it expressly says otherwise. Continued use of the service after publication constitutes acceptance of the revised terms. Please review this page periodically so you are aware of changes.',
      note: 'The published version applies to continued use after it takes effect.',
    ),
    (
      title: 'Intellectual property and your content',
      text: 'You retain ownership of content you provide or host through the service. To operate and deliver the service, you grant the operator a non-exclusive, worldwide, royalty-free licence to host, reproduce, display, perform, transmit, and create technically necessary derivatives of that content, only as needed to provide the service and perform obligations under these terms.',
      note: 'Your content remains yours; the limited licence allows the operator to make it available as part of the service.',
    ),
    (
      title: 'Content and acceptable use',
      text: 'You must use the service lawfully and in accordance with applicable policies. You are responsible for activity by your users and downstream customers. If you or they violate the acceptable-use requirements, the operator may restrict or terminate access to the service, including public access to affected files or data.',
      note: 'Do not use the service to host or distribute unlawful or otherwise prohibited material.',
    ),
    (
      title: 'Zero-tolerance spam policy',
      text: 'The operator may update its anti-spam policy by publishing a revised policy on the site. You are responsible for reviewing it. Continued use of the service after a change takes effect means you agree to follow the updated policy.',
      note: 'Do not use the service to send spam.',
    ),
    (
      title: 'Payment and cancellation',
      text: 'Service charges are payable in advance for the period they cover. Recurring services continue to incur charges unless you complete the operator’s cancellation procedure. Initial and recurring charges are those shown at checkout or separately agreed in writing. Setup charges and special programming charges are non-refundable. Failure to pay when due may result in suspension or termination of service.',
      note: 'Fees are paid in advance. If you stop paying for a service, it may be suspended.',
    ),
    (
      title: 'Data loss and backups',
      text: 'You use the service at your own risk and are responsible for maintaining backups of your content. The operator is not responsible for data loss. Any backup the operator may create during routine maintenance is not a guarantee that content can be restored or restored without damage. Maintain and test your own backup and recovery process. Any additional backup service must be agreed separately in writing.',
      note: 'Keep your own tested backups; restoration cannot be guaranteed.',
    ),
    (
      title: 'Resource use and security',
      text: 'Except where the law permits, you must not translate, reverse engineer, decompile, disassemble, or create derivative works from the site or its materials. Do not use automated or manual means to monitor or copy the site or materials, or use devices, software, code, or viruses to interfere with, disrupt, or damage the service, site, or communications on it. You are responsible for consequences of violating this section, including applicable damages and recovery costs.',
      note: 'Do not attempt to intrude into, disrupt, damage, or reverse engineer the service.',
    ),
    (
      title: 'Limitation of liability',
      text: 'You are solely responsible for the operation of your own website and business, and for matters under your control. To the extent permitted by law, the operator is not liable for damage arising from or relating to your operation of, or failure to operate, your website or business.',
      note: 'You remain responsible for your website, business, and the way you use the service.',
    ),
  ];

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 900),
        child: ListView(
          padding: const EdgeInsets.all(24),
          children: [
            const PageHeader(title: 'Terms of Service'),
            const Text(
              'Please read these terms carefully before using or subscribing to the service.',
            ),
            const SizedBox(height: 24),
            for (final section in sections)
              Card(
                margin: const EdgeInsets.only(bottom: 12),
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        section.title,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(section.text),
                      const SizedBox(height: 12),
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(12),
                        color: Theme.of(context)
                            .colorScheme
                            .surfaceContainerHighest,
                        child: Text(section.note),
                      ),
                    ],
                  ),
                ),
              ),
          ],
        ),
      ),
    ),
  );
}
