# Pheasant Template Design Features

Here are some design features used in pheasant that might interest you.

## Double Braces vs Single Braces
If you want to make use of a variable, function or anything similar that returns a value, or compute a value, we make use of double braces. 

Single braces, on the other hand, are used in loops or any other similar situations where you may need to make use of the key value being used.
```html
<template>
<div>
    <div p-for="int count in counts">
        <p>{count}</p>
    </div>
</div>
</template>
```

Despite this difference, you shouldn't name variables in such manner with similar names