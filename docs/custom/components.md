# Creating Custom Components
This is the documentation elaborating how you can make custom components with the Pheasant Framework Plugin API.

## Getting Started
If you want to get started with making plugins for pheasant, we recommend you [check this out](./introduction.md) before you continue.

```dart
import 'package:pheasant/custom.dart';
```

## Your First Component
```dart
import 'package:pheasant/custom.dart';

class HelloFrame extends PheasantComponent {

    // `state` is optional in the case you would want to make a static component.
    @override
    Element renderComponent([TemplateState? state]) { 
        // Continue
    }
}
```

The only function required here when overriding `PheasantComponent` is the `renderComponent` function, which takes in an optional state object and returns a html element. With this you can build reusable html components.

Whenever you make use of this component in a pheasant application, the compiler will make use of the name provided for the class in order to search through tags
```html
<div>
    <HelloFrame />
</div>
```

If you want your component to take another name, you would have to wrap the constructor with an alias (*do not use typedefs*).
```dart
HelloFrame hello() => HelloFrame();
```

> We know this may not be optimal for all use cases, and we are working hard on better ways to create custom components. If you have any ideas, feel free to contribute or [talk to me](https://github.com/nikeokoronkwo).

## Attributes
One feature that you can take advantage of with the custom components api is the ability to define your own attributes specific to your component. 

```dart
import 'package:pheasant/custom.dart';

class HelloFrame extends PheasantComponent {
    String world = "world";

    @override
    Map<String, AttrFunc> attributes = {
        'world': (value, target) => world = value;
    }

    // `state` is optional in the case you would want to make a static component.
    @override
    Element renderComponent([TemplateState? state]) { 
        // Continue
    }
}
```

So whenever the attribute named `"world"` is used in the `HelloFrame` component, it calls the function with the parameters: `value` representing the value of the attribute, and `target` as the target element (the element rendered from `renderComponent`). 

```html
<div>
    <HelloFrame world="pheasant"/>
</div>
```
