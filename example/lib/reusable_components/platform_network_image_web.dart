/*
 * Do not remove or alter the notices in this preamble.
 *
 * This software is owned by Worldline and may not be be altered, copied, reproduced, republished, uploaded, posted, transmitted or distributed in any way, without the prior written consent of Worldline.
 *
 * Copyright © 2026 Worldline and/or its affiliates.
 *
 * All rights reserved. License grant and user rights and obligations according to the applicable license agreement.
 *
 * Please contact Worldline for questions regarding license and user rights.
 */

import 'dart:ui_web' as ui_web;

import 'package:flutter/widgets.dart';
import 'package:web/web.dart' as web;

/// Web implementation — renders an HTML <img> element via [HtmlElementView].
///
/// [Image.network] on web (CanvasKit renderer) uses the browser fetch API which
/// enforces CORS. The Worldline asset server does not send CORS headers, causing
/// images to fail silently. An HTML <img> element is not subject to this
/// restriction and loads cross-origin images normally.
class PlatformNetworkImage extends StatefulWidget {
  final String url;
  final double? width;
  final double? height;

  const PlatformNetworkImage({super.key, required this.url, this.width, this.height});

  @override
  State<PlatformNetworkImage> createState() => _PlatformNetworkImageState();
}

class _PlatformNetworkImageState extends State<PlatformNetworkImage> {
  static final Set<String> _registeredViewIds = {};

  late final String _viewId;

  @override
  void initState() {
    super.initState();
    // Use the URL hash + length as a stable, unique-enough view ID.
    _viewId = 'wl-img-${widget.url.hashCode.abs()}-${widget.url.length}';

    if (!_registeredViewIds.contains(_viewId)) {
      _registeredViewIds.add(_viewId);
      ui_web.platformViewRegistry.registerViewFactory(_viewId, (_) {
        final img = web.document.createElement('img') as web.HTMLImageElement;
        img.src = widget.url;
        img.style.objectFit = 'contain';
        img.style.width = '100%';
        img.style.height = '100%';
        return img;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.width,
      height: widget.height,
      child: HtmlElementView(viewType: _viewId),
    );
  }
}
