// Copyright (c) 2024 The Pheasant Group. All Rights Reserved.
// Please see the AUTHORS files for more information.
// Intellectual property of third-party.
//
// This file, as well as use of the code in it, is governed by an MIT License
// that can be found in the LICENSE file.
// You may use this file only in accordance with the license.


List<String> _htmlTags = [
  ..._normalHtmlTags,
  ..._newerHtmlTags,
  ..._additionalHtmlTags
];

List<String> _normalHtmlTags = [
  'a',
  'abbr',
  'address',
  'area',
  'article',
  'aside',
  'audio',
  'b',
  'base',
  'bdi',
  'bdo',
  'blockquote',
  'body',
  'br',
  'button',
  'canvas',
  'caption',
  'cite',
  'code',
  'col',
  'colgroup',
  'center',
  'data',
  'datalist',
  'dd',
  'del',
  'details',
  'dfn',
  'dialog',
  'div',
  'dl',
  'dt',
  'em',
  'embed',
  'fieldset',
  'figcaption',
  'figure',
  'footer',
  'form',
  'h1',
  'h2',
  'h3',
  'h4',
  'h5',
  'h6',
  'head',
  'header',
  'hr',
  'html',
  'i',
  'iframe',
  'img',
  'input',
  'ins',
  'kbd',
  'label',
  'legend',
  'li',
  'link',
  'main',
  'map',
  'mark',
  'meta',
  'meter',
  'nav',
  'noscript',
  'object',
  'ol',
  'optgroup',
  'option',
  'output',
  'p',
  'param',
  'picture',
  'pre',
  'progress',
  'q',
  'rb',
  'rp',
  'rt',
  'rtc',
  'ruby',
  's',
  'samp',
  'script',
  'section',
  'select',
  'slot',
  'small',
  'source',
  'span',
  'strong',
  'style',
  'sub',
  'summary',
  'sup',
  'table',
  'tbody',
  'td',
  'template',
  'textarea',
  'tfoot',
  'th',
  'thead',
  'time',
  'title',
  'tr',
  'track',
  'u',
  'ul',
  'var',
  'video',
  'wbr',
];

List<String> _newerHtmlTags = [
  'article',
  'aside',
  'audio',
  'bdi',
  'bdo',
  'datalist',
  'details',
  'dialog',
  'figcaption',
  'figure',
  'footer',
  'header',
  'main',
  'mark',
  'meter',
  'nav',
  'progress',
  'rp',
  'rt',
  'rtc',
  'ruby',
  'section',
  'summary',
  'time',
  'track',
  'video',
  'wbr',
];

List<String> _additionalHtmlTags = [
  'slot',
  'template',
  'shadow',
  'shadow-root',
  'shadow-host',
  'dialog',
  'command',
  'acronym',
  'applet',
  'basefont',
  'bgsound',
  'blink',
  'font',
  'frameset',
  'frame',
  'isindex',
  'keygen',
  'listing',
  'marquee',
  'multicol',
  'nextid',
  'noembed',
  'plaintext',
  'spacer',
  'strike',
  'xmp',
  'md'
];

bool checkValid(String name) {
  return _htmlTags.contains(name);
}
