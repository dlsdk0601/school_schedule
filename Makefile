open: setup
	nix-shell --run 'idea .'

setup:
	nix-shell --run 'flutter pub get'

watch: setup
	nix-shell --run 'flutter pub run build_runner watch --delete-conflicting-outputs'

build-appbundle:
	flutter clean
	flutter pub get
	flutter pub run build_runner build --delete-conflicting-outputs
	flutter build apk
	flutter build appbundle
	open build/app/outputs/bundle/release

DATE=$(shell date +%Y.%m.%d-%H.%M)
VERSION=$(shell grep version: pubspec.yaml | sed -e 's/version: //' | sed -e 's/[+]/./')

build-apk:
	nix-shell --run 'flutter clean && flutter pub get && dart run build_runner build --delete-conflicting-outputs'
	nix-shell --run 'flutter build apk'

open-apk:
	open build/app/outputs/flutter-apk

open-appbundle:
	open build/app/outputs/bundle/release

