A highly imperfect example of a stupidly simply app.

There is a home page and a login page.  The login page accepts form inputs, but submission does nothing.

The UI was built using `elm-ui`.

To compile the app (from the project root):

```
> elm make src/Main.elm --output elm.js
```

One simple option to run the app is to use [http-server](https://www.npmjs.com/package/http-server).  Once `http-server` is installed, just run
```
> http-server
```
from the project root.
