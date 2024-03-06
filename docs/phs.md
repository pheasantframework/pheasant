# Breakdown of a Pheasant File
Every pheasant file (.phs) contains three parts: the script, which contains any dart code you would need to run the application; the template, which contains html empowered with pheasant code to help "bring your dart into your html"; and style, which contains styles which are, by default, scoped locally to the component by the `pheasant_assets` engine. The `pheasant_assets` package renders the styles, while the `pheasant_temp` package collects the rendered css and compiles the file into dart code run in the browser.

Below is a breakdown of each part of the pheasant file

## Script
The Script part of the pheasant component cnt


## Template
The Template part of the pheasant component is used to write pheasant-extended html that serves as the foundation of the component file. The template tag is where the html is written and used in the browser, and it makes use of the data in the script and style tags for code rendering.

Since the template is just pheasant-extended html, you can write plain html in your template tags and the code will run! 

## Style
The style part of the pheasant component contains all the styles needed for a particular component.
By default all styles defined in the tags are locally scoped to the component by the `pheasant_assets` package:
```css
<style>
body {
  background-color: var(--color-background);
  color: var(--color-text);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial,
    sans-serif, "Apple Color Emoji", "Segoe UI Emoji";
  font-size: 1rem;
  line-height: normal;
}
</style>
```

If you want to write styles that work globally, you can add the "global" specifier at the end of the opening style tag:
```css
<style global>
body {
  background-color: var(--color-background);
  color: var(--color-text);
  font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial,
    sans-serif, "Apple Color Emoji", "Segoe UI Emoji";
  font-size: 1rem;
  line-height: normal;
}
</style>
```

Either "global" or "local" can be used: "local" is implicitly used by default.

The style part can be configured to suit your needs. In general it has three options (specified and declared as attributes).
1. `src`: This is used if you want to declare the styles in an external file rather than in the current pheasant component file.
```css
<style src="styles.css"></style>
```

```css
@import url(https://fonts.googleapis.com/css?family=Roboto);
@import url(https://fonts.googleapis.com/css?family=Material+Icons);

body {
  max-width: 600px;
  margin: 0 auto;
  padding: 5vw;
}

* {
  font-family: Roboto, Helvetica, Arial, sans-serif;
}
```

2. `syntax`: This is used to specify the syntax used in the style part of the pheasant component file. As standard, there are three supported syntaxes: `css`, `scss` and `sass`. By default, `css` is used. Before making use of this, ensure `sass` is enabled in your project by setting `sass` as true in your *`pheasant.yaml`* file, else it will throw an exception.
```scss
<style syntax="scss">
@import url(https://fonts.googleapis.com/css?family=Roboto);
$font-family: Roboto

body {
  max-width: 600px;
  margin: 0 auto;
  padding: 5vw;

  p {
    font-family: $font-family;
  }

  code {
    color: gray;
  }
}
</style>
```
You can declare `src` and `syntax` together to write your styles in separate `.scss` or `.sass` files.

<!-- For now, there isn't support for other css styles, so if you are making use of other external styles, you will need to render them to css before the pheasant compiler does. -->
