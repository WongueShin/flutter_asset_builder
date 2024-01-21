import 'package:build/build.dart';
import 'dart:async';
import 'package:glob/glob.dart';

class AssetsBuilder implements Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    final assetStream = buildStep.findAssets(Glob('assets/**'));
    List<String> assetPaths = [];

    // assets/ 디렉토리의 모든 파일을 찾아 리스트화
    await for (final id in assetStream) {
      assetPaths.add(id.path);
    }

    // 생성할 파일의 내용을 만듦
    final generatedContent = generateAssetList(assetPaths);

    // 새 파일 생성
    final newAssetId = AssetId(buildStep.inputId.package, 'lib/assets.g.dart');
    await buildStep.writeAsString(newAssetId, generatedContent);
  }

  // 에셋 리스트를 기반으로 Dart 코드 생성
  String generateAssetList(List<String> assetPaths) {
    final buffer = StringBuffer();
    buffer.writeln('// GENERATED CODE - DO NOT MODIFY BY HAND\n');
    buffer.writeln('class Assets {');
    for (final path in assetPaths) {
      final assetName = path.split('/').last;
      buffer.writeln('  static const String $assetName = \'$path\';');
    }
    buffer.writeln('}');
    return buffer.toString();
  }

  @override
  Map<String, List<String>> get buildExtensions => {
        '.dart': ['.g.dart']
      };
}
