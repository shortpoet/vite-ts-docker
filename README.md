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
- add Dockerfile

  ```dockerfile
  FROM node:12

  WORKDIR /usr/src/app

  COPY package*.json yarn.lock ./

  RUN [ "/bin/bash", "-c", "yarn install --pure-lockfile 2> >(grep -v warning 1>&2) && mv node_modules ../"]

  ENV PATH /usr/node_modules/.bin:$PATH

  COPY . .

  EXPOSE 3000

  LABEL maintainer="Carlos Soriano <shortpoet@github>"
  ```

- add docker-compose.yml

  ```yml
  version: "3.4"

  services:
    client:
      image: shortpoet/vite
      build:
        context: .
        dockerfile: Dockerfile
      tty: true
      stdin_open: true
      working_dir: /usr/src/app
      ports:
        - 3000:3000
      volumes:
        - .:/usr/src/app
      command: yarn vite
  ```

- error when running `yarn dev` in docker container

  ```bash
  client_1  | [vite] error while transforming /usr/src/app/src/main.ts with esbuild:
  client_1  | Error: The service was stopped
  client_1  |     at /usr/src/app/node_modules/esbuild/lib/main.js:405:31
  client_1  |     at Socket.afterClose (/usr/src/app/node_modules/esbuild/lib/main.js:331:7)
  client_1  |     at Socket.emit (events.js:327:22)
  client_1  |     at endReadableNT (_stream_readable.js:1220:12)
  client_1  |     at processTicksAndRejections (internal/process/task_queues.js:84:21)
  ```
