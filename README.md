# bord-frontend-monorepo-pilot

Nx monorepo for Bord's frontend applications and microfrontends (React + Vite).

<a alt="Nx logo" href="https://nx.dev" target="_blank" rel="noreferrer"><img src="https://raw.githubusercontent.com/nrwl/nx/master/images/nx-logo.png" width="45"></a>

[Aprende más sobre esta configuración de workspace](https://nx.dev/getting-started/tutorials/react-monorepo-tutorial?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) o corre `npx nx graph` para explorar visualmente lo que se generó.

## Requisitos

Este repo fija su versión de Node en `.nvmrc`. Antes de correr cualquier comando, asegúrate de estar en la versión correcta:

```sh
nvm use
```

Usar una versión de Node distinta (por ejemplo, un daemon viejo corriendo con otra versión) es una causa común de que Nx falle al procesar el project graph.

## Proyectos

| App                      | Puerto dev | Puerto preview |
| ------------------------ | ---------- | -------------- |
| `my-app-nx`              | 4200       | 4300           |
| `my-second-app`          | 4201       | 4301           |
| `@bord/mfe-address-form` | 4202       | 4302           |

## Correr tareas

Para levantar el servidor de desarrollo de una app:

```sh
npx nx dev my-app-nx
```

Para levantar todas las apps a la vez:

```sh
npx nx run-many --target=dev --all
```

Para generar un build de producción:

```sh
npx nx build my-app-nx
```

Para ver todos los targets disponibles de un proyecto:

```sh
npx nx show project my-app-nx
```

Estos targets están [inferidos automáticamente](https://nx.dev/concepts/inferred-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) o definidos en los archivos `project.json` o `package.json`.

[Más sobre correr tareas en la documentación »](https://nx.dev/features/run-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Agregar nuevos proyectos

Aunque podrías agregar proyectos al workspace manualmente, te conviene usar los [plugins de Nx](https://nx.dev/concepts/nx-plugins?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) y su función de [generación de código](https://nx.dev/features/generate-code?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects).

Usa el generador del plugin para crear nuevos proyectos.

Para generar una nueva aplicación:

```sh
npx nx g @nx/react:app demo
```

Para generar una nueva librería:

```sh
npx nx g @nx/react:lib mylib
```

Puedes usar `npx nx list` para ver la lista de plugins instalados. Luego, corre `npx nx list <plugin-name>` para conocer las capacidades específicas de un plugin. Alternativamente, [instala Nx Console](https://nx.dev/getting-started/editor-setup?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) para explorar plugins y generadores desde tu IDE.

[Más sobre los plugins de Nx »](https://nx.dev/concepts/nx-plugins?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects) | [Explorar el registro de plugins »](https://nx.dev/plugin-registry?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Convenciones de commits y hooks

Este repo usa [Husky](https://typicode.github.io/husky/) para correr validaciones automáticas en cada commit.

### `pre-commit`

- Formatea los archivos staged con [lint-staged](https://github.com/okonet/lint-staged) + Prettier.
- Corre `lint` y `typecheck` sobre los proyectos afectados con `npx nx affected -t lint,typecheck --uncommitted`.

Si alguna de estas validaciones falla, el commit se cancela hasta corregir los errores.

### `commit-msg`

El mensaje de commit debe seguir el formato de [Conventional Commits](https://www.conventionalcommits.org/):

```
tipo: descripción
```

Tipos permitidos: `feat`, `fix`, `docs`, `style`, `refactor`, `perf`, `test`, `build`, `ci`, `chore`, `revert`.

Ejemplo:

```
feat: agregar validación de login
```

## Despliegue

Actualmente solo `@bord/mfe-address-form` tiene pipeline de despliegue configurado. Hay dos maneras de generar un artefacto desplegable:

### Opción A — Pipeline de CI (AWS CodeBuild → S3 + CloudFront)

Definido en [`apps/bord-address-form/devops/buildspec-frontend.yml`](apps/bord-address-form/devops/buildspec-frontend.yml). En resumen:

1. Instala dependencias (`npm ci`) con Node 24, alineado a `.nvmrc`.
2. Asume un rol cross-account de AWS y obtiene `VITE_SUBSCRIPTION` y `VITE_ORGANIZATION` desde SSM Parameter Store (rutas `/bord-address-form/VITE_SUBSCRIPTION` y `/bord-address-form/VITE_ORGANIZATION`).
3. Corre `npx nx build bord-address-form`.
4. Sincroniza `apps/bord-address-form/dist/` a un bucket S3 (`$S3_BUCKET_FRONTEND_NAME`) e invalida la cache de CloudFront (`$CLOUDFRONTDISTRIBUTION`).

### Opción B — Contenedor Docker (nginx)

Definido en [`Dockerfile`](Dockerfile), [`docker-compose.yml`](docker-compose.yml) y [`default.conf`](default.conf):

```sh
docker compose up --build
```

Esto compila `bord-address-form` (configurable con el build arg `APP_NAME`) y sirve el `dist/` resultante con nginx en el puerto 80, con:

- Fallback de SPA (`try_files ... /index.html`) para que las rutas de TanStack Router funcionen al refrescar.
- Cache larga (`max`) para JS/CSS/imágenes, sin cache (`epoch`) para `index.html`, para que los deploys se reflejen sin purgar todo.
- Endpoint `/gke_health` para health checks.

### Preguntas frecuentes al desplegar

- **¿Qué versión de Node debo usar?** La fijada en `.nvmrc` (`nvm use`). Ambos pipelines (CodeBuild y Docker) también la usan.
- **¿De dónde salen `VITE_SUBSCRIPTION` y `VITE_ORGANIZATION`?** En CI, de SSM Parameter Store. Si corres `docker compose up --build` localmente, **no se están pasando** — hay que agregarlos como build args en `docker-compose.yml` o exportarlos como variables de entorno antes de buildear, si la app los necesita para funcionar.
- **¿Por qué hay un endpoint `/gke_health` si el pipeline de CI apunta a S3 + CloudFront (AWS)?** Son dos rutas de despliegue distintas conviviendo en el repo. Antes de desplegar por Docker/GKE, confirma si ese es realmente un target activo o si es configuración heredada de otro proyecto.
- **¿Necesito un `.dockerignore`?** Todavía no existe uno. Sin él, `docker build` copia `node_modules/`, `.git/` y los `dist/` de otras apps al contexto de build, haciéndolo más lento de lo necesario.
- **¿Cómo sé si mi cambio pasa los checks antes de desplegar?** `npx nx run-many -t lint,typecheck,test,build --all` (o `npx nx affected -t lint,typecheck,test,build` para solo lo afectado).
- **¿El build local (`npx nx build <app>`) es igual al de producción?** Sí, ambos pipelines corren exactamente `npx nx build <app>` — no hay pasos adicionales ocultos.

## Configurar CI

### Paso 1

Para conectar con Nx Cloud, corre:

```sh
npx nx connect
```

Conectarte a Nx Cloud asegura un pipeline de CI [rápido y escalable](https://nx.dev/ci/intro/why-nx-cloud?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects), con funciones como:

- [Caché remoto](https://nx.dev/ci/features/remote-cache?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Distribución de tareas entre múltiples máquinas](https://nx.dev/ci/features/distribute-task-execution?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [División automática de tests e2e](https://nx.dev/ci/features/split-e2e-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Detección y reintento de tareas inestables](https://nx.dev/ci/features/flaky-tasks?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

### Paso 2

Usa el siguiente comando para configurar un workflow de CI para el workspace:

```sh
npx nx g ci-workflow
```

[Más sobre Nx en CI](https://nx.dev/ci/intro/ci-with-nx#ready-get-started-with-your-provider?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Instalar Nx Console

Nx Console es una extensión de editor que mejora tu experiencia de desarrollo. Te permite correr tareas, generar código y mejora el autocompletado de código en tu IDE. Está disponible para VSCode e IntelliJ.

[Instalar Nx Console »](https://nx.dev/getting-started/editor-setup?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

## Enlaces útiles

Aprende más:

- [Más sobre esta configuración de workspace](https://nx.dev/getting-started/tutorials/react-monorepo-tutorial?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Más sobre Nx en CI](https://nx.dev/ci/intro/ci-with-nx?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [Publicar paquetes con Nx release](https://nx.dev/features/manage-releases?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
- [¿Qué son los plugins de Nx?](https://nx.dev/concepts/nx-plugins?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)

Y únete a la comunidad de Nx:

- [Discord](https://go.nx.dev/community)
- [Síguenos en X](https://twitter.com/nxdevtools) o [LinkedIn](https://www.linkedin.com/company/nrwl)
- [Nuestro canal de Youtube](https://www.youtube.com/@nxdevtools)
- [Nuestro blog](https://nx.dev/blog?utm_source=nx_project&utm_medium=readme&utm_campaign=nx_projects)
