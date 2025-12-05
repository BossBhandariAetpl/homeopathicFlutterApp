import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class MedicinesHeader extends StatelessWidget {
  final String title;
  final String description;

  const MedicinesHeader({
    super.key,
    required this.title,
    required this.description,
  });

  static const _blobSize = 128.0;
  static const _blobOffset = 16.0;
  static const _contentPadding = 32.0;
  static const _iconSize = 24.0;
  static const _blurSigma = 4.0;
  static const _borderRadius = 16.0;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 24.0),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.8),
        borderRadius: BorderRadius.circular(_borderRadius),
        border: Border.all(color: Colors.white.withOpacity(0.4)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Stack(
        children: [
          _buildBlurredBackground(),
          _buildBlob(top: -_blobOffset, right: -_blobOffset),
          _buildBlob(bottom: -_blobOffset, left: -_blobOffset),
          _buildContent(),
        ],
      ),
    );
  }

  Widget _buildBlurredBackground() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(_borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: _blurSigma,
          sigmaY: _blurSigma,
        ),
        child: const SizedBox.expand(),
      ),
    );
  }

  Widget _buildBlob({
    double? top,
    double? right,
    double? bottom,
    double? left,
  }) {
    return Positioned(
      top: top,
      right: right,
      bottom: bottom,
      left: left,
      child: Container(
        width: _blobSize,
        height: _blobSize,
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.3),
          shape: BoxShape.circle,
        ),
      ),
    );
  }

  Widget _buildContent() {
    return Padding(
      padding: const EdgeInsets.all(_contentPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildPillIcon(),
          const SizedBox(height: 24),
          _buildTitle(),
          const SizedBox(height: 16),
          _buildDescription(),
        ],
      ),
    );
  }

  Widget _buildPillIcon() {
    return Container(
      padding: const EdgeInsets.all(12.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF6366F1), Color(0xFF8B5CF6)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(12.0),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFF8B5CF6).withOpacity(0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: const Text(
        '💊',
        style: TextStyle(fontSize: _iconSize),
      ),
    );
  }

  Widget _buildTitle() {
    return Text(
      title,
      style: GoogleFonts.poppins(
        fontSize: 28,
        fontWeight: FontWeight.bold,
        color: const Color(0xFF1E293B),
        letterSpacing: -0.5,
      ),
      textAlign: TextAlign.center,
    );
  }

  Widget _buildDescription() {
    return Text(
      description,
      style: GoogleFonts.poppins(
        fontSize: 16,
        color: const Color(0xFF64748B),
        height: 1.6,
        fontWeight: FontWeight.w400,
      ),
      textAlign: TextAlign.center,
    );
  }
}
