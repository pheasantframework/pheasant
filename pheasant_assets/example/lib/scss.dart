// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.
// https://mit-license.org

// ignore: unused_import
import 'package:pheasant_assets/pheasant_assets.dart';

void main() {
  String scssString = '''
<style syntax="sass" local>
\$secondary-color: #2ecc71;

@mixin box-shadow(\$x, \$y, \$blur, \$color) {
  box-shadow: \$x \$y \$blur \$color;
}

section {
  padding: 40px 0;

  .featured-article {
    background-color: \$secondary-color;
    color: #fff;
    padding: 20px;
    @include box-shadow(0, 4px, 8px, rgba(0, 0, 0, 0.1));

    h2 {
      margin: 0 0 10px;
    }

    p {
      font-size: 1.2em;
    }
  }

  .article-list {
    display: flex;
    flex-wrap: wrap;
    justify-content: space-between;

    .article {
      width: 48%;
      margin-bottom: 20px;
      @include box-shadow(0, 2px, 4px, rgba(0, 0, 0, 0.1));

      img {
        width: 100%;
        height: auto;
      }

      h3 {
        margin: 10px;
      }

      p {
        margin: 10px;
        color: #555;
      }
    }
  }
}
</style>
''';
  PheasantStyle pheasantStyle = getStyleInput(scssString);
  PheasantStyleScoped scopedPheasantStyle = scopeComponents(pheasantStyle);

  print('Style Syntax: ${scopedPheasantStyle.syntax}');
  print('Style General Class ID: ${scopedPheasantStyle.id}');
}
