---
title: "react-awesome-router - A lightweight middleware-based React router alternative"
date: 2020-05-05T00:15:36+02:00
draft: false
tags: ["react","router"]
---

## Intro 
Comming from non-react world, routing throgh JSX components always felt strange to me. I didn't like to spread the routing logic between different react components or write JSX components to extend router capabilities. As I leant about react hooks, I realized it would be really easy to write a router that I'm more confortable with; indeed I think the whole module is far below 200 lines of code.

This module provides basic routing features to small applications while allowing more advanced features on bigger applications through the use of custom ad-hoc middlewares.

## Installation
The module is published on npm, so you can add it to your project by just running:

```bash
npm i react-awesome-router --save
```

## Quick Start

First, you need to wrap the component you want to enable router on with the router component. For example to enable route on the whole app:

```tsx
import {Router} from 'react-awesome-router';
import {routes} from './routes';

ReactDOM.render(
  <Router routes={routes}>
    <App />
  </Router>,
  document.getElementById('root')
);
```
Then, use Routes component where you want the routes to be rendered:

```tsx
const App = () => {
  return (
    <div className="App">
      <header className="App-header">
        <img src={logo} className="App-logo" alt="logo" />
        <Routes />
      </header>
    </div>
  );
};
export default App;
```

Routes are defined as an array of routes. A route is an object with a path and a JSX Component that will be rendered when the path match the current location. I like to define them in a standalone file, as it allows me or anyone reading the code to get a quick grasp of all of the routing capabilities of the application:

```tsx
import Route1 from './Components/Route1';
import Route3 from './Components/Route3';

export const routes: = [
  {
    path: '/',
    component: <Route1 />
  },
  {
    path: '/route3/:param1/:param2',
    component: <Route3 />
  }
];
```

A react hook is provided to access router resources anywhere inside the Router component.

```tsx
const {location, context, params, setLocation, setContext} = useLocation();
```

For example, it is straightforward to access the route params from the routed component:

```tsx
import {useLocation} from 'react-awesome-router';

const Route3 = () => {
  const {params} = useLocation();

  return (
    <div className="route">
      <div>Param1: {params.param1}</div>
      <div>Param2: {params.param2}</div>
    </div>
  );
};

export default Route3;
```

## Middlewares

One thing i like a lot about Angular Router is the ability to define custom middlewares that are executed during route resolution. For example, to implement a basic authentication mechanism with a declarative routing library in React, you have to rely on creating your own ```<PrivateRoute>``` component with the desired routing logic inside and then conditionally render a normal ```<Route>``` . While it is not necessary a bad aproach and works great on some use-cases, I experienced that as the requirements of the application grow (multiple user roles, confirming route changes, fallbacks), you end up with either a really big ```<PrivateRoute>``` or with more custom routing components like ```<AdmineRoute>```, ```<ConfirmRoute>```, etc. Again, while not necessary bad, I prefer a more funcional approach where we can combine or compose this route logic.

> "Sometimes, the elegant implementation is just a function.  Not a method.  Not a class.  Not a framework.  Just a function."    
> -- John Carmack

With ```react-awesome-router``` you can define guards. Guards are executed after route resolution and before component render, allowing to conditionally render the component based on custom rules like authentication or user role:

```tsx
const authGuard = (router, next) => {
  const authenticated = !!router.context?.auth?.logued;
  if (authenticated) {
    return next();
  } else {
    return <Unauthorized />;
  }
};

export const routes = [
  {
    path: '/',
    component: <Route1 />
  },
  {
    path: '/private',
    component: <Route2 />,
    guards: [authGuard]
  }
];
```

With guards, you can, for example, change or extend the routing logic of a single route without having to create a new component, just a guard. Also, since middlewares are functions, they are easy to understand, simple to test and trivially composable.

For further explanation, feature requests, issue reporting and examples:
[react-awesome-router on Github](https://github.com/hryuk/react-awesome-router)

That's all, thanks for reading!