# docker vite test & bug report

## steps

- `yarn create vite-app .`
- `yarn`
- `yarn add --dev typescript`
- add shims

  - shims-vue.d.ts (copied from new typescript made with cli)

    ```typescript
    declare module "*.vue" {
      import { defineComponent } from "vue";
      const component: ReturnType<typeof defineComponent>;
      export default component;
    }
    ```

- add tsconfig.json (copied from new typescript made with cli)

  ```typescript
  {
    "compilerOptions": {
      "target": "esnext",
      "module": "esnext",
      "strict": true,
      "jsx": "preserve",
      "importHelpers": true,
      "moduleResolution": "node",
      "esModuleInterop": true,
      "allowSyntheticDefaultImports": true,
      "sourceMap": true,
      "baseUrl": ".",
      "types": [
        "webpack-env",
        "jest"
      ],
      "paths": {
        "@/*": [
          "src/*"
        ]
      },
      "lib": [
        "esnext",
        "dom",
        "dom.iterable",
        "scripthost"
      ]
    },
    "include": [
      "src/**/*.ts",
      "src/**/*.tsx",
      "src/**/*.vue",
      "tests/**/*.ts",
      "tests/**/*.tsx"
    ],
    "exclude": [
      "node_modules"
    ]
  }
  ```

- change `main.js` to `main.ts`
- in index.html change
  `<script type="module" src="/src/main.js"></script>`
  to
  `<script type="module" src="/src/main.ts"></script>`
- verify it still runs using `yarn dev`
