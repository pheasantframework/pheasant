# <span style="color:violet">Pheasant</span>
Pheasant is a frontend web framework that helps in writing dynamic, powerful and fast-rendering websites in Dart. It grants all the features of modern web development (Web Components, HTML Rendering and more) with the dynamic power of Dart.

## How does it work?
Pheasant works by rendering components in `.phs` files. These files consist of three parts: 
1. The **template** which contains html-like syntax, backed in with special pheasant components to help easily and dynamically render code in your web app
```html
<template>
<div>
    <p>Hello World, Welcome to Pheasant</p>
    <p>{{myNum}}</p>
</div>
</template>
```
2. The **script** which contains Dart data located inside it, which can be used in the **template** part for rendering
```dart
<script>
int myNum = 9;

void addNum() {
    myNum++;
}
</script>
```

## Features

### Hello