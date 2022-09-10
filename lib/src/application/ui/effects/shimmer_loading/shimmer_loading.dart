import 'package:flutter/material.dart';

part 'default_shimmer_gradient.dart';

class ShimmerLoading extends StatefulWidget {
  const ShimmerLoading({
    super.key,
    required this.isLoading,
    required this.child,
  });

  final bool isLoading;
  final Widget child;

  @override
  State<ShimmerLoading> createState() => _ShimmerLoadingState();
}

class _ShimmerLoadingState extends State<ShimmerLoading> {
  Listenable? _shimmerChanges;

  @override
  Widget build(BuildContext context) {
    if (!widget.isLoading) {
      return widget.child;
    }

    // Collect ancestor shimmer information.
    final shimmer = Shimmer.of(context)!;
    if (!shimmer.isSized) {
      return const SizedBox();
    }
    final shimmerSize = shimmer.size;
    final gradient = shimmer.gradient;
    final shimmerLoadingRB = context.findRenderObject() as RenderBox?;
    if (shimmerLoadingRB == null) {
      return const SizedBox();
    }
    final offsetWithinShimmer = shimmer.getDescendantOffset(
      descendant: shimmerLoadingRB,
    );

    return ShaderMask(
      blendMode: BlendMode.srcATop,
      shaderCallback: (bounds) {
        return gradient.createShader(offsetWithinShimmer & shimmerSize);
      },
      child: widget.child,
    );
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_shimmerChanges != null) {
      _shimmerChanges!.removeListener(_onShimmerChange);
    }
    _shimmerChanges = Shimmer.of(context)?.shimmerChanges;
    if (_shimmerChanges != null) {
      _shimmerChanges!.addListener(_onShimmerChange);
    }
  }

  @override
  void dispose() {
    _shimmerChanges?.removeListener(_onShimmerChange);
    super.dispose();
  }

  void _onShimmerChange() {
    if (widget.isLoading) {
      // update the shimmer painting.
      setState(() {});
    }
  }
}

class Shimmer extends StatefulWidget {
  static ShimmerState? of(BuildContext context) {
    return context.findAncestorStateOfType<ShimmerState>();
  }

  const Shimmer({
    super.key,
    this.linearGradient = _defaultShimmerGradient,
    this.child,
  });

  final LinearGradient linearGradient;
  final Widget? child;

  @override
  ShimmerState createState() => ShimmerState();
}

class ShimmerState extends State<Shimmer> with SingleTickerProviderStateMixin {
  late final AnimationController _shimmerController;

  @override
  void initState() {
    super.initState();

    _shimmerController = AnimationController.unbounded(vsync: this);
    _shimmerController.repeat(
      min: -0.5,
      max: 1.5,
      period: const Duration(milliseconds: 1000),
      reverse: true,
    );
  }

  @override
  void dispose() {
    _shimmerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.child ?? const SizedBox();
  }

  Listenable get shimmerChanges => _shimmerController;

  LinearGradient get gradient {
    return LinearGradient(
      colors: widget.linearGradient.colors,
      stops: widget.linearGradient.stops,
      begin: widget.linearGradient.begin,
      end: widget.linearGradient.end,
      transform: _SlidingGradientTransform(
        slidePercent: _shimmerController.value,
      ),
    );
  }

  bool get isSized {
    final rb = context.findRenderObject() as RenderBox?;
    final hasSize = rb?.hasSize ?? false;
    return hasSize;
  }

  Size get size {
    final rb = context.findRenderObject() as RenderBox; 
    return rb.size;
  }

  Offset getDescendantOffset({
    required RenderBox descendant,
    Offset offset = Offset.zero,
  }) {
    final shimmerBox = context.findRenderObject() as RenderBox;
    assert(shimmerBox != null, 'Ensure that the render box is sized first');
    return descendant.localToGlobal(offset, ancestor: shimmerBox);
  }
}

class _SlidingGradientTransform extends GradientTransform {
  const _SlidingGradientTransform({
    required this.slidePercent,
  });

  final double slidePercent;

  @override
  Matrix4? transform(Rect bounds, {TextDirection? textDirection}) {
    return Matrix4.translationValues(bounds.width * slidePercent, 0.0, 0.0);
  }
}