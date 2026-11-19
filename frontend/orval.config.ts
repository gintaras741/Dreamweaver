import { defineConfig } from 'orval';

// Generates the API client + react-query hooks. Run `make openapi`, don't edit the generated files.
export default defineConfig({
  dreamweaver: {
    input: {
      target: '../docs/openapi.json',
    },
    output: {
      mode: 'tags-split',
      target: 'src/api/generated/endpoints',
      schemas: 'src/api/generated/model',
      client: 'react-query',
      httpClient: 'fetch',
      clean: true,
      formatter: 'prettier',
      override: {
        mutator: {
          path: 'src/api/http.ts',
          name: 'http',
        },
      },
    },
  },
});
