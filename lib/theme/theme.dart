import 'package:flex_color_scheme/flex_color_scheme.dart';
import 'package:flutter/material.dart';

import 'package:signals/signals_core.dart';

Signal<bool> sIsDark = signal<bool>(false);

Signal<bool> sIsGreen = signal<bool>(true);

Computed<FlexScheme> cFlexScheme = computed(() {
  return sIsGreen.value ? FlexScheme.money : FlexScheme.espresso;
});

Computed<ThemeData> cThemeLight = computed(() {
  return FlexThemeData.light(
    scheme: cFlexScheme.value,
    surfaceMode: FlexSurfaceMode.levelSurfacesLowScaffold,
    blendLevel: 18,
    appBarElevation: 4.0,
    bottomAppBarElevation: 4.0,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 12,
      blendOnColors: false,
      blendTextTheme: true,
      useTextTheme: true,
      thinBorderWidth: 2.0,
      thickBorderWidth: 4.0,
      splashType: FlexSplashType.defaultSplash,
      defaultRadius: 12.0,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      sliderTrackHeight: 5,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      fabAlwaysCircular: true,
      popupMenuRadius: 12.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      tooltipRadius: 12,
      dialogElevation: 4.0,
      timePickerElementRadius: 12.0,
      useInputDecoratorThemeInDialogs: true,
      snackBarRadius: 12,
      snackBarElevation: 4,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 8,
      drawerElevation: 4.0,
      drawerWidth: 300.0,
      bottomSheetElevation: 4.0,
      bottomSheetModalElevation: 4.0,
      bottomNavigationBarElevation: 4.0,
      menuRadius: 12.0,
      menuElevation: 4.0,
      menuBarRadius: 12.0,
      menuBarElevation: 4.0,
      menuIndicatorRadius: 12.0,
      navigationBarElevation: 4.0,
      navigationBarHeight: 64.0,
      navigationRailElevation: 4.0,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
    ),
    tones: FlexTones.chroma(Brightness.light),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    // fontFamily: GoogleFonts.bebasNeue().fontFamily,
  );
});

Computed<ThemeData> cThemeDark = computed(() {
  return FlexThemeData.dark(
    scheme: cFlexScheme.value,
    surfaceMode: FlexSurfaceMode.highScaffoldLowSurface,
    blendLevel: 20,
    appBarElevation: 4.0,
    bottomAppBarElevation: 4.0,
    subThemesData: const FlexSubThemesData(
      blendOnLevel: 20,
      blendTextTheme: true,
      useTextTheme: true,
      splashType: FlexSplashType.defaultSplash,
      defaultRadius: 12.0,
      thinBorderWidth: 2.0,
      thickBorderWidth: 4.0,
      unselectedToggleIsColored: true,
      sliderValueTinted: true,
      sliderTrackHeight: 5,
      inputDecoratorBorderType: FlexInputBorderType.underline,
      inputDecoratorUnfocusedBorderIsColored: false,
      fabUseShape: true,
      fabAlwaysCircular: true,
      popupMenuRadius: 12.0,
      popupMenuElevation: 4.0,
      alignedDropdown: true,
      tooltipRadius: 12,
      dialogElevation: 4.0,
      timePickerElementRadius: 12.0,
      useInputDecoratorThemeInDialogs: true,
      snackBarRadius: 12,
      snackBarElevation: 4,
      appBarScrolledUnderElevation: 4.0,
      tabBarIndicatorWeight: 4,
      tabBarIndicatorTopRadius: 8,
      drawerElevation: 4.0,
      drawerWidth: 300.0,
      bottomSheetElevation: 4.0,
      bottomSheetModalElevation: 4.0,
      bottomNavigationBarElevation: 4.0,
      menuRadius: 12.0,
      menuElevation: 4.0,
      menuBarRadius: 12.0,
      menuBarElevation: 4.0,
      menuIndicatorRadius: 12.0,
      navigationBarElevation: 4.0,
      navigationBarHeight: 64.0,
      navigationRailElevation: 4.0,
    ),
    keyColors: const FlexKeyColors(
      useSecondary: true,
    ),
    tones: FlexTones.chroma(Brightness.dark),
    visualDensity: FlexColorScheme.comfortablePlatformDensity,
    useMaterial3: true,
    swapLegacyOnMaterial3: true,
    fontFamily: 'Times New Roman',
  );
});

Computed<ColorScheme> cFlexSchemeLight = computed(() {
  if (sIsGreen.value) {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff2e8b57), // Rich green
      onPrimary: Color(0xffffffff), // White for contrast
      primaryContainer: Color(0xffa0d8b3), // Light green
      onPrimaryContainer: Color(0xff00361d), // Dark green for readability
      secondary: Color(0xff6b8e23), // Olive green
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffd1e7a5), // Light yellow-green
      onSecondaryContainer: Color(0xff2d3200),
      tertiary: Color(0xff4682b4), // Steel blue for contrast
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffc8e4ff), // Light blue
      onTertiaryContainer: Color(0xff001f2b),
      error: Color(0xffd32f2f), // Strong red
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffcdd2), // Light red
      onErrorContainer: Color(0xff9a0007),
      surface: Color(0xfff1f8e9), // Light off-white for a soft surface
      onSurface: Color(0xff1b1f18), // Dark brownish for text readability
      surfaceContainerHighest: Color(0xffe0e9d5),
      onSurfaceVariant: Color(0xff4a4f44),
      outline: Color(0xff2f4f2f),
      outlineVariant: Color(0xffa5b29b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2f3327), // Dark surface for inverse mode
      onInverseSurface: Color(0xffe0e8d8),
      inversePrimary: Color(0xffa1d8a1),
      surfaceTint: Color(0xff2e8b57),
    );
  } else {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff6a4e23), // Rich brown
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xffd9c3a2), // Light beige
      onPrimaryContainer: Color(0xff3b2a1b),
      secondary: Color(0xff8e7f4e), // Olive green-brown
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xffe1d69c), // Light yellow-brown
      onSecondaryContainer: Color(0xff2f2b17),
      tertiary: Color(0xff9b7a5d), // Warm taupe
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xfff1e0c6), // Light cream
      onTertiaryContainer: Color(0xff2c1e12),
      error: Color(0xfff44336), // Red
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffd0d1), // Pale red
      onErrorContainer: Color(0xff67000d),
      surface: Color(0xfff1f1f1), // Soft off-white
      onSurface: Color(0xff1b1b1b),
      surfaceContainerHighest: Color(0xffe0e0e0),
      onSurfaceVariant: Color(0xff5a5a5a),
      outline: Color(0xff6f6f6f),
      outlineVariant: Color(0xffb3b3b3),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff303030), // Darker for inverse surface
      onInverseSurface: Color(0xfff1f1f1),
      inversePrimary: Color(0xfff4f0e1),
      surfaceTint: Color(0xff6a4e23),
    );
  }
});

Computed<ColorScheme> cFlexSchemeDark = computed(() {
  if (sIsGreen.value) {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff66c28c), // Soft green for dark mode
      onPrimary: Color(0xff003b22), // Dark green for contrast
      primaryContainer: Color(0xff2e8b57), // Rich green
      onPrimaryContainer: Color(0xffd1f5e0), // Light green
      secondary: Color(0xff8f9c52), // Muted green
      onSecondary: Color(0xff1c1f00),
      secondaryContainer: Color(0xff4a5630), // Darker olive
      onSecondaryContainer: Color(0xfff1f6bb),
      tertiary: Color(0xff4a6e8c), // Muted blue
      onTertiary: Color(0xff001f33),
      tertiaryContainer: Color(0xff3d5866), // Darker blue
      onTertiaryContainer: Color(0xffb3d6e0),
      error: Color(0xfff44336),
      onError: Color(0xff310001),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffedea),
      surface: Color(0xff121212), // Dark background
      onSurface: Color(0xffe1e1e1),
      surfaceContainerHighest: Color(0xff1f2420),
      onSurfaceVariant: Color(0xffb0c5b1),
      outline: Color(0xff455a47),
      outlineVariant: Color(0xff2f4b3f),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffb0c5b1),
      onInverseSurface: Color(0xff1b1f1a),
      inversePrimary: Color(0xff2e8b57),
      surfaceTint: Color(0xff66c28c),
    );
  } else {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffa1c4bd), // Soft blue-gray
      onPrimary: Color(0xff3a5a5e),
      primaryContainer: Color(0xff2a4854), // Muted dark teal
      onPrimaryContainer: Color(0xffa8d5e2), // Soft light blue
      secondary: Color(0xffb5b48e), // Muted olive
      onSecondary: Color(0xff1e2a17),
      secondaryContainer: Color(0xff5f5d39),
      onSecondaryContainer: Color(0xfff0f3e1),
      tertiary: Color(0xffdbd8c6), // Soft light tan
      onTertiary: Color(0xff2d1f10),
      tertiaryContainer: Color(0xff7c6a4d), // Brownish beige
      onTertiaryContainer: Color(0xfff6f0e2),
      error: Color(0xfff44336),
      onError: Color(0xff310001),
      errorContainer: Color(0xff93000a),
      onErrorContainer: Color(0xffffedea),
      surface: Color(0xff181818), // Dark surface
      onSurface: Color(0xfff1f1f1),
      surfaceContainerHighest: Color(0xff2b2b2b),
      onSurfaceVariant: Color(0xffc5c8b5),
      outline: Color(0xff736d58),
      outlineVariant: Color(0xff4f4938),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffc5c8b5),
      onInverseSurface: Color(0xff2b2e29),
      inversePrimary: Color(0xff2a4854),
      surfaceTint: Color(0xffa1c4bd),
    );
  }
});
