import 'package:build/build.dart';

class MyBuilder implements Builder {
  @override
  Future<void> build(BuildStep buildStep) async {
    // 다른 패키지의 특정 파일에 접근
    var assetId = AssetId('some_package', 'lib/some_file.dart');
    var content = await buildStep.readAsString(assetId);

    // 분석 또는 처리 로직을 수행
    // ...

    // 새 파일 생성
    var newAssetId = AssetId(buildStep.inputId.package, 'lib/new_file.g.dart');
    await buildStep.writeAsString(newAssetId, generatedContent);
  }

  @override
  Map<String, List<String>> get buildExtensions => {
    '.dart': ['.g.dart']
  };
}
