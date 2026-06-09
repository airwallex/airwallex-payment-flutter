import 'dart:io';

/// Converts VitePress-flavored API markdown into portable Markdown.
void main(List<String> args) {
  if (args.length < 2) {
    stderr.writeln(
      'Usage: dart run .github/scripts/customise-md-docs.dart <input_dir> <output_dir>',
    );
    exit(64);
  }

  final inputDir = Directory(args[0]);
  final outputDir = Directory(args[1]);

  if (!inputDir.existsSync()) {
    stderr.writeln('Input directory not found: ${inputDir.path}');
    exit(1);
  }

  var fileCount = 0;
  for (final entity in inputDir.listSync(recursive: true, followLinks: false)) {
    if (entity is! File || !entity.path.endsWith('.md')) {
      continue;
    }

    final relativePath = entity.path.substring(inputDir.path.length + 1);
    final targetFile = File('${outputDir.path}/$relativePath');
    targetFile.parent.createSync(recursive: true);
    targetFile.writeAsStringSync(
      sanitize(entity.readAsStringSync(), relativePath: relativePath),
    );
    fileCount++;
  }

  stdout.writeln('Sanitized $fileCount markdown files into ${outputDir.path}');
}

String sanitize(String input, {required String relativePath}) {
  var text = input;

  text = _removeFrontmatter(text);
  text = _replaceMemberSignatures(text);
  text = _replaceBadges(text);
  text = _removeHeadingAnchors(text);
  text = _convertVitePressContainers(text);
  text = _rewriteApiLinks(text, relativePath);
  text = _stripRemainingHtml(text);
  text = _unwrapDetailsBlocks(text);
  text = _normalizeClassPreamble(text);
  text = _processMemberBlocks(text);
  text = _normalizeBlankLines(text);

  return text;
}

String _removeFrontmatter(String text) {
  if (!text.startsWith('---')) {
    return text;
  }

  final end = text.indexOf('\n---', 3);
  if (end == -1) {
    return text;
  }

  return text.substring(end + 4).replaceFirst(RegExp(r'^\s*'), '');
}

String _convertVitePressContainers(String text) {
  return text.replaceAllMapped(
    RegExp(
      r':::(info|tip|warning|danger|note|caution)\s+([^\n]+)\n([\s\S]*?)\n:::',
      multiLine: true,
    ),
    (match) {
      final title = match.group(2)!.trim();
      final content = match.group(3)!.trim();
      return '**$title**\n\n$content';
    },
  );
}

String _unwrapDetailsBlocks(String text) {
  return text.replaceAllMapped(
    RegExp(
      r':::details Implementation\s*\n(```dart[\s\S]*?```)\s*\n:::',
      multiLine: true,
    ),
    (match) =>
        '\n<details>\n<summary>Implementation</summary>\n\n${match.group(1)!}\n\n</details>\n',
  );
}

String _normalizeClassPreamble(String text) {
  final lines = text.split('\n');
  final firstSectionIndex = lines.indexWhere(_isSectionHeading);
  if (firstSectionIndex <= 0 || !lines.first.startsWith('# ')) {
    return text;
  }

  final preamble = List<String>.from(lines.sublist(0, firstSectionIndex));
  final rest = lines.sublist(firstSectionIndex);

  final badges = _badgesFromHeading(preamble.first);
  final className = _classNameFromHeading(preamble.first);
  preamble[0] = '# $className';

  if (badges.isNotEmpty) {
    while (preamble.isNotEmpty && preamble.last.trim().isEmpty) {
      preamble.removeLast();
    }
    preamble
      ..add('')
      ..add(badges)
      ..add('');
  }

  return [...preamble, ...rest].join('\n');
}

String _replaceMemberSignatures(String text) {
  return text.replaceAllMapped(
    RegExp(
      r'<div class="member-signature"[^>]*>([\s\S]*?)</div>',
      multiLine: true,
    ),
    (match) {
      final signature = _htmlToPlainDart(match.group(1)!);
      if (signature.trim().isEmpty) {
        return '';
      }
      return '\n```dart\n$signature\n```\n';
    },
  );
}

String _htmlToPlainDart(String html) {
  var text = html;

  text = text.replaceAllMapped(
    RegExp(r'<a[^>]*class="type-link"[^>]*>([\s\S]*?)</a>'),
    (match) => match.group(1)!.trim(),
  );
  text = text.replaceAllMapped(
    RegExp(r'<a[^>]*>([\s\S]*?)</a>'),
    (match) => match.group(1)!.trim(),
  );

  text = text.replaceAll(RegExp(r'<(pre|code)[^>]*>'), '');
  text = text.replaceAll('</pre>', '\n');
  text = text.replaceAll('</code>', '');
  text = text.replaceAll(RegExp(r'<br\s*/?>'), '\n');
  text = text.replaceAll(RegExp(r'</?div[^>]*>'), '\n');
  text = text.replaceAll(RegExp(r'<span[^>]*>'), '');
  text = text.replaceAll('</span>', '');

  text = text
      .replaceAll('&lt;', '<')
      .replaceAll('&gt;', '>')
      .replaceAll('&amp;', '&')
      .replaceAll('&quot;', '"');

  final lines = text
      .split('\n')
      .map((line) => line.replaceAll(RegExp(r'[ \t]+'), ' ').trimRight())
      .where((line) => line.trim().isNotEmpty)
      .toList();

  return lines.join('\n').trim();
}

String _replaceBadges(String text) {
  var result = text.replaceAllMapped(
    RegExp(r'<Badge[^>]*text="([^"]*)"[^>]*/>'),
    (match) => ' *(${match.group(1)!})*',
  );

  result = result.replaceAllMapped(
    RegExp(r'<span class="docs-badge[^"]*">([^<]*)</span>'),
    (match) => ' *(${match.group(1)!})*',
  );

  return result;
}

String _removeHeadingAnchors(String text) {
  return text.replaceAll(RegExp(r' \{#([^}]*)\}'), '');
}

String _rewriteApiLinks(String text, String relativePath) {
  return text.replaceAllMapped(
    RegExp(r'\]\((/api/[^)]+)\)'),
    (match) {
      final apiPath = match.group(1)!.split('#').first;
      var target = apiPath.substring('/api/'.length);
      if (target.endsWith('/')) {
        target = '${target}index.md';
      } else {
        target = '$target.md';
      }
      return '](${_relativeLink(relativePath, target)})';
    },
  );
}

String _relativeLink(String fromFile, String toFile) {
  final fromDir = _dirname(fromFile);
  final fromSegments = fromDir.isEmpty ? <String>[] : fromDir.split('/');
  final toSegments = toFile.split('/');

  var shared = 0;
  while (shared < fromSegments.length &&
      shared < toSegments.length &&
      fromSegments[shared] == toSegments[shared]) {
    shared++;
  }

  final ups = fromSegments.length - shared;
  final remainder = toSegments.sublist(shared);
  if (ups == 0) {
    return remainder.join('/');
  }

  return [...List.filled(ups, '..'), ...remainder].join('/');
}

String _dirname(String filePath) {
  final separator = filePath.lastIndexOf('/');
  return separator == -1 ? '' : filePath.substring(0, separator);
}

String _stripRemainingHtml(String text) {
  final codeBlockPattern = RegExp(r'```[\s\S]*?```', multiLine: true);
  final buffer = StringBuffer();
  var lastEnd = 0;

  for (final match in codeBlockPattern.allMatches(text)) {
    if (match.start > lastEnd) {
      buffer.write(_stripHtmlOutsideCode(text.substring(lastEnd, match.start)));
    }
    buffer.write(match.group(0));
    lastEnd = match.end;
  }

  if (lastEnd < text.length) {
    buffer.write(_stripHtmlOutsideCode(text.substring(lastEnd)));
  }

  return buffer.toString();
}

String _stripHtmlOutsideCode(String text) {
  var result = text;

  result = result.replaceAll(RegExp(r'<p[^>]*>'), '');
  result = result.replaceAll('</p>', '\n\n');
  result = result.replaceAllMapped(
    RegExp(r'<img[^>]*src="([^"]+)"[^>]*>'),
    (match) => '![](${match.group(1)!})',
  );
  result = result.replaceAll(RegExp(r'<[^>]+>'), '');

  return result;
}

const _objectMemberDescriptions = {
  'hashCode': 'The hash code for this object.',
  'runtimeType': 'A representation of the runtime type of the object.',
  'toString()': 'A string representation of this object.',
  'noSuchMethod()': 'Invoked when a nonexistent method or property is accessed.',
  'operator ==()': 'The equality operator.',
};

String _processMemberBlocks(String text) {
  final lines = text.split('\n');
  final result = <String>[];
  var index = 0;

  while (index < lines.length) {
    final line = lines[index];
    if (_isSectionHeading(line)) {
      final sectionName = line.replaceFirst('## ', '').trim();
      index++;
      final sectionLines = <String>[];
      final memberBlocks = <List<String>>[];
      var currentMember = <String>[];
      var inMember = false;

      while (index < lines.length && !_isSectionHeading(lines[index])) {
        if (lines[index].startsWith('### ')) {
          if (inMember) {
            memberBlocks.add(currentMember);
          }
          currentMember = [lines[index]];
          inMember = true;
        } else if (inMember) {
          currentMember.add(lines[index]);
        } else {
          sectionLines.add(lines[index]);
        }
        index++;
      }

      if (inMember) {
        memberBlocks.add(currentMember);
      }

      final hasSectionContent = sectionLines.any((l) => l.trim().isNotEmpty) ||
          memberBlocks.isNotEmpty;

      if (hasSectionContent) {
        result.add(line);
        result.addAll(sectionLines);
        for (final member in memberBlocks) {
          result.addAll(_processMemberBlock(member, sectionName));
        }
      }
      continue;
    }

    result.add(line);
    index++;
  }

  return result.join('\n');
}

List<String> _processMemberBlock(List<String> block, String sectionName) {
  if (_isInheritedMember(block)) {
    return _compactInheritedMemberBlock(block);
  }

  if (_isPropertiesSection(sectionName)) {
    return _compactPropertyMemberBlock(block);
  }

  return _processMethodMemberBlock(block);
}

bool _isPropertiesSection(String sectionName) {
  final normalized = sectionName.toLowerCase();
  return normalized == 'properties' || normalized == 'constants';
}

List<String> _compactInheritedMemberBlock(List<String> block) {
  final heading = block.first;
  final name = _memberNameFromHeading(heading);
  final badges = _badgesFromHeading(heading);
  final signature = _extractSignatureFromBlock(block);
  final description =
      _extractShortDescription(block) ?? _objectMemberDescriptions[name] ?? '';

  return _compactMemberLines(
    name: name,
    signature: signature,
    description: description,
    badges: badges,
  );
}

List<String> _compactPropertyMemberBlock(List<String> block) {
  final heading = block.first;
  final name = _memberNameFromHeading(heading);
  final badges = _badgesFromHeading(heading);
  final signature = _extractSignatureFromBlock(block);
  final description = _extractShortDescription(block);

  return _compactMemberLines(
    name: name,
    signature: signature,
    description: description ?? '',
    badges: badges,
  );
}

List<String> _compactMemberLines({
  required String name,
  required String signature,
  required String description,
  required String badges,
}) {
  return [
    '### $name',
    '',
    if (signature.isNotEmpty) '`$signature`',
    if (signature.isNotEmpty) '',
    if (description.isNotEmpty) description,
    if (description.isNotEmpty) '',
    if (badges.isNotEmpty) badges,
    if (badges.isNotEmpty) '',
  ];
}

List<String> _processMethodMemberBlock(List<String> block) {
  final heading = block.first;
  final body = _stripTrivialDetails(block.skip(1).join('\n'));
  return [
    heading,
    if (body.trim().isNotEmpty) body,
  ];
}

String _stripTrivialDetails(String text) {
  return text.replaceAllMapped(
    RegExp(
      r'<details>\s*<summary>Implementation</summary>\s*\n```dart\s*\n([\s\S]*?)```\s*\n</details>',
      multiLine: true,
    ),
    (match) {
      if (_isTrivialImplementation(match.group(1)!)) {
        return '';
      }
      return match.group(0)!;
    },
  );
}

bool _isTrivialImplementation(String impl) {
  final normalized = impl.replaceAll(RegExp(r'\s+'), ' ').trim();
  if (normalized.contains('=>') || normalized.contains('{')) {
    return false;
  }

  if (RegExp(r'^[\w<>,\?\[\]\s\.]+\s+\w+;$').hasMatch(normalized)) {
    return true;
  }

  return RegExp(r'^[\w<>,\?\[\]\s\.]+\s+\w+\([^)]*\);$').hasMatch(normalized);
}

String _badgesFromHeading(String heading) {
  final markdownBadges = RegExp(r'\*\([^)]*\)\*')
      .allMatches(heading)
      .map((match) => match.group(0)!)
      .join(' ');

  if (markdownBadges.isNotEmpty) {
    return markdownBadges;
  }

  return RegExp(r'<Badge[^>]*text="([^"]*)"[^>]*/>')
      .allMatches(heading)
      .map((match) => '*(${match.group(1)!})*')
      .join(' ');
}

String _classNameFromHeading(String heading) {
  var name = heading.replaceFirst(RegExp(r'^#\s+'), '').trim();
  name = name.replaceAll(RegExp(r'\s*\*\([^)]*\)\*'), '').trim();
  return name;
}

String _memberNameFromHeading(String heading) {
  var name = heading.replaceFirst(RegExp(r'^###\s+'), '').trim();
  name = name.replaceAll(RegExp(r'\s*\*\([^)]*\)\*'), '').trim();
  return name;
}

String _extractSignatureFromBlock(List<String> block) {
  final body = block.skip(1).join('\n');
  final match =
      RegExp(r'```dart\s*\n([\s\S]*?)```', multiLine: true).firstMatch(body);
  if (match == null) {
    final inline = RegExp(r'`([^`]+)`').firstMatch(body);
    return inline?.group(1)?.trim() ?? '';
  }

  return match
      .group(1)!
      .split('\n')
      .map((line) => line.trim())
      .where((line) => line.isNotEmpty)
      .join(' ')
      .replaceAll(RegExp(r'\s+'), ' ')
      .trim();
}

String? _extractShortDescription(List<String> block) {
  var body = block.skip(1).join('\n');
  body = body.replaceAll(RegExp(r'```[\s\S]*?```', multiLine: true), '');
  body = body.replaceAll(RegExp(r'<details>[\s\S]*?</details>', multiLine: true), '');
  body = body.replaceAll('**Implementation**', '');
  body = body.replaceAll('*Inherited from Object.*', '');
  body = body.replaceAll(RegExp(r'\*\([^)]*\)\*'), '');

  for (final paragraph in body.split(RegExp(r'\n\s*\n'))) {
    final trimmed = paragraph.trim();
    if (trimmed.isEmpty || trimmed.startsWith('#')) {
      continue;
    }
    return _firstSentence(trimmed);
  }

  return null;
}

String _firstSentence(String text) {
  final normalized = text.replaceAll(RegExp(r'\s+'), ' ');
  final match = RegExp(r'^.*?[.!?](?:\s|$)').firstMatch(normalized);
  if (match != null) {
    return match.group(0)!.trim();
  }
  return normalized.trim();
}

bool _isSectionHeading(String line) =>
    line.startsWith('## ') && !line.startsWith('### ');

bool _isInheritedMember(List<String> block) {
  if (block.isEmpty) {
    return false;
  }

  final heading = block.first;
  if (heading.contains('*(inherited)*') ||
      RegExp(r'<Badge[^>]*text="inherited"').hasMatch(heading)) {
    return true;
  }

  final body = block.skip(1).join('\n');
  return body.contains('Inherited from Object');
}

String _normalizeBlankLines(String text) {
  return text
      .replaceAll(RegExp(r'\n{3,}'), '\n\n')
      .trim()
      .replaceAll(RegExp(r'\n+$'), '\n');
}
