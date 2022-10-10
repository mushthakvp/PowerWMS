SHELL := /bin/bash
a3a:
	emulator @Pixel_3a_API_33_arm64-v8a
a5:
	emulator @Pixel_5_API_33
gen:
	flutter pub run build_runner build --delete-conflicting-outputs